import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/bus_info_model.dart';
import '../../../utility/utility.dart';

part 'bus_info.freezed.dart';

part 'bus_info.g.dart';

@freezed
class BusInfoState with _$BusInfoState {
  const factory BusInfoState({
    @Default(<BusInfoModel>[]) List<BusInfoModel> busInfoList,
    @Default(<String, List<String>>{}) Map<String, List<String>> busInfoStringListMap,
  }) = _BusInfoState;
}

@Riverpod(keepAlive: true)
class BusInfo extends _$BusInfo {
  final Utility utility = Utility();

  ///
  @override
  BusInfoState build() => const BusInfoState();

  //============================================== api

  ///
  Future<BusInfoState> fetchAllBusInfoData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getBusInfo);

      final List<BusInfoModel> list = <BusInfoModel>[];

      final Map<String, List<String>> map = <String, List<String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        final BusInfoModel val = BusInfoModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['data'][i] as Map<String, dynamic>,
        );

        list.add(val);

        (map[val.endA] ??= <String>[]).add(val.endB);
        (map[val.endB] ??= <String>[]).add(val.endA);
      }

      return state.copyWith(busInfoList: list, busInfoStringListMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllBusInfo() async {
    try {
      final BusInfoState newState = await fetchAllBusInfoData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
