import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

@riverpod
class ApiUrlPreference extends _$ApiUrlPreference {
  @override
  Future<String> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getString('api_url') ?? 'http://100.66.229.117:8787/api';
  }

  Future<void> set(String url) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setString('api_url', url);
    // Update the state to notify listeners
    state = AsyncValue.data(url);
  }
}

@riverpod
class ApiTokenPreference extends _$ApiTokenPreference {
  @override
  Future<String> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getString('api_token') ?? '';
    // 86ed8dece3ba61d2
  }

  Future<void> set(String url) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setString('api_token', url);
    // Update the state to notify listeners
    state = AsyncValue.data(url);
  }
}
