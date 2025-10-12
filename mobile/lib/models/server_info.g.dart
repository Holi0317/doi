// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerInfo _$ServerInfoFromJson(Map<String, dynamic> json) => _ServerInfo(
  name: json['name'] as String,
  version: WorkerVersion.fromJson(json['version'] as Map<String, dynamic>),
  session: json['session'] == null
      ? null
      : Session.fromJson(json['session'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ServerInfoToJson(_ServerInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'session': instance.session,
    };

_WorkerVersion _$WorkerVersionFromJson(Map<String, dynamic> json) =>
    _WorkerVersion(
      id: json['id'] as String,
      tag: json['tag'] as String,
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$WorkerVersionToJson(_WorkerVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'timestamp': instance.timestamp,
    };

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  source: json['source'] as String,
  name: json['name'] as String,
  login: json['login'] as String,
  avatarUrl: json['avatarUrl'] as String,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'source': instance.source,
  'name': instance.name,
  'login': instance.login,
  'avatarUrl': instance.avatarUrl,
};
