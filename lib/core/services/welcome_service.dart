import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeService {
  static const String _hasSeenWelcomeModalKey = 'has_seen_welcome_modal';
  static WelcomeService? _instance;
  static SharedPreferences? _prefs;

  WelcomeService._();

  static Future<WelcomeService> get instance async {
    if (_instance == null) {
      _instance = WelcomeService._();
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

  // Check if user has seen the welcome modal
  Future<bool> hasSeenWelcomeModal() async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(_hasSeenWelcomeModalKey) ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking welcome modal status: $e');
      }
      return false;
    }
  }

  // Mark welcome modal as seen
  Future<void> markWelcomeModalAsSeen() async {
    try {
      final prefs = await _preferences;
      await prefs.setBool(_hasSeenWelcomeModalKey, true);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error marking welcome modal as seen: $e');
      }
    }
  }

  // Reset welcome modal status (for testing or if needed)
  Future<void> resetWelcomeModalStatus() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_hasSeenWelcomeModalKey);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error resetting welcome modal status: $e');
      }
    }
  }
}
