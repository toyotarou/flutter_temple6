import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/common/spot_data_model.dart';
import '../../utility/tile_provider.dart';

class CityTownTempleMapAlert extends ConsumerStatefulWidget {
  const CityTownTempleMapAlert({
    super.key,
    required this.cityTownName,
    this.visitedMunicipalSpotData,
    this.noReachMunicipalSpotData,
    required this.latList,
    required this.lngList,
  });

  final String cityTownName;
  final List<SpotDataModel>? visitedMunicipalSpotData;
  final List<SpotDataModel>? noReachMunicipalSpotData;
  final List<double> latList;
  final List<double> lngList;

  @override
  ConsumerState<CityTownTempleMapAlert> createState() => _CityTownTempleMapAlertState();
}

class _CityTownTempleMapAlertState extends ConsumerState<CityTownTempleMapAlert>
    with ControllersMixin<CityTownTempleMapAlert> {
  bool isLoading = false;

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: const LatLng(35.718532, 139.586639),
                initialZoom: currentZoomEightTeen,
                onPositionChanged: (MapCamera position, bool isMoving) {
                  if (isMoving) {
                    appParamNotifier.setCurrentZoom(zoom: position.zoom);
                  }
                },
              ),

              children: <Widget>[
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileProvider: CachedTileProvider(),
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
