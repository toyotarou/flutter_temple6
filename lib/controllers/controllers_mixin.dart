import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_get_data/station/station.dart';
import '_get_data/temple/temple.dart';
import '_get_data/temple_lat_lng/temple_lat_lng.dart';
import 'app_param/app_param.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  AppParamState get appParamState => ref.watch(appParamProvider);

  AppParam get appParamNotifier => ref.read(appParamProvider.notifier);

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
}
