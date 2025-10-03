// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StationState {
  List<StationModel> get stationList => throw _privateConstructorUsedError;
  Map<String, StationModel> get stationMap =>
      throw _privateConstructorUsedError;
  List<StationModel> get tokyoStationList => throw _privateConstructorUsedError;
  Map<String, StationModel> get tokyoStationMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of StationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StationStateCopyWith<StationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationStateCopyWith<$Res> {
  factory $StationStateCopyWith(
          StationState value, $Res Function(StationState) then) =
      _$StationStateCopyWithImpl<$Res, StationState>;
  @useResult
  $Res call(
      {List<StationModel> stationList,
      Map<String, StationModel> stationMap,
      List<StationModel> tokyoStationList,
      Map<String, StationModel> tokyoStationMap});
}

/// @nodoc
class _$StationStateCopyWithImpl<$Res, $Val extends StationState>
    implements $StationStateCopyWith<$Res> {
  _$StationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stationList = null,
    Object? stationMap = null,
    Object? tokyoStationList = null,
    Object? tokyoStationMap = null,
  }) {
    return _then(_value.copyWith(
      stationList: null == stationList
          ? _value.stationList
          : stationList // ignore: cast_nullable_to_non_nullable
              as List<StationModel>,
      stationMap: null == stationMap
          ? _value.stationMap
          : stationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, StationModel>,
      tokyoStationList: null == tokyoStationList
          ? _value.tokyoStationList
          : tokyoStationList // ignore: cast_nullable_to_non_nullable
              as List<StationModel>,
      tokyoStationMap: null == tokyoStationMap
          ? _value.tokyoStationMap
          : tokyoStationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, StationModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StationStateImplCopyWith<$Res>
    implements $StationStateCopyWith<$Res> {
  factory _$$StationStateImplCopyWith(
          _$StationStateImpl value, $Res Function(_$StationStateImpl) then) =
      __$$StationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<StationModel> stationList,
      Map<String, StationModel> stationMap,
      List<StationModel> tokyoStationList,
      Map<String, StationModel> tokyoStationMap});
}

/// @nodoc
class __$$StationStateImplCopyWithImpl<$Res>
    extends _$StationStateCopyWithImpl<$Res, _$StationStateImpl>
    implements _$$StationStateImplCopyWith<$Res> {
  __$$StationStateImplCopyWithImpl(
      _$StationStateImpl _value, $Res Function(_$StationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stationList = null,
    Object? stationMap = null,
    Object? tokyoStationList = null,
    Object? tokyoStationMap = null,
  }) {
    return _then(_$StationStateImpl(
      stationList: null == stationList
          ? _value._stationList
          : stationList // ignore: cast_nullable_to_non_nullable
              as List<StationModel>,
      stationMap: null == stationMap
          ? _value._stationMap
          : stationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, StationModel>,
      tokyoStationList: null == tokyoStationList
          ? _value._tokyoStationList
          : tokyoStationList // ignore: cast_nullable_to_non_nullable
              as List<StationModel>,
      tokyoStationMap: null == tokyoStationMap
          ? _value._tokyoStationMap
          : tokyoStationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, StationModel>,
    ));
  }
}

/// @nodoc

class _$StationStateImpl implements _StationState {
  const _$StationStateImpl(
      {final List<StationModel> stationList = const <StationModel>[],
      final Map<String, StationModel> stationMap =
          const <String, StationModel>{},
      final List<StationModel> tokyoStationList = const <StationModel>[],
      final Map<String, StationModel> tokyoStationMap =
          const <String, StationModel>{}})
      : _stationList = stationList,
        _stationMap = stationMap,
        _tokyoStationList = tokyoStationList,
        _tokyoStationMap = tokyoStationMap;

  final List<StationModel> _stationList;
  @override
  @JsonKey()
  List<StationModel> get stationList {
    if (_stationList is EqualUnmodifiableListView) return _stationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stationList);
  }

  final Map<String, StationModel> _stationMap;
  @override
  @JsonKey()
  Map<String, StationModel> get stationMap {
    if (_stationMap is EqualUnmodifiableMapView) return _stationMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stationMap);
  }

  final List<StationModel> _tokyoStationList;
  @override
  @JsonKey()
  List<StationModel> get tokyoStationList {
    if (_tokyoStationList is EqualUnmodifiableListView)
      return _tokyoStationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tokyoStationList);
  }

  final Map<String, StationModel> _tokyoStationMap;
  @override
  @JsonKey()
  Map<String, StationModel> get tokyoStationMap {
    if (_tokyoStationMap is EqualUnmodifiableMapView) return _tokyoStationMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tokyoStationMap);
  }

  @override
  String toString() {
    return 'StationState(stationList: $stationList, stationMap: $stationMap, tokyoStationList: $tokyoStationList, tokyoStationMap: $tokyoStationMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._stationList, _stationList) &&
            const DeepCollectionEquality()
                .equals(other._stationMap, _stationMap) &&
            const DeepCollectionEquality()
                .equals(other._tokyoStationList, _tokyoStationList) &&
            const DeepCollectionEquality()
                .equals(other._tokyoStationMap, _tokyoStationMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stationList),
      const DeepCollectionEquality().hash(_stationMap),
      const DeepCollectionEquality().hash(_tokyoStationList),
      const DeepCollectionEquality().hash(_tokyoStationMap));

  /// Create a copy of StationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationStateImplCopyWith<_$StationStateImpl> get copyWith =>
      __$$StationStateImplCopyWithImpl<_$StationStateImpl>(this, _$identity);
}

abstract class _StationState implements StationState {
  const factory _StationState(
      {final List<StationModel> stationList,
      final Map<String, StationModel> stationMap,
      final List<StationModel> tokyoStationList,
      final Map<String, StationModel> tokyoStationMap}) = _$StationStateImpl;

  @override
  List<StationModel> get stationList;
  @override
  Map<String, StationModel> get stationMap;
  @override
  List<StationModel> get tokyoStationList;
  @override
  Map<String, StationModel> get tokyoStationMap;

  /// Create a copy of StationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationStateImplCopyWith<_$StationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
