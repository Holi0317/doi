import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'edit_op.freezed.dart';
part 'edit_op.g.dart';

enum EditOpField {
  @JsonValue('archive')
  archive,
  @JsonValue('favorite')
  favorite,
}

@Freezed(unionKey: 'op')
sealed class EditOp with _$EditOp {
  const factory EditOp.set({
    required int id,
    required EditOpField field,
    required bool value,
  }) = EditOpSet;

  const factory EditOp.delete({required int id}) = EditOpDelete;

  factory EditOp.fromJson(Map<String, dynamic> json) => _$EditOpFromJson(json);
}
