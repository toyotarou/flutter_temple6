import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/common/spot_data_model.dart';
import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
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

    SpotDataModel? selectedSpotDataModelForBusInfo,

    @Default('') String selectedTempleHistoryYear,

    @Default(<String>[]) List<String> templeHistoryDateList,
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

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

  ///
  void clearBusInfoDisplayFlag() => state = state.copyWith(busInfoDisplayFlag: false);

  ///
  void setSelectedSpotDataModelForBusInfo({required SpotDataModel spotDataModel}) =>
      state = state.copyWith(selectedSpotDataModelForBusInfo: spotDataModel);

  ///
  void setSelectedTempleHistoryYear({required String year}) => state = state.copyWith(selectedTempleHistoryYear: year);

  ///
  void setTempleHistoryDateList({required String date}) {
    final List<String> list = <String>[...state.templeHistoryDateList];

    if (list.contains(date)) {
      list.remove(date);
    } else {
      list.add(date);
    }

    state = state.copyWith(templeHistoryDateList: list);
  }

  ///
  void clearTempleHistoryDateList() => state = state.copyWith(templeHistoryDateList: <String>[]);
}
