// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamState {
  List<TempleModel> get keepTempleList => throw _privateConstructorUsedError;
  Map<String, TempleLatLngModel> get keepTempleLatLngMap =>
      throw _privateConstructorUsedError;
  Map<String, StationModel> get keepStationMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppParamStateCopyWith<AppParamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamStateCopyWith<$Res> {
  factory $AppParamStateCopyWith(
          AppParamState value, $Res Function(AppParamState) then) =
      _$AppParamStateCopyWithImpl<$Res, AppParamState>;
  @useResult
  $Res call(
      {List<TempleModel> keepTempleList,
      Map<String, TempleLatLngModel> keepTempleLatLngMap,
      Map<String, StationModel> keepStationMap});
}

/// @nodoc
class _$AppParamStateCopyWithImpl<$Res, $Val extends AppParamState>
    implements $AppParamStateCopyWith<$Res> {
  _$AppParamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keepTempleList = null,
    Object? keepTempleLatLngMap = null,
    Object? keepStationMap = null,
  }) {
    return _then(_value.copyWith(
      keepTempleList: null == keepTempleList
          ? _value.keepTempleList
          : keepTempleList // ignore: cast_nullable_to_non_nullable
              as List<TempleModel>,
      keepTempleLatLngMap: null == keepTempleLatLngMap
          ? _value.keepTempleLatLngMap
          : keepTempleLatLngMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleLatLngModel>,
      keepStationMap: null == keepStationMap
          ? _value.keepStationMap
          : keepStationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, StationModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamStateImplCopyWith<$Res>
    implements $AppParamStateCopyWith<$Res> {
  factory _$$AppParamStateImplCopyWith(
          _$AppParamStateImpl value, $Res Function(_$AppParamStateImpl) then) =
      __$$AppParamStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TempleModel> keepTempleList,
      Map<String, TempleLatLngModel> keepTempleLatLngMap,
      Map<String, StationModel> keepStationMap});
}

/// @nodoc
class __$$AppParamStateImplCopyWithImpl<$Res>
    extends _$AppParamStateCopyWithImpl<$Res, _$AppParamStateImpl>
    implements _$$AppParamStateImplCopyWith<$Res> {
  __$$AppParamStateImplCopyWithImpl(
      _$AppParamStateImpl _value, $Res Function(_$AppParamStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keepTempleList = null,
    Object? keepTempleLatLngMap = null,
    Object? keepStationMap = null,
  }) {
    return _then(_$AppParamStateImpl(
      keepTempleList: null == keepTempleList
          ? _value._keepTempleList
          : keepTempleList // ignore: cast_nullable_to_non_nullable
              as List<TempleModel>,
      keepTempleLatLngMap: null == keepTempleLatLngMap
          ? _value._keepTempleLatLngMap
          : keepTempleLatLngMap // ignore: cast_nullable_to_non_nullable
              as Map<String, TempleLatLngModel>,
      keepStationMap: null == keepStationMap
          ? _value._keepStationMap
          : keepStationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, StationModel>,
    ));
  }
}

/// @nodoc

class _$AppParamStateImpl implements _AppParamState {
  const _$AppParamStateImpl(
      {final List<TempleModel> keepTempleList = const <TempleModel>[],
      final Map<String, TempleLatLngModel> keepTempleLatLngMap =
          const <String, TempleLatLngModel>{},
      final Map<String, StationModel> keepStationMap =
          const <String, StationModel>{}})
      : _keepTempleList = keepTempleList,
        _keepTempleLatLngMap = keepTempleLatLngMap,
        _keepStationMap = keepStationMap;

  final List<TempleModel> _keepTempleList;
  @override
  @JsonKey()
  List<TempleModel> get keepTempleList {
    if (_keepTempleList is EqualUnmodifiableListView) return _keepTempleList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keepTempleList);
  }

  final Map<String, TempleLatLngModel> _keepTempleLatLngMap;
  @override
  @JsonKey()
  Map<String, TempleLatLngModel> get keepTempleLatLngMap {
    if (_keepTempleLatLngMap is EqualUnmodifiableMapView)
      return _keepTempleLatLngMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keepTempleLatLngMap);
  }

  final Map<String, StationModel> _keepStationMap;
  @override
  @JsonKey()
  Map<String, StationModel> get keepStationMap {
    if (_keepStationMap is EqualUnmodifiableMapView) return _keepStationMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keepStationMap);
  }

  @override
  String toString() {
    return 'AppParamState(keepTempleList: $keepTempleList, keepTempleLatLngMap: $keepTempleLatLngMap, keepStationMap: $keepStationMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamStateImpl &&
            const DeepCollectionEquality()
                .equals(other._keepTempleList, _keepTempleList) &&
            const DeepCollectionEquality()
                .equals(other._keepTempleLatLngMap, _keepTempleLatLngMap) &&
            const DeepCollectionEquality()
                .equals(other._keepStationMap, _keepStationMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keepTempleList),
      const DeepCollectionEquality().hash(_keepTempleLatLngMap),
      const DeepCollectionEquality().hash(_keepStationMap));

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      __$$AppParamStateImplCopyWithImpl<_$AppParamStateImpl>(this, _$identity);
}

abstract class _AppParamState implements AppParamState {
  const factory _AppParamState(
      {final List<TempleModel> keepTempleList,
      final Map<String, TempleLatLngModel> keepTempleLatLngMap,
      final Map<String, StationModel> keepStationMap}) = _$AppParamStateImpl;

  @override
  List<TempleModel> get keepTempleList;
  @override
  Map<String, TempleLatLngModel> get keepTempleLatLngMap;
  @override
  Map<String, StationModel> get keepStationMap;

  /// Create a copy of AppParamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppParamStateImplCopyWith<_$AppParamStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
