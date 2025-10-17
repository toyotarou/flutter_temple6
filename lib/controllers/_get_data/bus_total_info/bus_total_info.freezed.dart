// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bus_total_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BusTotalInfoState {
  List<BusTotalInfoModel> get busTotalInfoList =>
      throw _privateConstructorUsedError;
  Map<String, List<BusTotalInfoModel>> get busTotalInfoMap =>
      throw _privateConstructorUsedError;
  Map<String, List<BusTotalInfoModel>> get busTotalInfoViaStationMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of BusTotalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusTotalInfoStateCopyWith<BusTotalInfoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusTotalInfoStateCopyWith<$Res> {
  factory $BusTotalInfoStateCopyWith(
          BusTotalInfoState value, $Res Function(BusTotalInfoState) then) =
      _$BusTotalInfoStateCopyWithImpl<$Res, BusTotalInfoState>;
  @useResult
  $Res call(
      {List<BusTotalInfoModel> busTotalInfoList,
      Map<String, List<BusTotalInfoModel>> busTotalInfoMap,
      Map<String, List<BusTotalInfoModel>> busTotalInfoViaStationMap});
}

/// @nodoc
class _$BusTotalInfoStateCopyWithImpl<$Res, $Val extends BusTotalInfoState>
    implements $BusTotalInfoStateCopyWith<$Res> {
  _$BusTotalInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusTotalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? busTotalInfoList = null,
    Object? busTotalInfoMap = null,
    Object? busTotalInfoViaStationMap = null,
  }) {
    return _then(_value.copyWith(
      busTotalInfoList: null == busTotalInfoList
          ? _value.busTotalInfoList
          : busTotalInfoList // ignore: cast_nullable_to_non_nullable
              as List<BusTotalInfoModel>,
      busTotalInfoMap: null == busTotalInfoMap
          ? _value.busTotalInfoMap
          : busTotalInfoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<BusTotalInfoModel>>,
      busTotalInfoViaStationMap: null == busTotalInfoViaStationMap
          ? _value.busTotalInfoViaStationMap
          : busTotalInfoViaStationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<BusTotalInfoModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusTotalInfoStateImplCopyWith<$Res>
    implements $BusTotalInfoStateCopyWith<$Res> {
  factory _$$BusTotalInfoStateImplCopyWith(_$BusTotalInfoStateImpl value,
          $Res Function(_$BusTotalInfoStateImpl) then) =
      __$$BusTotalInfoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BusTotalInfoModel> busTotalInfoList,
      Map<String, List<BusTotalInfoModel>> busTotalInfoMap,
      Map<String, List<BusTotalInfoModel>> busTotalInfoViaStationMap});
}

/// @nodoc
class __$$BusTotalInfoStateImplCopyWithImpl<$Res>
    extends _$BusTotalInfoStateCopyWithImpl<$Res, _$BusTotalInfoStateImpl>
    implements _$$BusTotalInfoStateImplCopyWith<$Res> {
  __$$BusTotalInfoStateImplCopyWithImpl(_$BusTotalInfoStateImpl _value,
      $Res Function(_$BusTotalInfoStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusTotalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? busTotalInfoList = null,
    Object? busTotalInfoMap = null,
    Object? busTotalInfoViaStationMap = null,
  }) {
    return _then(_$BusTotalInfoStateImpl(
      busTotalInfoList: null == busTotalInfoList
          ? _value._busTotalInfoList
          : busTotalInfoList // ignore: cast_nullable_to_non_nullable
              as List<BusTotalInfoModel>,
      busTotalInfoMap: null == busTotalInfoMap
          ? _value._busTotalInfoMap
          : busTotalInfoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<BusTotalInfoModel>>,
      busTotalInfoViaStationMap: null == busTotalInfoViaStationMap
          ? _value._busTotalInfoViaStationMap
          : busTotalInfoViaStationMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<BusTotalInfoModel>>,
    ));
  }
}

/// @nodoc

class _$BusTotalInfoStateImpl implements _BusTotalInfoState {
  const _$BusTotalInfoStateImpl(
      {final List<BusTotalInfoModel> busTotalInfoList =
          const <BusTotalInfoModel>[],
      final Map<String, List<BusTotalInfoModel>> busTotalInfoMap =
          const <String, List<BusTotalInfoModel>>{},
      final Map<String, List<BusTotalInfoModel>> busTotalInfoViaStationMap =
          const <String, List<BusTotalInfoModel>>{}})
      : _busTotalInfoList = busTotalInfoList,
        _busTotalInfoMap = busTotalInfoMap,
        _busTotalInfoViaStationMap = busTotalInfoViaStationMap;

  final List<BusTotalInfoModel> _busTotalInfoList;
  @override
  @JsonKey()
  List<BusTotalInfoModel> get busTotalInfoList {
    if (_busTotalInfoList is EqualUnmodifiableListView)
      return _busTotalInfoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_busTotalInfoList);
  }

  final Map<String, List<BusTotalInfoModel>> _busTotalInfoMap;
  @override
  @JsonKey()
  Map<String, List<BusTotalInfoModel>> get busTotalInfoMap {
    if (_busTotalInfoMap is EqualUnmodifiableMapView) return _busTotalInfoMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_busTotalInfoMap);
  }

  final Map<String, List<BusTotalInfoModel>> _busTotalInfoViaStationMap;
  @override
  @JsonKey()
  Map<String, List<BusTotalInfoModel>> get busTotalInfoViaStationMap {
    if (_busTotalInfoViaStationMap is EqualUnmodifiableMapView)
      return _busTotalInfoViaStationMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_busTotalInfoViaStationMap);
  }

  @override
  String toString() {
    return 'BusTotalInfoState(busTotalInfoList: $busTotalInfoList, busTotalInfoMap: $busTotalInfoMap, busTotalInfoViaStationMap: $busTotalInfoViaStationMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusTotalInfoStateImpl &&
            const DeepCollectionEquality()
                .equals(other._busTotalInfoList, _busTotalInfoList) &&
            const DeepCollectionEquality()
                .equals(other._busTotalInfoMap, _busTotalInfoMap) &&
            const DeepCollectionEquality().equals(
                other._busTotalInfoViaStationMap, _busTotalInfoViaStationMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_busTotalInfoList),
      const DeepCollectionEquality().hash(_busTotalInfoMap),
      const DeepCollectionEquality().hash(_busTotalInfoViaStationMap));

  /// Create a copy of BusTotalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusTotalInfoStateImplCopyWith<_$BusTotalInfoStateImpl> get copyWith =>
      __$$BusTotalInfoStateImplCopyWithImpl<_$BusTotalInfoStateImpl>(
          this, _$identity);
}

abstract class _BusTotalInfoState implements BusTotalInfoState {
  const factory _BusTotalInfoState(
      {final List<BusTotalInfoModel> busTotalInfoList,
      final Map<String, List<BusTotalInfoModel>> busTotalInfoMap,
      final Map<String, List<BusTotalInfoModel>>
          busTotalInfoViaStationMap}) = _$BusTotalInfoStateImpl;

  @override
  List<BusTotalInfoModel> get busTotalInfoList;
  @override
  Map<String, List<BusTotalInfoModel>> get busTotalInfoMap;
  @override
  Map<String, List<BusTotalInfoModel>> get busTotalInfoViaStationMap;

  /// Create a copy of BusTotalInfoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusTotalInfoStateImplCopyWith<_$BusTotalInfoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
