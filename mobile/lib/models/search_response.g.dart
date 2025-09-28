// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    _SearchResponse(
      count: (json['count'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
      cursor: json['cursor'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => Link.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResponseToJson(_SearchResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'hasMore': instance.hasMore,
      'cursor': instance.cursor,
      'items': instance.items,
    };
