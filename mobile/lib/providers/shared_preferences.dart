import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

/// Underlying SharedPreferences singleton.
@riverpod
Future<SharedPreferences> _sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

/// Keys for SharedPreferences.
///
/// Currently only supports String values.
enum SharedPreferenceKey {
  apiUrl('api_url', ''), // http://100.66.229.117:8787/api
  apiToken('api_token', '');

  final String key;
  final String defaultValue;

  const SharedPreferenceKey(this.key, this.defaultValue);
}

@riverpod
class Preference extends _$Preference {
  @override
  Future<String> build(SharedPreferenceKey key) async {
    final prefs = await ref.watch(_sharedPreferencesProvider.future);
    return prefs.getString(key.key) ?? key.defaultValue;
  }

  Future<void> set(String value) async {
    final prefs = await ref.read(_sharedPreferencesProvider.future);
    await prefs.setString(key.key, value);
    // Update the state to notify listeners
    state = AsyncValue.data(value);
  }

  Future<void> reset() async {
    final prefs = await ref.read(_sharedPreferencesProvider.future);
    await prefs.setString(key.key, key.defaultValue);
    // Update the state to notify listeners
    state = AsyncValue.data(key.defaultValue);
  }
}
