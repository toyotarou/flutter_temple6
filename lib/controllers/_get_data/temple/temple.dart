import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/temple_model.dart';
import '../../../utility/utility.dart';

part 'temple.freezed.dart';

part 'temple.g.dart';

@freezed
class TempleState with _$TempleState {
  const factory TempleState({
    @Default(<TempleModel>[]) List<TempleModel> templeList,
    @Default(<String, TempleModel>{}) Map<String, TempleModel> templeMap,

    ///
    @Default(<String, TempleModel>{}) Map<String, TempleModel> templeLatLngMap,

    ///
    @Default(<String, List<String>>{}) Map<String, List<String>> templeVisitDateMap,
    @Default(<String, List<String>>{}) Map<String, List<String>> templeDateNameMap,
  }) = _TempleState;
}

@Riverpod(keepAlive: true)
class Temple extends _$Temple {
  final Utility utility = Utility();

  ///
  @override
  TempleState build() => const TempleState();

  //============================================== api

  ///
  Future<TempleState> fetchAllTempleData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getAllTemple);

      final List<TempleModel> list = <TempleModel>[];
      final Map<String, TempleModel> map = <String, TempleModel>{};

      final Map<String, TempleModel> map2 = <String, TempleModel>{};

      final Map<String, List<String>> map3 = <String, List<String>>{};
      final Map<String, List<String>> map4 = <String, List<String>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleModel val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        list.add(val);
        map[val.date.yyyymmdd] = val;

        map2['${val.lat}|${val.lng}'] = val;

        map3[val.temple] = <String>[];

        map4[val.date.yyyy] = <String>[];
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleModel val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        val.memo.split('、').forEach((String element) {
          map3[element] = <String>[];
        });
      }

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['list'].length.toString().toInt(); i++) {
        final TempleModel val = TempleModel.fromJson(
          // ignore: avoid_dynamic_calls
          value['list'][i] as Map<String, dynamic>,
        );

        map3[val.temple]?.add(val.date.yyyymmdd);

        map4[val.date.yyyy]?.add(val.temple);

        val.memo.split('、').forEach((String element) {
          if (element != '') {
            map3[element]?.add(val.date.yyyymmdd);

            map4[val.date.yyyy]?.add(element);
          }
        });
      }

      return state.copyWith(
        templeList: list,
        templeMap: map,
        templeLatLngMap: map2,
        templeVisitDateMap: map3,
        templeDateNameMap: map4,
      );
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTemple() async {
    try {
      final TempleState newState = await fetchAllTempleData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
