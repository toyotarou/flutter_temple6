// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bus_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BusInfoState {
  List<BusInfoModel> get busInfoList => throw _privateConstructorUsedError;
  Map<String, List<String>> get busInfoStringListMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of BusInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusInfoStateCopyWith<BusInfoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusInfoStateCopyWith<$Res> {
  factory $BusInfoStateCopyWith(
          BusInfoState value, $Res Function(BusInfoState) then) =
      _$BusInfoStateCopyWithImpl<$Res, BusInfoState>;
  @useResult
  $Res call(
      {List<BusInfoModel> busInfoList,
      Map<String, List<String>> busInfoStringListMap});
}

/// @nodoc
class _$BusInfoStateCopyWithImpl<$Res, $Val extends BusInfoState>
    implements $BusInfoStateCopyWith<$Res> {
  _$BusInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? busInfoList = null,
    Object? busInfoStringListMap = null,
  }) {
    return _then(_value.copyWith(
      busInfoList: null == busInfoList
          ? _value.busInfoList
          : busInfoList // ignore: cast_nullable_to_non_nullable
              as List<BusInfoModel>,
      busInfoStringListMap: null == busInfoStringListMap
          ? _value.busInfoStringListMap
          : busInfoStringListMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusInfoStateImplCopyWith<$Res>
    implements $BusInfoStateCopyWith<$Res> {
  factory _$$BusInfoStateImplCopyWith(
          _$BusInfoStateImpl value, $Res Function(_$BusInfoStateImpl) then) =
      __$$BusInfoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BusInfoModel> busInfoList,
      Map<String, List<String>> busInfoStringListMap});
}

/// @nodoc
class __$$BusInfoStateImplCopyWithImpl<$Res>
    extends _$BusInfoStateCopyWithImpl<$Res, _$BusInfoStateImpl>
    implements _$$BusInfoStateImplCopyWith<$Res> {
  __$$BusInfoStateImplCopyWithImpl(
      _$BusInfoStateImpl _value, $Res Function(_$BusInfoStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? busInfoList = null,
    Object? busInfoStringListMap = null,
  }) {
    return _then(_$BusInfoStateImpl(
      busInfoList: null == busInfoList
          ? _value._busInfoList
          : busInfoList // ignore: cast_nullable_to_non_nullable
              as List<BusInfoModel>,
      busInfoStringListMap: null == busInfoStringListMap
          ? _value._busInfoStringListMap
          : busInfoStringListMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
    ));
  }
}

/// @nodoc

class _$BusInfoStateImpl implements _BusInfoState {
  const _$BusInfoStateImpl(
      {final List<BusInfoModel> busInfoList = const <BusInfoModel>[],
      final Map<String, List<String>> busInfoStringListMap =
          const <String, List<String>>{}})
      : _busInfoList = busInfoList,
        _busInfoStringListMap = busInfoStringListMap;

  final List<BusInfoModel> _busInfoList;
  @override
  @JsonKey()
  List<BusInfoModel> get busInfoList {
    if (_busInfoList is EqualUnmodifiableListView) return _busInfoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_busInfoList);
  }

  final Map<String, List<String>> _busInfoStringListMap;
  @override
  @JsonKey()
  Map<String, List<String>> get busInfoStringListMap {
    if (_busInfoStringListMap is EqualUnmodifiableMapView)
      return _busInfoStringListMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_busInfoStringListMap);
  }

  @override
  String toString() {
    return 'BusInfoState(busInfoList: $busInfoList, busInfoStringListMap: $busInfoStringListMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusInfoStateImpl &&
            const DeepCollectionEquality()
                .equals(other._busInfoList, _busInfoList) &&
            const DeepCollectionEquality()
                .equals(other._busInfoStringListMap, _busInfoStringListMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_busInfoList),
      const DeepCollectionEquality().hash(_busInfoStringListMap));

  /// Create a copy of BusInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusInfoStateImplCopyWith<_$BusInfoStateImpl> get copyWith =>
      __$$BusInfoStateImplCopyWithImpl<_$BusInfoStateImpl>(this, _$identity);
}

abstract class _BusInfoState implements BusInfoState {
  const factory _BusInfoState(
          {final List<BusInfoModel> busInfoList,
          final Map<String, List<String>> busInfoStringListMap}) =
      _$BusInfoStateImpl;

  @override
  List<BusInfoModel> get busInfoList;
  @override
  Map<String, List<String>> get busInfoStringListMap;

  /// Create a copy of BusInfoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusInfoStateImplCopyWith<_$BusInfoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
