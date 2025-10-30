import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info.freezed.dart';
part 'server_info.g.dart';

@freezed
abstract class ServerInfo with _$ServerInfo {
  @Assert('name == "doi"', 'Invalid server info: name must be "doi"')
  const factory ServerInfo({
    required String name,
    required WorkerVersion version,
    Session? session,
  }) = _ServerInfo;

  factory ServerInfo.fromJson(Map<String, dynamic> json) =>
      _$ServerInfoFromJson(json);
}

@freezed
abstract class WorkerVersion with _$WorkerVersion {
  const factory WorkerVersion({
    required String id,
    required String tag,
    String? timestamp,
  }) = _WorkerVersion;

  factory WorkerVersion.fromJson(Map<String, dynamic> json) =>
      _$WorkerVersionFromJson(json);
}

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String source,
    required String name,
    required String login,
    required String avatarUrl,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
