import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/bus_total_info_model.dart';
import '../../../utility/utility.dart';

part 'bus_total_info.freezed.dart';

part 'bus_total_info.g.dart';

@freezed
class BusTotalInfoState with _$BusTotalInfoState {
  const factory BusTotalInfoState({
    @Default(<BusTotalInfoModel>[]) List<BusTotalInfoModel> busTotalInfoList,
    @Default(<String, List<BusTotalInfoModel>>{}) Map<String, List<BusTotalInfoModel>> busTotalInfoMap,
    @Default(<String, List<BusTotalInfoModel>>{}) Map<String, List<BusTotalInfoModel>> busTotalInfoViaStationMap,
  }) = _BusTotalInfoState;
}

@Riverpod(keepAlive: true)
class BusTotalInfo extends _$BusTotalInfo {
  final Utility utility = Utility();

  /// @override
  @override
  BusTotalInfoState build() => const BusTotalInfoState();

  //============================================== api

  ///
  Future<BusTotalInfoState> fetchAllBusTotalInfoData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getBusTotalInfo);

      final List<BusTotalInfoModel> list = <BusTotalInfoModel>[];
      final Map<String, List<BusTotalInfoModel>> map = <String, List<BusTotalInfoModel>>{};

      final Map<String, List<BusTotalInfoModel>> map2 = <String, List<BusTotalInfoModel>>{};

      final RegExp regex = RegExp(r'^(.*?)駅');

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value.length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final BusTotalInfoModel val = BusTotalInfoModel.fromJson(value[i] as Map<String, dynamic>);

        list.add(val);

        (map[val.line] ??= <BusTotalInfoModel>[]).add(val);

        final List<String> stationList = <String>[];
        for (final BusStopModel element in val.stops) {
          final RegExpMatch? match = regex.firstMatch(element.name);
          if (match != null) {
            final String stationName = match.group(1)!;
            stationList.add(stationName);
          }
        }
        for (final String element2 in stationList.toSet().toList()) {
          (map2[element2] ??= <BusTotalInfoModel>[]).add(val);
        }
      }

      return state.copyWith(busTotalInfoList: list, busTotalInfoMap: map, busTotalInfoViaStationMap: map2);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllBusTotalInfo() async {
    try {
      final BusTotalInfoState newState = await fetchAllBusTotalInfoData();
      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
