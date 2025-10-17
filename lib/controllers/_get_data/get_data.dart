import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/bus_total_info_model.dart';

// import '../../models/common/spot_data_model.dart';
//
//
//

import '../../models/municipal_model.dart';
import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/temple_model.dart';
import '../../models/temple_photo_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../models/train_model.dart';
import '../../utility/utility.dart';

part 'get_data.freezed.dart';

part 'get_data.g.dart';

@freezed
class GetDataState with _$GetDataState {
  const factory GetDataState({
    //---
    @Default(<TempleModel>[]) List<TempleModel> keepTempleList,

    //---
    @Default(<TempleLatLngModel>[]) List<TempleLatLngModel> keepTempleLatLngList,
    @Default(<String, TempleLatLngModel>{}) Map<String, TempleLatLngModel> keepTempleLatLngMap,

    //---
    @Default(<String, StationModel>{}) Map<String, StationModel> keepStationMap,

    //---
    @Default(<MunicipalModel>[]) List<MunicipalModel> keepTokyoMunicipalList,
    @Default(<String, MunicipalModel>{}) Map<String, MunicipalModel> keepTokyoMunicipalMap,

    //---
    @Default(<String, List<TemplePhotoModel>>{}) Map<String, List<TemplePhotoModel>> keepTemplePhotoMap,

    //---
    @Default(<String, TempleListModel>{}) Map<String, TempleListModel> keepTempleListMap,
    @Default(<TempleListModel>[]) List<TempleListModel> keepTempleListList,

    //---
    @Default(<TokyoTrainModel>[]) List<TokyoTrainModel> keepTokyoTrainList,
    @Default(<String, TokyoTrainModel>{}) Map<String, TokyoTrainModel> keepTokyoTrainMap,
    @Default(<String, List<TokyoTrainModel>>{})
    Map<String, List<TokyoTrainModel>> keepTokyoStationTokyoTrainModelListMap,

    ///
    @Default(<StationModel>[]) List<StationModel> keepTokyoStationList,
    @Default(<String, StationModel>{}) Map<String, StationModel> keepTokyoStationMap,

    ///
    @Default(<TrainModel>[]) List<TrainModel> keepTrainList,

    //---
    @Default(<String, MunicipalModel>{}) Map<String, MunicipalModel> keepChibaMunicipalMap,

    //---
    @Default(<String, List<String>>{}) Map<String, List<String>> keepBusInfoStringListMap,

    //---
    @Default(<String, List<BusTotalInfoModel>>{}) Map<String, List<BusTotalInfoModel>> keepBusTotalInfoViaStationMap,
  }) = _GetDataState;
}

@Riverpod(keepAlive: true)
class GetData extends _$GetData {
  final Utility utility = Utility();

  ///
  @override
  GetDataState build() => const GetDataState();

  //---

  ///
  void setKeepTempleList({required List<TempleModel> list}) => state = state.copyWith(keepTempleList: list);

  //---

  ///
  void setKeepTempleLatLngList({required List<TempleLatLngModel> list}) =>
      state = state.copyWith(keepTempleLatLngList: list);

  ///
  void setKeepTempleLatLngMap({required Map<String, TempleLatLngModel> map}) =>
      state = state.copyWith(keepTempleLatLngMap: map);

  //---

  ///
  void setKeepStationMap({required Map<String, StationModel> map}) => state = state.copyWith(keepStationMap: map);

  //---

  ///
  void setKeepTokyoMunicipalList({required List<MunicipalModel> list}) =>
      state = state.copyWith(keepTokyoMunicipalList: list);

  ///
  void setKeepTokyoMunicipalMap({required Map<String, MunicipalModel> map}) =>
      state = state.copyWith(keepTokyoMunicipalMap: map);

  //---

  ///
  void setKeepTemplePhotoMap({required Map<String, List<TemplePhotoModel>> map}) =>
      state = state.copyWith(keepTemplePhotoMap: map);

  //---

  ///
  void setKeepTempleListMap({required Map<String, TempleListModel> map}) =>
      state = state.copyWith(keepTempleListMap: map);

  ///
  void setKeepTempleListList({required List<TempleListModel> list}) => state = state.copyWith(keepTempleListList: list);

  //---

  ///
  void setKeepTokyoTrainList({required List<TokyoTrainModel> list}) => state = state.copyWith(keepTokyoTrainList: list);

  ///
  void setKeepTokyoTrainMap({required Map<String, TokyoTrainModel> map}) =>
      state = state.copyWith(keepTokyoTrainMap: map);

  ///
  void setKeepTokyoStationTokyoTrainModelListMap({required Map<String, List<TokyoTrainModel>> map}) =>
      state = state.copyWith(keepTokyoStationTokyoTrainModelListMap: map);

  ///
  void setKeepTrainList({required List<TrainModel> list}) => state = state.copyWith(keepTrainList: list);

  //---

  ///
  void setKeepChibaMunicipalMap({required Map<String, MunicipalModel> map}) =>
      state = state.copyWith(keepChibaMunicipalMap: map);

  ///
  void setKeepBusInfoStringListMap({required Map<String, List<String>> map}) =>
      state = state.copyWith(keepBusInfoStringListMap: map);

  // ///
  // void setKeepBusInfoSpotDataModelMap({required Map<SpotDataModel, List<SpotDataModel>> map}) =>
  //     state = state.copyWith(keepBusInfoSpotDataModelMap: map);
  //
  //
  //
  //
  //

  ///
  void setKeepTokyoStationList({required List<StationModel> list}) =>
      state = state.copyWith(keepTokyoStationList: list);

  ///
  void setKeepTokyoStationMap({required Map<String, StationModel> map}) =>
      state = state.copyWith(keepTokyoStationMap: map);

  ///
  void setKeepBusTotalInfoViaStationMap({required Map<String, List<BusTotalInfoModel>> map}) =>
      state = state.copyWith(keepBusTotalInfoViaStationMap: map);
}
