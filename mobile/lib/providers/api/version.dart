import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/server_info.dart';
import './api.dart';
import '../bindings/package_info.dart';
import '../bindings/shared_preferences.dart';

part 'version.g.dart';

@riverpod
Future<String> appVersionLine(Ref ref) async {
  final info = await ref.watch(packageInfoProvider.future);

  final apiUrl = await ref.watch(
    preferenceProvider(SharedPreferenceKey.apiUrl).future,
  );

  ServerInfo? serverInfo;
  try {
    serverInfo = await ref.watch(serverInfoProvider.future);
  } catch (e) {
    serverInfo = null;
  }

  return [
    'App Version: ${info.version}',
    'Build: ${info.buildNumber}',
    if (info.updateTime != null) 'Release Date: ${info.updateTime}',
    "API URL: $apiUrl",
    if (serverInfo != null) 'Server Version ID: ${serverInfo.version.id}',
    if (serverInfo != null) 'Server Version Tag: ${serverInfo.version.tag}',
    if (serverInfo != null && serverInfo.version.timestamp != null)
      'Server Version Timestamp: ${serverInfo.version.timestamp}',
  ].join("\n");
}
