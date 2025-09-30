import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/http/client.dart';
import '../../../data/http/path.dart';
import '../../../extensions/extensions.dart';
import '../../../models/temple_photo_model.dart';
import '../../../utility/utility.dart';

part 'temple_photo.freezed.dart';

part 'temple_photo.g.dart';

@freezed
class TemplePhotoState with _$TemplePhotoState {
  const factory TemplePhotoState({
    @Default(<TemplePhotoModel>[]) List<TemplePhotoModel> templePhotoList,
    @Default(<String, List<TemplePhotoModel>>{}) Map<String, List<TemplePhotoModel>> templePhotoMap,
  }) = _TemplePhotoState;
}

@Riverpod(keepAlive: true)
class TemplePhoto extends _$TemplePhoto {
  final Utility utility = Utility();

  ///
  @override
  TemplePhotoState build() => const TemplePhotoState();

  //============================================== api

  ///
  Future<TemplePhotoState> fetchAllTemplePhotoData() async {
    final HttpClient client = ref.read(httpClientProvider);

    try {
      final dynamic value = await client.post(path: APIPath.getTempleDatePhoto);

      final List<TemplePhotoModel> list = <TemplePhotoModel>[];
      final Map<String, List<TemplePhotoModel>> map = <String, List<TemplePhotoModel>>{};

      // ignore: avoid_dynamic_calls
      for (int i = 0; i < value['data'].length.toString().toInt(); i++) {
        // ignore: avoid_dynamic_calls
        final dynamic item = value['data'][i];

        // ignore: avoid_dynamic_calls
        final String temple = item['temple'].toString();
        // ignore: avoid_dynamic_calls
        final String date = item['date'].toString();

        // ignore: avoid_dynamic_calls
        final dynamic rawPhotos = item['templephotos'];

        // ignore: always_specify_types
        final List<String> templephotos = (rawPhotos is List)
            // ignore: always_specify_types
            ? rawPhotos.map((e) => e.toString()).toList()
            : <String>[];

        (map[temple] ??= <TemplePhotoModel>[]).add(
          TemplePhotoModel(date: date, temple: temple, templephotos: templephotos),
        );
      }

      return state.copyWith(templePhotoList: list, templePhotoMap: map);
    } catch (e) {
      utility.showError('予期せぬエラーが発生しました');
      rethrow; // これにより呼び出し元でキャッチできる
    }
  }

  ///
  Future<void> getAllTemplePhoto() async {
    try {
      final TemplePhotoState newState = await fetchAllTemplePhotoData();

      state = newState;
    } catch (_) {}
  }

  //============================================== api
}
