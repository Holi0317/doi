// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_op.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditOpSetBool _$EditOpSetBoolFromJson(Map<String, dynamic> json) =>
    EditOpSetBool(
      id: (json['id'] as num).toInt(),
      field: $enumDecode(_$EditOpBoolFieldEnumMap, json['field']),
      value: json['value'] as bool,
      $type: json['op'] as String?,
    );

Map<String, dynamic> _$EditOpSetBoolToJson(EditOpSetBool instance) =>
    <String, dynamic>{
      'id': instance.id,
      'field': _$EditOpBoolFieldEnumMap[instance.field]!,
      'value': instance.value,
      'op': instance.$type,
    };

const _$EditOpBoolFieldEnumMap = {
  EditOpBoolField.archive: 'archive',
  EditOpBoolField.favorite: 'favorite',
};

EditOpSetString _$EditOpSetStringFromJson(Map<String, dynamic> json) =>
    EditOpSetString(
      id: (json['id'] as num).toInt(),
      field: $enumDecode(_$EditOpStringFieldEnumMap, json['field']),
      value: json['value'] as String,
      $type: json['op'] as String?,
    );

Map<String, dynamic> _$EditOpSetStringToJson(EditOpSetString instance) =>
    <String, dynamic>{
      'id': instance.id,
      'field': _$EditOpStringFieldEnumMap[instance.field]!,
      'value': instance.value,
      'op': instance.$type,
    };

const _$EditOpStringFieldEnumMap = {EditOpStringField.note: 'note'};

EditOpDelete _$EditOpDeleteFromJson(Map<String, dynamic> json) =>
    EditOpDelete(id: (json['id'] as num).toInt(), $type: json['op'] as String?);

Map<String, dynamic> _$EditOpDeleteToJson(EditOpDelete instance) =>
    <String, dynamic>{'id': instance.id, 'op': instance.$type};
