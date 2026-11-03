import 'package:shared_preferences/shared_preferences.dart';

/// UI preferences only; never stores passwords, OTPs, or card details.
class LocalSettings {
  final _preferences = SharedPreferencesAsync();
  Future<String?> read(String key) => _preferences.getString(key);
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);
}
