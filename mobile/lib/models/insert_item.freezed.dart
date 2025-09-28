// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insert_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsertItem implements DiagnosticableTreeMixin {

 String get url; String? get title;
/// Create a copy of InsertItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsertItemCopyWith<InsertItem> get copyWith => _$InsertItemCopyWithImpl<InsertItem>(this as InsertItem, _$identity);

  /// Serializes this InsertItem to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InsertItem'))
    ..add(DiagnosticsProperty('url', url))..add(DiagnosticsProperty('title', title));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsertItem&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,title);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InsertItem(url: $url, title: $title)';
}


}

/// @nodoc
abstract mixin class $InsertItemCopyWith<$Res>  {
  factory $InsertItemCopyWith(InsertItem value, $Res Function(InsertItem) _then) = _$InsertItemCopyWithImpl;
@useResult
$Res call({
 String url, String? title
});




}
/// @nodoc
class _$InsertItemCopyWithImpl<$Res>
    implements $InsertItemCopyWith<$Res> {
  _$InsertItemCopyWithImpl(this._self, this._then);

  final InsertItem _self;
  final $Res Function(InsertItem) _then;

/// Create a copy of InsertItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? title = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InsertItem].
extension InsertItemPatterns on InsertItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsertItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsertItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsertItem value)  $default,){
final _that = this;
switch (_that) {
case _InsertItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsertItem value)?  $default,){
final _that = this;
switch (_that) {
case _InsertItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsertItem() when $default != null:
return $default(_that.url,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? title)  $default,) {final _that = this;
switch (_that) {
case _InsertItem():
return $default(_that.url,_that.title);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _InsertItem() when $default != null:
return $default(_that.url,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsertItem with DiagnosticableTreeMixin implements InsertItem {
  const _InsertItem({required this.url, this.title});
  factory _InsertItem.fromJson(Map<String, dynamic> json) => _$InsertItemFromJson(json);

@override final  String url;
@override final  String? title;

/// Create a copy of InsertItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsertItemCopyWith<_InsertItem> get copyWith => __$InsertItemCopyWithImpl<_InsertItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsertItemToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InsertItem'))
    ..add(DiagnosticsProperty('url', url))..add(DiagnosticsProperty('title', title));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsertItem&&(identical(other.url, url) || other.url == url)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,title);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InsertItem(url: $url, title: $title)';
}


}

/// @nodoc
abstract mixin class _$InsertItemCopyWith<$Res> implements $InsertItemCopyWith<$Res> {
  factory _$InsertItemCopyWith(_InsertItem value, $Res Function(_InsertItem) _then) = __$InsertItemCopyWithImpl;
@override @useResult
$Res call({
 String url, String? title
});




}
/// @nodoc
class __$InsertItemCopyWithImpl<$Res>
    implements _$InsertItemCopyWith<$Res> {
  __$InsertItemCopyWithImpl(this._self, this._then);

  final _InsertItem _self;
  final $Res Function(_InsertItem) _then;

/// Create a copy of InsertItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? title = freezed,}) {
  return _then(_InsertItem(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
