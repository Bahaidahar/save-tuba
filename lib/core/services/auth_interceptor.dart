import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthInterceptor extends Interceptor {
  static const String _baseUrl = 'https://savetuba.it2-server.com';
  static const String _apiVersion = '/api/v1';
  static const String _baseApiUrl = '$_baseUrl$_apiVersion';

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  // Method to manually clear tokens
  static Future<void> clearTokens() async {
    try {
      final prefs = await _preferences;
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      print('Tokens cleared manually');
    } catch (e) {
      print('Error clearing tokens manually: $e');
    }
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Add auth token if available
      final prefs = await _preferences;
      final token = prefs.getString('access_token');

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      print('Error getting token in interceptor: $e');
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403) {
      // Forbidden - possibly invalid token, clear it
      try {
        final prefs = await _preferences;
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        print('Cleared tokens due to 403 Forbidden error');
      } catch (clearError) {
        print('Error clearing tokens on 403: $clearError');
      }
    } else if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      try {
        final prefs = await _preferences;
        final refreshToken = prefs.getString('refresh_token');

        if (refreshToken != null) {
          // Use ApiService for token refresh
          final apiService = ApiService.instance;
          final response = await apiService.refreshTokenWithToken(refreshToken);

          if (response.statusCode == 200) {
            final newToken = response.data['accessToken'];
            await prefs.setString('access_token', newToken);

            // Retry the original request
            final originalRequest = err.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer $newToken';

            // Use the same Dio instance to retry
            final retryResponse = await apiService.dio.fetch(originalRequest);
            handler.resolve(retryResponse);
            return;
          }
        }
      } catch (e) {
        print('Error refreshing token: $e');
        // Refresh failed, clear tokens and redirect to login
        try {
          final prefs = await _preferences;
          await prefs.remove('access_token');
          await prefs.remove('refresh_token');
        } catch (clearError) {
          print('Error clearing tokens: $clearError');
        }
      }
    }

    handler.next(err);
  }
}
