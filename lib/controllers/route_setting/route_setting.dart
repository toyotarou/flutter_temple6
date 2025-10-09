import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/http/client.dart';
import '../../data/http/path.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../utility/utility.dart';
import '../app_param/app_param.dart';

part 'route_setting.freezed.dart';

part 'route_setting.g.dart';

@freezed
class RouteSettingState with _$RouteSettingState {
  const factory RouteSettingState({
    @Default('') String startTime,
    @Default('') String walkSpeed,
    @Default('') String stayTime,
    @Default('') String adjustPercent,
  }) = _RouteSettingState;
}

@Riverpod(keepAlive: true)
class RouteSetting extends _$RouteSetting {
  final Utility utility = Utility();

  ///
  @override
  RouteSettingState build() => const RouteSettingState();

  ///
  void setStartTime({required String time}) => state = state.copyWith(startTime: time);

  ///
  void setWalkSpeed({required String speed}) => state = state.copyWith(walkSpeed: speed);

  ///
  void setStayTime({required String time}) => state = state.copyWith(stayTime: time);

  ///
  void setAdjustPercent({required String percent}) => state = state.copyWith(adjustPercent: percent);

  ///
  Future<void> insertRoute({required Map<int, Map<String, String>> distanceMap}) async {
    final List<SpotDataModel> addRouteSpotDataModelList = ref.watch(
      appParamProvider.select((AppParamState value) => value.addRouteSpotDataModelList),
    );

    final List<SpotDataModel> list = <SpotDataModel>[...addRouteSpotDataModelList];

    final List<String> data = <String>[];

    for (int i = 0; i < list.length; i++) {
      final Map<String, String>? distanceInfo = (distanceMap[i] != null)
          ? distanceMap[i]
          : <String, String>{'distance': '', 'walkMinutes': ''};

      switch (list[i].type) {
        case 'station':
          data.add('${list[i].name}\n${list[i].address}\n${distanceInfo!['distance']}\n${distanceInfo['walkMinutes']}');
        case 'temple':
          data.add(
            '${list[i].mark}\n${list[i].rank}\n${list[i].name}\n${list[i].address}\n${distanceInfo!['distance']}\n${distanceInfo['walkMinutes']}',
          );
      }
    }

    final HttpClient client = ref.read(httpClientProvider);

    await client
        .post(
          path: APIPath.insertTempleRoute,
          body: <String, dynamic>{'date': DateTime.now().yyyymmdd, 'data': data.join('\n-----\n')},
        )
        // ignore: always_specify_types
        .then((value) {})
        // ignore: always_specify_types
        .catchError((error, _) {
          utility.showError('予期せぬエラーが発生しました');
        });
  }
}
