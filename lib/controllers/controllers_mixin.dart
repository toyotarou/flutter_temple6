import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_get_data/bus_total_info/bus_total_info.dart';
import '_get_data/chiba_municipal/chiba_municipal.dart';
import '_get_data/get_data.dart';
import '_get_data/station/station.dart';
import '_get_data/temple/temple.dart';
import '_get_data/temple_lat_lng/temple_lat_lng.dart';
import '_get_data/temple_list/temple_list.dart';
import '_get_data/temple_photo/temple_photo.dart';
import '_get_data/tokyo_municipal/tokyo_municipal.dart';
import '_get_data/tokyo_train/tokyo_train.dart';
import '_get_data/train/train.dart';
import 'app_param/app_param.dart';
import 'route_setting/route_setting.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

  //==========================================//

  GetDataState get getDataState => ref.watch(getDataProvider);

  GetData get getDataNotifier => ref.read(getDataProvider.notifier);

  //==========================================//

  TempleState get templeState => ref.watch(templeProvider);

  Temple get templeNotifier => ref.read(templeProvider.notifier);

  //==========================================//

  TempleLatLngState get templeLatLngState => ref.watch(templeLatLngProvider);

  TempleLatLng get templeLatLngNotifier => ref.read(templeLatLngProvider.notifier);

  //==========================================//

  StationState get stationState => ref.watch(stationProvider);

  Station get stationNotifier => ref.read(stationProvider.notifier);

  //==========================================//

  TokyoMunicipalState get tokyoMunicipalState => ref.watch(tokyoMunicipalProvider);

  TokyoMunicipal get tokyoMunicipalNotifier => ref.read(tokyoMunicipalProvider.notifier);

  //==========================================//

  TemplePhotoState get templePhotoState => ref.watch(templePhotoProvider);

  TemplePhoto get templePhotoNotifier => ref.read(templePhotoProvider.notifier);

  //==========================================//

  TempleListState get templeListState => ref.watch(templeListProvider);

  TempleList get templeListNotifier => ref.read(templeListProvider.notifier);

  //==========================================//

  TokyoTrainState get tokyoTrainState => ref.watch(tokyoTrainProvider);

  TokyoTrain get tokyoTrainNotifier => ref.read(tokyoTrainProvider.notifier);

  //==========================================//

  TrainState get trainState => ref.watch(trainProvider);

  Train get trainNotifier => ref.read(trainProvider.notifier);

  //==========================================//

  RouteSettingState get routeSettingState => ref.watch(routeSettingProvider);

  RouteSetting get routeSettingNotifier => ref.read(routeSettingProvider.notifier);

  //==========================================//

  ChibaMunicipalState get chibaMunicipalState => ref.watch(chibaMunicipalProvider);

  ChibaMunicipal get chibaMunicipalNotifier => ref.read(chibaMunicipalProvider.notifier);

  //==========================================//
  BusTotalInfoState get busTotalInfoState => ref.watch(busTotalInfoProvider);

  BusTotalInfo get busTotalInfoNotifier => ref.read(busTotalInfoProvider.notifier);

  //==========================================//
}
