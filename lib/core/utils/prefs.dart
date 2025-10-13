import 'package:shared_preferences/shared_preferences.dart';

/// Simple preferences manager for app settings
class Prefs {
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyFirstLaunch = 'first_launch';

  static SharedPreferences? _prefs;

  /// Initialize preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if onboarding is complete
  static bool get hasCompletedOnboarding {
    return _prefs?.getBool(_keyOnboardingComplete) ?? false;
  }

  /// Mark onboarding as complete
  static Future<void> setOnboardingComplete() async {
    await _prefs?.setBool(_keyOnboardingComplete, true);
  }

  /// Check if this is first launch
  static bool get isFirstLaunch {
    return _prefs?.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark as not first launch
  static Future<void> setNotFirstLaunch() async {
    await _prefs?.setBool(_keyFirstLaunch, false);
  }

  /// Reset all preferences (for testing)
  static Future<void> reset() async {
    await _prefs?.clear();
  }
}
