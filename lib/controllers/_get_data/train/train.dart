import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/train_model.dart';
import '../../../utility/utility.dart';

part 'train.freezed.dart';

part 'train.g.dart';

@freezed
class TrainState with _$TrainState {
  const factory TrainState({
    @Default(<TrainModel>[]) List<TrainModel> trainList,
    @Default(<String, String>{}) Map<String, String> trainMap,
  }) = _TrainState;
}

@Riverpod(keepAlive: true)
class Train extends _$Train {
  final Utility utility = Utility();

  ///
  @override
  TrainState build() => const TrainState();

  //============================================== api

  ///
  Future<TrainState> fetchAllTrainData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getTrain);

      final List<TrainModel> list = <TrainModel>[];
      final Map<String, String> map = <String, String>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final TrainModel val = TrainModel.fromJson(value['data'][i] as Map<String, dynamic>);

        list.add(val);

        map[val.trainNumber] = val.trainName;
      }

      return state.copyWith(trainList: list, trainMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTrain() async {
    try {
      final TrainState newState = await fetchAllTrainData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
