import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String keyRememberMe = 'remember_me';
  static const String keyEmail = 'saved_email';
  static const String keyPassword = 'saved_password';
  static const String keyHasSeenApp = 'has_seen_app';
  static const String keySessionUserId = 'session_user_id';
  static const String keyPhoneRememberMe = 'phone_remember_me';
  static const String keySavedPhone = 'saved_phone';
  static const String keySavedLoginMode = 'saved_login_mode';

  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(keyHasSeenApp) ?? false);
  }

  // Add this new method
  Future<void> markAppAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyHasSeenApp, true);
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyRememberMe, true);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyPassword, password);
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyRememberMe, false);
    await prefs.remove(keyEmail);
    await prefs.remove(keyPassword);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyRememberMe) ?? false;
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(keyEmail),
      'password': prefs.getString(keyPassword),
    };
  }

  Future<void> savePhoneCredentials(String phone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyPhoneRememberMe, true);
    await prefs.setString(keySavedPhone, phone);
    await prefs.setString(keyPassword, password);
  }

  Future<void> clearPhoneCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyPhoneRememberMe, false);
    await prefs.remove(keySavedPhone);
  }

  Future<bool> getPhoneRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyPhoneRememberMe) ?? false;
  }

  Future<Map<String, String?>> getSavedPhoneCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'phone': prefs.getString(keySavedPhone),
      'password': prefs.getString(keyPassword),
    };
  }

  Future<void> saveLoginMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keySavedLoginMode, mode);
  }

  Future<String?> getSavedLoginMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySavedLoginMode);
  }

  Future<void> saveSessionUserId(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keySessionUserId, uid);
  }

  Future<String?> getSessionUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySessionUserId);
  }

  Future<void> clearSessionUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keySessionUserId);
  }

  static const String keyLocale = 'language_code';

  Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLocale, languageCode);
  }

  Future<String?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLocale);
  }
}
