import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Preferences {
  Preferences._(); // ✅ Constructor privado único

  static final Preferences _instance = Preferences._();
  factory Preferences() => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefsInstance {
    if (_prefs == null) {
      throw StateError(
          'Preferences no inicializado. Llama a Preferences().init() en main().');
    }
    return _prefs!;
  }

  // Claves
  static const String _token = 'auth_token';
  static const String _userId = 'user_id';
  static const String _userEmail = 'user_email';
  static const String _themeMode = 'theme_mode';
  static const String _biometrics = 'biometrics_enabled';
  static const String _notifications = 'notifications_enabled';
  static const String _lastSync = 'last_sync_ts';
  static const String _onboardingDone = 'onboarding_done';
  static const String _language = 'app_language';

  // Getters
  String? get token => _prefsInstance.getString(_token);
  String? get userId => _prefsInstance.getString(_userId);
  String? get userEmail => _prefsInstance.getString(_userEmail);
  int get themeMode => _prefsInstance.getInt(_themeMode) ?? 0;
  bool get biometricsEnabled => _prefsInstance.getBool(_biometrics) ?? false;
  bool get notificationsEnabled =>
      _prefsInstance.getBool(_notifications) ?? true;
  DateTime? get lastSync {
    final ts = _prefsInstance.getInt(_lastSync);
    return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  bool get isOnboardingCompleted =>
      _prefsInstance.getBool(_onboardingDone) ?? false;
  String get language => _prefsInstance.getString(_language) ?? 'es';

  // Setters
  Future<void> setToken(String? value) =>
      _safe(() => _prefsInstance.setString(_token, value!));
  Future<void> setUserId(String? value) =>
      _safe(() => _prefsInstance.setString(_userId, value!));
  Future<void> setUserEmail(String? value) =>
      _safe(() => _prefsInstance.setString(_userEmail, value!));
  Future<void> setThemeMode(int value) =>
      _safe(() => _prefsInstance.setInt(_themeMode, value));
  Future<void> setBiometrics(bool value) =>
      _safe(() => _prefsInstance.setBool(_biometrics, value));
  Future<void> setNotifications(bool value) =>
      _safe(() => _prefsInstance.setBool(_notifications, value));
  Future<void> setLastSync(DateTime value) => _safe(
      () => _prefsInstance.setInt(_lastSync, value.millisecondsSinceEpoch));
  Future<void> setOnboardingDone(bool value) =>
      _safe(() => _prefsInstance.setBool(_onboardingDone, value));
  Future<void> setLanguage(String value) =>
      _safe(() => _prefsInstance.setString(_language, value));

  Future<void> clearAuth() async {
    await _prefsInstance.remove(_token);
    await _prefsInstance.remove(_userId);
    await _prefsInstance.remove(_userEmail);
  }

  Future<void> clearAll() => _safe(_prefsInstance.clear);
  Future<void> remove(String key) => _safe(() => _prefsInstance.remove(key));

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('⚠️ Error prefs: $e');
    }
  }
}
