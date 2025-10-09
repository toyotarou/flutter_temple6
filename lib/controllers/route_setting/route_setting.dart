import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/common/spot_data_model.dart';
import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/temple_model.dart';

import '../../models/temple_photo_model.dart';
import '../../models/tokyo_municipal_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../models/train_model.dart';
import '../../utility/utility.dart';

part 'route_setting.freezed.dart';

part 'route_setting.g.dart';

@freezed
class RouteSettingState with _$RouteSettingState {
  const factory RouteSettingState({
    @Default('') String startTime,
    @Default('') String walkSpeed,
    @Default('') String stayTime,
    @Default('') String adjustPercent,
  }) = _RouteSettingState;
}

@Riverpod(keepAlive: true)
class RouteSetting extends _$RouteSetting {
  final Utility utility = Utility();

  ///
  @override
  RouteSettingState build() => const RouteSettingState();

  ///
  void setStartTime({required String time}) => state = state.copyWith(startTime: time);

  ///
  void setWalkSpeed({required String speed}) => state = state.copyWith(walkSpeed: speed);

  ///
  void setStayTime({required String time}) => state = state.copyWith(stayTime: time);

  ///
  void setAdjustPercent({required String percent}) => state = state.copyWith(adjustPercent: percent);
}
