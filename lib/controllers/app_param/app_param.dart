import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/common/spot_data_model.dart';
import '../../models/municipal_model.dart';
import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/temple_model.dart';
import '../../models/temple_photo_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../models/train_model.dart';
import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
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
    @Default(<SpotDataModel, List<SpotDataModel>>{})
    Map<SpotDataModel, List<SpotDataModel>> keepBusInfoSpotDataModelMap,

    //////////////////////////////////////////////////

    ///
    @Default(0) double currentZoom,
    @Default(5) int currentPaddingIndex,

    ///
    List<OverlayEntry>? firstEntries,
    List<OverlayEntry>? secondEntries,
    Offset? overlayPosition,

    ///
    @Default(<String>[]) List<String> selectedMunicipalNameList,

    @Default('') String searchWord,

    @Default(<String>[]) List<String> neighborAreaNameList,

    SpotDataModel? selectedSpotDataModel,

    @Default(<String>[]) List<String> selectedCityTownTempleMapRankList,

    ///
    @Default('') String selectedTrainName,

    @Default(<SpotDataModel>[]) List<SpotDataModel> addRouteSpotDataModelList,

    @Default(true) bool isJrInclude,

    @Default(false) bool busInfoDisplayFlag,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

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
  void setKeepBusInfoSpotDataModelMap({required Map<SpotDataModel, List<SpotDataModel>> map}) =>
      state = state.copyWith(keepBusInfoSpotDataModelMap: map);

  //===================================================

  ///
  void setKeepTokyoStationList({required List<StationModel> list}) =>
      state = state.copyWith(keepTokyoStationList: list);

  ///
  void setKeepTokyoStationMap({required Map<String, StationModel> map}) =>
      state = state.copyWith(keepTokyoStationMap: map);

  //===================================================

  ///
  void setCurrentZoom({required double zoom}) => state = state.copyWith(currentZoom: zoom);

  //===================================================

  ///
  void setFirstOverlayParams({required List<OverlayEntry>? firstEntries}) =>
      state = state.copyWith(firstEntries: firstEntries);

  ///
  void setSecondOverlayParams({required List<OverlayEntry>? secondEntries}) =>
      state = state.copyWith(secondEntries: secondEntries);

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  //===================================================

  ///
  void clearSelectedMunicipalNameList() => state = state.copyWith(selectedMunicipalNameList: <String>[]);

  ///
  void setSelectedMunicipalNameList({required String municipal}) {
    final List<String> list = <String>[...state.selectedMunicipalNameList];

    if (list.contains(municipal)) {
      list.remove(municipal);
    } else {
      list.add(municipal);
    }

    state = state.copyWith(selectedMunicipalNameList: list);
  }

  ///
  void setSearchWord({required String word}) => state = state.copyWith(searchWord: word);

  ///
  void setDefaultNeighborAreaNameList({required List<String> list}) =>
      state = state.copyWith(neighborAreaNameList: list);

  ///
  void setNeighborAreaNameList({required String name}) {
    final List<String> list = <String>[...state.neighborAreaNameList];

    if (list.contains(name)) {
      list.remove(name);
    } else {
      list.add(name);
    }

    state = state.copyWith(neighborAreaNameList: list);
  }

  ///
  void setSelectedSpotDataModel({required SpotDataModel spotDataModel}) =>
      state = state.copyWith(selectedSpotDataModel: spotDataModel);

  ///
  void clearSelectedSpotDataModel() => state = state.copyWith(selectedSpotDataModel: null);

  ///
  void setSelectedCityTownTempleMapRankList({required String rank}) {
    final List<String> list = <String>[...state.selectedCityTownTempleMapRankList];

    if (list.contains(rank)) {
      list.remove(rank);
    } else {
      list.add(rank);
    }

    state = state.copyWith(selectedCityTownTempleMapRankList: list);
  }

  ///
  void clearSelectedCityTownTempleMapRankList() =>
      state = state.copyWith(selectedCityTownTempleMapRankList: <String>[]);

  ///
  void setSelectedTrainName({required String name}) {
    String trainName = '';

    if (state.selectedTrainName != name) {
      trainName = name;
    }

    state = state.copyWith(selectedTrainName: trainName);
  }

  //===================================================

  ///
  void setAddRouteSpotDataModelList({required SpotDataModel spotDataModel}) {
    final List<SpotDataModel> list = <SpotDataModel>[...state.addRouteSpotDataModelList];

    if (list.contains(spotDataModel)) {
      list.remove(spotDataModel);
    } else {
      list.add(spotDataModel);
    }

    state = state.copyWith(addRouteSpotDataModelList: list);
  }

  ///
  void clearAddRouteSpotDataModelList() => state = state.copyWith(addRouteSpotDataModelList: <SpotDataModel>[]);

  ///
  void reorderAddRouteSpotDataModelList({required int oldIndex, required int newIndex}) {
    if (oldIndex == 0 || newIndex == 0) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final List<SpotDataModel> list = <SpotDataModel>[...state.addRouteSpotDataModelList];

    final SpotDataModel moved = list.removeAt(oldIndex);

    list.insert(newIndex, moved);

    state = state.copyWith(addRouteSpotDataModelList: list);
  }

  ///
  void setIsJrInclude({required bool flag}) => state = state.copyWith(isJrInclude: flag);

  ///
  void setBusInfoDisplayFlag() {
    final bool flag = state.busInfoDisplayFlag;
    state = state.copyWith(busInfoDisplayFlag: !flag);
  }
}
