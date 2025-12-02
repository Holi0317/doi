import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'link.freezed.dart';

part 'link.g.dart';

@freezed
abstract class Link with _$Link {
  const factory Link({
    required int id,
    required String title,
    required String url,
    required bool favorite,
    required bool archive,
    @JsonKey(name: 'created_at') required int createdAt,
    required String note,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}
