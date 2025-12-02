// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_op.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditOpSet _$EditOpSetFromJson(Map<String, dynamic> json) => EditOpSet(
  id: (json['id'] as num).toInt(),
  field: $enumDecode(_$EditOpFieldEnumMap, json['field']),
  value: json['value'] as bool,
  $type: json['op'] as String?,
);

Map<String, dynamic> _$EditOpSetToJson(EditOpSet instance) => <String, dynamic>{
  'id': instance.id,
  'field': _$EditOpFieldEnumMap[instance.field]!,
  'value': instance.value,
  'op': instance.$type,
};

const _$EditOpFieldEnumMap = {
  EditOpField.archive: 'archive',
  EditOpField.favorite: 'favorite',
};

EditOpDelete _$EditOpDeleteFromJson(Map<String, dynamic> json) =>
    EditOpDelete(id: (json['id'] as num).toInt(), $type: json['op'] as String?);

Map<String, dynamic> _$EditOpDeleteToJson(EditOpDelete instance) =>
    <String, dynamic>{'id': instance.id, 'op': instance.$type};

EditOpInsert _$EditOpInsertFromJson(Map<String, dynamic> json) => EditOpInsert(
  url: json['url'] as String,
  title: json['title'] as String?,
  $type: json['op'] as String?,
);

Map<String, dynamic> _$EditOpInsertToJson(EditOpInsert instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'op': instance.$type,
    };
