import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_op.freezed.dart';
part 'edit_op.g.dart';

enum EditOpBoolField {
  @JsonValue('archive')
  archive,
  @JsonValue('favorite')
  favorite,
}

enum EditOpStringField {
  @JsonValue('note')
  note,
}

@Freezed(unionKey: 'op', unionValueCase: FreezedUnionCase.snake)
sealed class EditOp with _$EditOp {
  const EditOp._();

  const factory EditOp.insert({String? title, required String url}) =
      EditOpInsert;

  const factory EditOp.setBool({
    required int id,
    required EditOpBoolField field,
    required bool value,
  }) = EditOpSetBool;

  const factory EditOp.setString({
    required int id,
    required EditOpStringField field,
    required String value,
  }) = EditOpSetString;

  const factory EditOp.delete({required int id}) = EditOpDelete;

  factory EditOp.fromJson(Map<String, dynamic> json) => _$EditOpFromJson(json);

  /// Returns the associated link ID if applicable, or null for insert operations.
  int? get maybeId => switch (this) {
    EditOpInsert() => null,
    EditOpSetBool(:final id) => id,
    EditOpSetString(:final id) => id,
    EditOpDelete(:final id) => id,
  };
}
