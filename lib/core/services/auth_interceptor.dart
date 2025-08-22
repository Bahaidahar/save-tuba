import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      try {
        final prefs = await _preferences;
        final refreshToken = prefs.getString('refresh_token');

        if (refreshToken != null) {
          final dio = Dio();
          final response = await dio.post(
            '$_baseApiUrl/auth/refresh',
            options: Options(
              headers: {'Authorization': 'Bearer $refreshToken'},
            ),
          );

          if (response.statusCode == 200) {
            final newToken = response.data['accessToken'];
            await prefs.setString('access_token', newToken);

            // Retry the original request
            final originalRequest = err.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer $newToken';

            final retryResponse = await dio.fetch(originalRequest);
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
