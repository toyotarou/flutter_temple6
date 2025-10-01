import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/dup_spot_model.dart';
import '../../../utility/utility.dart';

part 'dup_spot.freezed.dart';

part 'dup_spot.g.dart';

@freezed
class DupSpotState with _$DupSpotState {
  const factory DupSpotState({
    @Default(<DupSpotModel>[]) List<DupSpotModel> dupSpotList,
    @Default(<String, DupSpotModel>{}) Map<String, DupSpotModel> dupSpotMap,
  }) = _DupSpotState;
}

@Riverpod(keepAlive: true)
class DupSpot extends _$DupSpot {
  final Utility utility = Utility();

  ///
  @override
  DupSpotState build() => const DupSpotState();

  //============================================== api

  ///
  Future<DupSpotState> fetchAllDupSpotData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getDupSpot);

      final List<DupSpotModel> list = <DupSpotModel>[];
      final Map<String, DupSpotModel> map = <String, DupSpotModel>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final DupSpotModel val = DupSpotModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);
        map[val.id.toString()] = val;
      }

      return state.copyWith(dupSpotList: list, dupSpotMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllDupSpot() async {
    try {
      final DupSpotState newState = await fetchAllDupSpotData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
