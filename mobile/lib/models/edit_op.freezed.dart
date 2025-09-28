// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_op.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
EditOp _$EditOpFromJson(
  Map<String, dynamic> json
) {
        switch (json['op']) {
                  case 'set':
          return EditOpSet.fromJson(
            json
          );
                case 'delete':
          return EditOpDelete.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'op',
  'EditOp',
  'Invalid union type "${json['op']}"!'
);
        }
      
}

/// @nodoc
mixin _$EditOp implements DiagnosticableTreeMixin {

 int get id;
/// Create a copy of EditOp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditOpCopyWith<EditOp> get copyWith => _$EditOpCopyWithImpl<EditOp>(this as EditOp, _$identity);

  /// Serializes this EditOp to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditOp'))
    ..add(DiagnosticsProperty('id', id));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditOp&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditOp(id: $id)';
}


}

/// @nodoc
abstract mixin class $EditOpCopyWith<$Res>  {
  factory $EditOpCopyWith(EditOp value, $Res Function(EditOp) _then) = _$EditOpCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class _$EditOpCopyWithImpl<$Res>
    implements $EditOpCopyWith<$Res> {
  _$EditOpCopyWithImpl(this._self, this._then);

  final EditOp _self;
  final $Res Function(EditOp) _then;

/// Create a copy of EditOp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EditOp].
extension EditOpPatterns on EditOp {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditOpSet value)?  set,TResult Function( EditOpDelete value)?  delete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditOpSet() when set != null:
return set(_that);case EditOpDelete() when delete != null:
return delete(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditOpSet value)  set,required TResult Function( EditOpDelete value)  delete,}){
final _that = this;
switch (_that) {
case EditOpSet():
return set(_that);case EditOpDelete():
return delete(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditOpSet value)?  set,TResult? Function( EditOpDelete value)?  delete,}){
final _that = this;
switch (_that) {
case EditOpSet() when set != null:
return set(_that);case EditOpDelete() when delete != null:
return delete(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int id,  EditOpField field,  bool value)?  set,TResult Function( int id)?  delete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditOpSet() when set != null:
return set(_that.id,_that.field,_that.value);case EditOpDelete() when delete != null:
return delete(_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int id,  EditOpField field,  bool value)  set,required TResult Function( int id)  delete,}) {final _that = this;
switch (_that) {
case EditOpSet():
return set(_that.id,_that.field,_that.value);case EditOpDelete():
return delete(_that.id);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int id,  EditOpField field,  bool value)?  set,TResult? Function( int id)?  delete,}) {final _that = this;
switch (_that) {
case EditOpSet() when set != null:
return set(_that.id,_that.field,_that.value);case EditOpDelete() when delete != null:
return delete(_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class EditOpSet with DiagnosticableTreeMixin implements EditOp {
  const EditOpSet({required this.id, required this.field, required this.value, final  String? $type}): $type = $type ?? 'set';
  factory EditOpSet.fromJson(Map<String, dynamic> json) => _$EditOpSetFromJson(json);

@override final  int id;
 final  EditOpField field;
 final  bool value;

@JsonKey(name: 'op')
final String $type;


/// Create a copy of EditOp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditOpSetCopyWith<EditOpSet> get copyWith => _$EditOpSetCopyWithImpl<EditOpSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditOpSetToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditOp.set'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('field', field))..add(DiagnosticsProperty('value', value));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditOpSet&&(identical(other.id, id) || other.id == id)&&(identical(other.field, field) || other.field == field)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,field,value);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditOp.set(id: $id, field: $field, value: $value)';
}


}

/// @nodoc
abstract mixin class $EditOpSetCopyWith<$Res> implements $EditOpCopyWith<$Res> {
  factory $EditOpSetCopyWith(EditOpSet value, $Res Function(EditOpSet) _then) = _$EditOpSetCopyWithImpl;
@override @useResult
$Res call({
 int id, EditOpField field, bool value
});




}
/// @nodoc
class _$EditOpSetCopyWithImpl<$Res>
    implements $EditOpSetCopyWith<$Res> {
  _$EditOpSetCopyWithImpl(this._self, this._then);

  final EditOpSet _self;
  final $Res Function(EditOpSet) _then;

/// Create a copy of EditOp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? field = null,Object? value = null,}) {
  return _then(EditOpSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as EditOpField,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class EditOpDelete with DiagnosticableTreeMixin implements EditOp {
  const EditOpDelete({required this.id, final  String? $type}): $type = $type ?? 'delete';
  factory EditOpDelete.fromJson(Map<String, dynamic> json) => _$EditOpDeleteFromJson(json);

@override final  int id;

@JsonKey(name: 'op')
final String $type;


/// Create a copy of EditOp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditOpDeleteCopyWith<EditOpDelete> get copyWith => _$EditOpDeleteCopyWithImpl<EditOpDelete>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditOpDeleteToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'EditOp.delete'))
    ..add(DiagnosticsProperty('id', id));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditOpDelete&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'EditOp.delete(id: $id)';
}


}

/// @nodoc
abstract mixin class $EditOpDeleteCopyWith<$Res> implements $EditOpCopyWith<$Res> {
  factory $EditOpDeleteCopyWith(EditOpDelete value, $Res Function(EditOpDelete) _then) = _$EditOpDeleteCopyWithImpl;
@override @useResult
$Res call({
 int id
});




}
/// @nodoc
class _$EditOpDeleteCopyWithImpl<$Res>
    implements $EditOpDeleteCopyWith<$Res> {
  _$EditOpDeleteCopyWithImpl(this._self, this._then);

  final EditOpDelete _self;
  final $Res Function(EditOpDelete) _then;

/// Create a copy of EditOp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(EditOpDelete(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
