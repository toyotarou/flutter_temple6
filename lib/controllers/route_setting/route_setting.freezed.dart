// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RouteSettingState {
  String get startTime => throw _privateConstructorUsedError;
  String get walkSpeed => throw _privateConstructorUsedError;
  String get stayTime => throw _privateConstructorUsedError;
  String get adjustPercent => throw _privateConstructorUsedError;

  /// Create a copy of RouteSettingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteSettingStateCopyWith<RouteSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteSettingStateCopyWith<$Res> {
  factory $RouteSettingStateCopyWith(
          RouteSettingState value, $Res Function(RouteSettingState) then) =
      _$RouteSettingStateCopyWithImpl<$Res, RouteSettingState>;
  @useResult
  $Res call(
      {String startTime,
      String walkSpeed,
      String stayTime,
      String adjustPercent});
}

/// @nodoc
class _$RouteSettingStateCopyWithImpl<$Res, $Val extends RouteSettingState>
    implements $RouteSettingStateCopyWith<$Res> {
  _$RouteSettingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteSettingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? walkSpeed = null,
    Object? stayTime = null,
    Object? adjustPercent = null,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      walkSpeed: null == walkSpeed
          ? _value.walkSpeed
          : walkSpeed // ignore: cast_nullable_to_non_nullable
              as String,
      stayTime: null == stayTime
          ? _value.stayTime
          : stayTime // ignore: cast_nullable_to_non_nullable
              as String,
      adjustPercent: null == adjustPercent
          ? _value.adjustPercent
          : adjustPercent // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteSettingStateImplCopyWith<$Res>
    implements $RouteSettingStateCopyWith<$Res> {
  factory _$$RouteSettingStateImplCopyWith(_$RouteSettingStateImpl value,
          $Res Function(_$RouteSettingStateImpl) then) =
      __$$RouteSettingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String startTime,
      String walkSpeed,
      String stayTime,
      String adjustPercent});
}

/// @nodoc
class __$$RouteSettingStateImplCopyWithImpl<$Res>
    extends _$RouteSettingStateCopyWithImpl<$Res, _$RouteSettingStateImpl>
    implements _$$RouteSettingStateImplCopyWith<$Res> {
  __$$RouteSettingStateImplCopyWithImpl(_$RouteSettingStateImpl _value,
      $Res Function(_$RouteSettingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RouteSettingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? walkSpeed = null,
    Object? stayTime = null,
    Object? adjustPercent = null,
  }) {
    return _then(_$RouteSettingStateImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      walkSpeed: null == walkSpeed
          ? _value.walkSpeed
          : walkSpeed // ignore: cast_nullable_to_non_nullable
              as String,
      stayTime: null == stayTime
          ? _value.stayTime
          : stayTime // ignore: cast_nullable_to_non_nullable
              as String,
      adjustPercent: null == adjustPercent
          ? _value.adjustPercent
          : adjustPercent // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RouteSettingStateImpl implements _RouteSettingState {
  const _$RouteSettingStateImpl(
      {this.startTime = '',
      this.walkSpeed = '',
      this.stayTime = '',
      this.adjustPercent = ''});

  @override
  @JsonKey()
  final String startTime;
  @override
  @JsonKey()
  final String walkSpeed;
  @override
  @JsonKey()
  final String stayTime;
  @override
  @JsonKey()
  final String adjustPercent;

  @override
  String toString() {
    return 'RouteSettingState(startTime: $startTime, walkSpeed: $walkSpeed, stayTime: $stayTime, adjustPercent: $adjustPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteSettingStateImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.walkSpeed, walkSpeed) ||
                other.walkSpeed == walkSpeed) &&
            (identical(other.stayTime, stayTime) ||
                other.stayTime == stayTime) &&
            (identical(other.adjustPercent, adjustPercent) ||
                other.adjustPercent == adjustPercent));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, walkSpeed, stayTime, adjustPercent);

  /// Create a copy of RouteSettingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteSettingStateImplCopyWith<_$RouteSettingStateImpl> get copyWith =>
      __$$RouteSettingStateImplCopyWithImpl<_$RouteSettingStateImpl>(
          this, _$identity);
}

abstract class _RouteSettingState implements RouteSettingState {
  const factory _RouteSettingState(
      {final String startTime,
      final String walkSpeed,
      final String stayTime,
      final String adjustPercent}) = _$RouteSettingStateImpl;

  @override
  String get startTime;
  @override
  String get walkSpeed;
  @override
  String get stayTime;
  @override
  String get adjustPercent;

  /// Create a copy of RouteSettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteSettingStateImplCopyWith<_$RouteSettingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
