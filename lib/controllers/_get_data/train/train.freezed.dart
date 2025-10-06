// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'train.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TrainState {
  List<TrainModel> get trainList => throw _privateConstructorUsedError;
  Map<String, String> get trainMap => throw _privateConstructorUsedError;

  /// Create a copy of TrainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainStateCopyWith<TrainState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainStateCopyWith<$Res> {
  factory $TrainStateCopyWith(
          TrainState value, $Res Function(TrainState) then) =
      _$TrainStateCopyWithImpl<$Res, TrainState>;
  @useResult
  $Res call({List<TrainModel> trainList, Map<String, String> trainMap});
}

/// @nodoc
class _$TrainStateCopyWithImpl<$Res, $Val extends TrainState>
    implements $TrainStateCopyWith<$Res> {
  _$TrainStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainList = null,
    Object? trainMap = null,
  }) {
    return _then(_value.copyWith(
      trainList: null == trainList
          ? _value.trainList
          : trainList // ignore: cast_nullable_to_non_nullable
              as List<TrainModel>,
      trainMap: null == trainMap
          ? _value.trainMap
          : trainMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainStateImplCopyWith<$Res>
    implements $TrainStateCopyWith<$Res> {
  factory _$$TrainStateImplCopyWith(
          _$TrainStateImpl value, $Res Function(_$TrainStateImpl) then) =
      __$$TrainStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TrainModel> trainList, Map<String, String> trainMap});
}

/// @nodoc
class __$$TrainStateImplCopyWithImpl<$Res>
    extends _$TrainStateCopyWithImpl<$Res, _$TrainStateImpl>
    implements _$$TrainStateImplCopyWith<$Res> {
  __$$TrainStateImplCopyWithImpl(
      _$TrainStateImpl _value, $Res Function(_$TrainStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainList = null,
    Object? trainMap = null,
  }) {
    return _then(_$TrainStateImpl(
      trainList: null == trainList
          ? _value._trainList
          : trainList // ignore: cast_nullable_to_non_nullable
              as List<TrainModel>,
      trainMap: null == trainMap
          ? _value._trainMap
          : trainMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$TrainStateImpl implements _TrainState {
  const _$TrainStateImpl(
      {final List<TrainModel> trainList = const <TrainModel>[],
      final Map<String, String> trainMap = const <String, String>{}})
      : _trainList = trainList,
        _trainMap = trainMap;

  final List<TrainModel> _trainList;
  @override
  @JsonKey()
  List<TrainModel> get trainList {
    if (_trainList is EqualUnmodifiableListView) return _trainList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trainList);
  }

  final Map<String, String> _trainMap;
  @override
  @JsonKey()
  Map<String, String> get trainMap {
    if (_trainMap is EqualUnmodifiableMapView) return _trainMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trainMap);
  }

  @override
  String toString() {
    return 'TrainState(trainList: $trainList, trainMap: $trainMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainStateImpl &&
            const DeepCollectionEquality()
                .equals(other._trainList, _trainList) &&
            const DeepCollectionEquality().equals(other._trainMap, _trainMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_trainList),
      const DeepCollectionEquality().hash(_trainMap));

  /// Create a copy of TrainState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainStateImplCopyWith<_$TrainStateImpl> get copyWith =>
      __$$TrainStateImplCopyWithImpl<_$TrainStateImpl>(this, _$identity);
}

abstract class _TrainState implements TrainState {
  const factory _TrainState(
      {final List<TrainModel> trainList,
      final Map<String, String> trainMap}) = _$TrainStateImpl;

  @override
  List<TrainModel> get trainList;
  @override
  Map<String, String> get trainMap;

  /// Create a copy of TrainState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainStateImplCopyWith<_$TrainStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
