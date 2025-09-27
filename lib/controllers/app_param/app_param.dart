import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';

import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default(<TempleModel>[]) List<TempleModel> keepTempleList,
    @Default(<String, TempleLatLngModel>{}) Map<String, TempleLatLngModel> keepTempleLatLngMap,
    @Default(<String, StationModel>{}) Map<String, StationModel> keepStationMap,
  }) = _AppParamState;
}

@riverpod
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setKeepTempleList({required List<TempleModel> list}) => state = state.copyWith(keepTempleList: list);

  ///
  void setKeepTempleLatLngMap({required Map<String, TempleLatLngModel> map}) =>
      state = state.copyWith(keepTempleLatLngMap: map);

  ///
  void setKeepStationMap({required Map<String, StationModel> map}) => state = state.copyWith(keepStationMap: map);
}
