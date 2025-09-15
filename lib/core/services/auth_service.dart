import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  static AuthService? _instance;
  static SharedPreferences? _prefs;

  AuthService._();

  static Future<AuthService> get instance async {
    if (_instance == null) {
      _instance = AuthService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Ensure SharedPreferences is initialized
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  // Token management
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(_accessTokenKey, accessToken);
      print('✅ Access token saved: ${accessToken.substring(0, 20)}...');

      if (refreshToken != null) {
        await prefs.setString(_refreshTokenKey, refreshToken);
        print('✅ Refresh token saved: ${refreshToken.substring(0, 20)}...');
      }
    } catch (e) {
      print('❌ Error saving tokens: $e');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userDataKey);
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await getAccessToken();
      print(
          '🔍 Checking authentication - Token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('❌ Error checking authentication: $e');
      return false;
    }
  }

  // User data management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(_userDataKey, userData.toString());
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await _preferences;
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString != null) {
        // Parse the string back to Map (simplified implementation)
        // In a real app, you'd use jsonEncode/jsonDecode
        return {};
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Authentication methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiService.instance.login(email, password);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['accessToken'] != null) {
          await saveTokens(accessToken: data['accessToken']);
          return {'success': true, 'data': data};
        }
      }

      return {'success': false, 'message': 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await ApiService.instance.register(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['accessToken'] != null) {
          await saveTokens(accessToken: data['accessToken']);
          return {'success': true, 'data': data};
        }
      }

      return {'success': false, 'message': 'Registration failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> guestLogin() async {
    try {
      final response = await ApiService.instance.guestLogin();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['accessToken'] != null) {
          await saveTokens(accessToken: data['accessToken']);
          return {'success': true, 'data': data};
        }
      }

      return {'success': false, 'message': 'Guest login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return {'success': false, 'message': 'No refresh token available'};
      }

      final response = await ApiService.instance.refreshToken();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['accessToken'] != null) {
          await saveTokens(accessToken: data['accessToken']);
          return {'success': true, 'data': data};
        }
      }

      return {'success': false, 'message': 'Token refresh failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await ApiService.instance.logout();
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await clearTokens();
    }

    return {'success': true};
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.instance.getMyProfile();

      if (response.statusCode == 200) {
        final data = response.data;
        await saveUserData(data);
        return {'success': true, 'data': data};
      }

      return {'success': false, 'message': 'Failed to get profile'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
