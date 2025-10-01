import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/temple_model.dart';

import '../../models/temple_photo_model.dart';
import '../../models/tokyo_municipal_model.dart';
import '../../utility/utility.dart';

part 'app_param.freezed.dart';

part 'app_param.g.dart';

@freezed
class AppParamState with _$AppParamState {
  const factory AppParamState({
    @Default(<TempleModel>[]) List<TempleModel> keepTempleList,
    @Default(<TempleLatLngModel>[]) List<TempleLatLngModel> keepTempleLatLngList,
    @Default(<String, TempleLatLngModel>{}) Map<String, TempleLatLngModel> keepTempleLatLngMap,
    @Default(<String, StationModel>{}) Map<String, StationModel> keepStationMap,
    @Default(<TokyoMunicipalModel>[]) List<TokyoMunicipalModel> keepTokyoMunicipalList,
    @Default(<String, TokyoMunicipalModel>{}) Map<String, TokyoMunicipalModel> keepTokyoMunicipalMap,
    @Default(<String, List<TemplePhotoModel>>{}) Map<String, List<TemplePhotoModel>> keepTemplePhotoMap,
    @Default(<String, TempleListModel>{}) Map<String, TempleListModel> keepTempleListMap,

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
  }) = _AppParamState;
}

@Riverpod(keepAlive: true)
class AppParam extends _$AppParam {
  final Utility utility = Utility();

  ///
  @override
  AppParamState build() => const AppParamState();

  ///
  void setKeepTempleList({required List<TempleModel> list}) => state = state.copyWith(keepTempleList: list);

  ///
  void setKeepTempleLatLngList({required List<TempleLatLngModel> list}) =>
      state = state.copyWith(keepTempleLatLngList: list);

  ///
  void setKeepTempleLatLngMap({required Map<String, TempleLatLngModel> map}) =>
      state = state.copyWith(keepTempleLatLngMap: map);

  ///
  void setKeepStationMap({required Map<String, StationModel> map}) => state = state.copyWith(keepStationMap: map);

  ///
  void setKeepTokyoMunicipalList({required List<TokyoMunicipalModel> list}) =>
      state = state.copyWith(keepTokyoMunicipalList: list);

  ///
  void setKeepTemplePhotoMap({required Map<String, List<TemplePhotoModel>> map}) =>
      state = state.copyWith(keepTemplePhotoMap: map);

  ///
  void setKeepTokyoMunicipalMap({required Map<String, TokyoMunicipalModel> map}) =>
      state = state.copyWith(keepTokyoMunicipalMap: map);

  ///
  void setKeepTempleListMap({required Map<String, TempleListModel> map}) =>
      state = state.copyWith(keepTempleListMap: map);

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
}
