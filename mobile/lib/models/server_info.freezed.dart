// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerInfo {

 String get name; WorkerVersion get version; Session? get session;
/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerInfoCopyWith<ServerInfo> get copyWith => _$ServerInfoCopyWithImpl<ServerInfo>(this as ServerInfo, _$identity);

  /// Serializes this ServerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.session, session) || other.session == session));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,session);

@override
String toString() {
  return 'ServerInfo(name: $name, version: $version, session: $session)';
}


}

/// @nodoc
abstract mixin class $ServerInfoCopyWith<$Res>  {
  factory $ServerInfoCopyWith(ServerInfo value, $Res Function(ServerInfo) _then) = _$ServerInfoCopyWithImpl;
@useResult
$Res call({
 String name, WorkerVersion version, Session? session
});


$WorkerVersionCopyWith<$Res> get version;$SessionCopyWith<$Res>? get session;

}
/// @nodoc
class _$ServerInfoCopyWithImpl<$Res>
    implements $ServerInfoCopyWith<$Res> {
  _$ServerInfoCopyWithImpl(this._self, this._then);

  final ServerInfo _self;
  final $Res Function(ServerInfo) _then;

/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? version = null,Object? session = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as WorkerVersion,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,
  ));
}
/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerVersionCopyWith<$Res> get version {
  
  return $WorkerVersionCopyWith<$Res>(_self.version, (value) {
    return _then(_self.copyWith(version: value));
  });
}/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $SessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerInfo].
extension ServerInfoPatterns on ServerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerInfo value)  $default,){
final _that = this;
switch (_that) {
case _ServerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ServerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  WorkerVersion version,  Session? session)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerInfo() when $default != null:
return $default(_that.name,_that.version,_that.session);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  WorkerVersion version,  Session? session)  $default,) {final _that = this;
switch (_that) {
case _ServerInfo():
return $default(_that.name,_that.version,_that.session);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  WorkerVersion version,  Session? session)?  $default,) {final _that = this;
switch (_that) {
case _ServerInfo() when $default != null:
return $default(_that.name,_that.version,_that.session);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerInfo implements ServerInfo {
  const _ServerInfo({required this.name, required this.version, this.session}): assert(name == "doi", 'Invalid server info: name must be "doi"');
  factory _ServerInfo.fromJson(Map<String, dynamic> json) => _$ServerInfoFromJson(json);

@override final  String name;
@override final  WorkerVersion version;
@override final  Session? session;

/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerInfoCopyWith<_ServerInfo> get copyWith => __$ServerInfoCopyWithImpl<_ServerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.session, session) || other.session == session));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,session);

@override
String toString() {
  return 'ServerInfo(name: $name, version: $version, session: $session)';
}


}

/// @nodoc
abstract mixin class _$ServerInfoCopyWith<$Res> implements $ServerInfoCopyWith<$Res> {
  factory _$ServerInfoCopyWith(_ServerInfo value, $Res Function(_ServerInfo) _then) = __$ServerInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, WorkerVersion version, Session? session
});


@override $WorkerVersionCopyWith<$Res> get version;@override $SessionCopyWith<$Res>? get session;

}
/// @nodoc
class __$ServerInfoCopyWithImpl<$Res>
    implements _$ServerInfoCopyWith<$Res> {
  __$ServerInfoCopyWithImpl(this._self, this._then);

  final _ServerInfo _self;
  final $Res Function(_ServerInfo) _then;

/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? version = null,Object? session = freezed,}) {
  return _then(_ServerInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as WorkerVersion,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session?,
  ));
}

/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerVersionCopyWith<$Res> get version {
  
  return $WorkerVersionCopyWith<$Res>(_self.version, (value) {
    return _then(_self.copyWith(version: value));
  });
}/// Create a copy of ServerInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $SessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// @nodoc
mixin _$WorkerVersion {

 String get id; String get tag; String? get timestamp;
/// Create a copy of WorkerVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerVersionCopyWith<WorkerVersion> get copyWith => _$WorkerVersionCopyWithImpl<WorkerVersion>(this as WorkerVersion, _$identity);

  /// Serializes this WorkerVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tag,timestamp);

@override
String toString() {
  return 'WorkerVersion(id: $id, tag: $tag, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $WorkerVersionCopyWith<$Res>  {
  factory $WorkerVersionCopyWith(WorkerVersion value, $Res Function(WorkerVersion) _then) = _$WorkerVersionCopyWithImpl;
@useResult
$Res call({
 String id, String tag, String? timestamp
});




}
/// @nodoc
class _$WorkerVersionCopyWithImpl<$Res>
    implements $WorkerVersionCopyWith<$Res> {
  _$WorkerVersionCopyWithImpl(this._self, this._then);

  final WorkerVersion _self;
  final $Res Function(WorkerVersion) _then;

/// Create a copy of WorkerVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tag = null,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerVersion].
extension WorkerVersionPatterns on WorkerVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerVersion value)  $default,){
final _that = this;
switch (_that) {
case _WorkerVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerVersion value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tag,  String? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerVersion() when $default != null:
return $default(_that.id,_that.tag,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tag,  String? timestamp)  $default,) {final _that = this;
switch (_that) {
case _WorkerVersion():
return $default(_that.id,_that.tag,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tag,  String? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _WorkerVersion() when $default != null:
return $default(_that.id,_that.tag,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerVersion implements WorkerVersion {
  const _WorkerVersion({required this.id, required this.tag, this.timestamp});
  factory _WorkerVersion.fromJson(Map<String, dynamic> json) => _$WorkerVersionFromJson(json);

@override final  String id;
@override final  String tag;
@override final  String? timestamp;

/// Create a copy of WorkerVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerVersionCopyWith<_WorkerVersion> get copyWith => __$WorkerVersionCopyWithImpl<_WorkerVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tag,timestamp);

@override
String toString() {
  return 'WorkerVersion(id: $id, tag: $tag, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$WorkerVersionCopyWith<$Res> implements $WorkerVersionCopyWith<$Res> {
  factory _$WorkerVersionCopyWith(_WorkerVersion value, $Res Function(_WorkerVersion) _then) = __$WorkerVersionCopyWithImpl;
@override @useResult
$Res call({
 String id, String tag, String? timestamp
});




}
/// @nodoc
class __$WorkerVersionCopyWithImpl<$Res>
    implements _$WorkerVersionCopyWith<$Res> {
  __$WorkerVersionCopyWithImpl(this._self, this._then);

  final _WorkerVersion _self;
  final $Res Function(_WorkerVersion) _then;

/// Create a copy of WorkerVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tag = null,Object? timestamp = freezed,}) {
  return _then(_WorkerVersion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Session {

 String get source; String get name; String get login; String get avatarUrl;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.source, source) || other.source == source)&&(identical(other.name, name) || other.name == name)&&(identical(other.login, login) || other.login == login)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,name,login,avatarUrl);

@override
String toString() {
  return 'Session(source: $source, name: $name, login: $login, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String source, String name, String login, String avatarUrl
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? name = null,Object? login = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String name,  String login,  String avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.source,_that.name,_that.login,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String name,  String login,  String avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.source,_that.name,_that.login,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String name,  String login,  String avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.source,_that.name,_that.login,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({required this.source, required this.name, required this.login, required this.avatarUrl});
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String source;
@override final  String name;
@override final  String login;
@override final  String avatarUrl;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.source, source) || other.source == source)&&(identical(other.name, name) || other.name == name)&&(identical(other.login, login) || other.login == login)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,name,login,avatarUrl);

@override
String toString() {
  return 'Session(source: $source, name: $name, login: $login, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String source, String name, String login, String avatarUrl
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? name = null,Object? login = null,Object? avatarUrl = null,}) {
  return _then(_Session(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
