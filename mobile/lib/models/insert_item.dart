import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insert_item.freezed.dart';
part 'insert_item.g.dart';

@freezed
abstract class InsertItem with _$InsertItem {
  const factory InsertItem({required String url, String? title}) = _InsertItem;

  factory InsertItem.fromJson(Map<String, dynamic> json) =>
      _$InsertItemFromJson(json);
}
