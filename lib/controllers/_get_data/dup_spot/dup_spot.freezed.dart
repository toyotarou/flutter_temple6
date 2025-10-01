// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dup_spot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DupSpotState {
  List<DupSpotModel> get dupSpotList => throw _privateConstructorUsedError;
  Map<String, DupSpotModel> get dupSpotMap =>
      throw _privateConstructorUsedError;

  /// Create a copy of DupSpotState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DupSpotStateCopyWith<DupSpotState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DupSpotStateCopyWith<$Res> {
  factory $DupSpotStateCopyWith(
          DupSpotState value, $Res Function(DupSpotState) then) =
      _$DupSpotStateCopyWithImpl<$Res, DupSpotState>;
  @useResult
  $Res call(
      {List<DupSpotModel> dupSpotList, Map<String, DupSpotModel> dupSpotMap});
}

/// @nodoc
class _$DupSpotStateCopyWithImpl<$Res, $Val extends DupSpotState>
    implements $DupSpotStateCopyWith<$Res> {
  _$DupSpotStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DupSpotState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dupSpotList = null,
    Object? dupSpotMap = null,
  }) {
    return _then(_value.copyWith(
      dupSpotList: null == dupSpotList
          ? _value.dupSpotList
          : dupSpotList // ignore: cast_nullable_to_non_nullable
              as List<DupSpotModel>,
      dupSpotMap: null == dupSpotMap
          ? _value.dupSpotMap
          : dupSpotMap // ignore: cast_nullable_to_non_nullable
              as Map<String, DupSpotModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DupSpotStateImplCopyWith<$Res>
    implements $DupSpotStateCopyWith<$Res> {
  factory _$$DupSpotStateImplCopyWith(
          _$DupSpotStateImpl value, $Res Function(_$DupSpotStateImpl) then) =
      __$$DupSpotStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<DupSpotModel> dupSpotList, Map<String, DupSpotModel> dupSpotMap});
}

/// @nodoc
class __$$DupSpotStateImplCopyWithImpl<$Res>
    extends _$DupSpotStateCopyWithImpl<$Res, _$DupSpotStateImpl>
    implements _$$DupSpotStateImplCopyWith<$Res> {
  __$$DupSpotStateImplCopyWithImpl(
      _$DupSpotStateImpl _value, $Res Function(_$DupSpotStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DupSpotState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dupSpotList = null,
    Object? dupSpotMap = null,
  }) {
    return _then(_$DupSpotStateImpl(
      dupSpotList: null == dupSpotList
          ? _value._dupSpotList
          : dupSpotList // ignore: cast_nullable_to_non_nullable
              as List<DupSpotModel>,
      dupSpotMap: null == dupSpotMap
          ? _value._dupSpotMap
          : dupSpotMap // ignore: cast_nullable_to_non_nullable
              as Map<String, DupSpotModel>,
    ));
  }
}

/// @nodoc

class _$DupSpotStateImpl implements _DupSpotState {
  const _$DupSpotStateImpl(
      {final List<DupSpotModel> dupSpotList = const <DupSpotModel>[],
      final Map<String, DupSpotModel> dupSpotMap =
          const <String, DupSpotModel>{}})
      : _dupSpotList = dupSpotList,
        _dupSpotMap = dupSpotMap;

  final List<DupSpotModel> _dupSpotList;
  @override
  @JsonKey()
  List<DupSpotModel> get dupSpotList {
    if (_dupSpotList is EqualUnmodifiableListView) return _dupSpotList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dupSpotList);
  }

  final Map<String, DupSpotModel> _dupSpotMap;
  @override
  @JsonKey()
  Map<String, DupSpotModel> get dupSpotMap {
    if (_dupSpotMap is EqualUnmodifiableMapView) return _dupSpotMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dupSpotMap);
  }

  @override
  String toString() {
    return 'DupSpotState(dupSpotList: $dupSpotList, dupSpotMap: $dupSpotMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DupSpotStateImpl &&
            const DeepCollectionEquality()
                .equals(other._dupSpotList, _dupSpotList) &&
            const DeepCollectionEquality()
                .equals(other._dupSpotMap, _dupSpotMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dupSpotList),
      const DeepCollectionEquality().hash(_dupSpotMap));

  /// Create a copy of DupSpotState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DupSpotStateImplCopyWith<_$DupSpotStateImpl> get copyWith =>
      __$$DupSpotStateImplCopyWithImpl<_$DupSpotStateImpl>(this, _$identity);
}

abstract class _DupSpotState implements DupSpotState {
  const factory _DupSpotState(
      {final List<DupSpotModel> dupSpotList,
      final Map<String, DupSpotModel> dupSpotMap}) = _$DupSpotStateImpl;

  @override
  List<DupSpotModel> get dupSpotList;
  @override
  Map<String, DupSpotModel> get dupSpotMap;

  /// Create a copy of DupSpotState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DupSpotStateImplCopyWith<_$DupSpotStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
