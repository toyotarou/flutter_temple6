import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/tokyo_municipal_model.dart';
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';

class CityTownTempleMapAlert extends ConsumerStatefulWidget {
  const CityTownTempleMapAlert({
    super.key,
    required this.cityTownName,
    this.visitedMunicipalSpotData,
    this.noReachMunicipalSpotData,
    required this.latList,
    required this.lngList,
    this.polygons,
  });

  final String cityTownName;
  final List<SpotDataModel>? visitedMunicipalSpotData;
  final List<SpotDataModel>? noReachMunicipalSpotData;
  final List<double> latList;
  final List<double> lngList;
  final List<List<List<List<double>>>>? polygons;

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

  List<TokyoMunicipalModel> neighborsList = <TokyoMunicipalModel>[];

  ///
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isLoading = true);

      // ignore: always_specify_types
      Future.delayed(const Duration(seconds: 2), () {
        setDefaultBoundsMap();

        setState(() => isLoading = false);
      });
    });
  }

  ///
  void setDefaultBoundsMap() {
    if (widget.latList.isNotEmpty && widget.lngList.isNotEmpty) {
      mapController.rotate(0);

      final LatLngBounds bounds = LatLngBounds.fromPoints(<LatLng>[LatLng(minLat, maxLng), LatLng(maxLat, minLng)]);

      final CameraFit cameraFit = CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(appParamState.currentPaddingIndex * 10),
      );

      mapController.fitCamera(cameraFit);

      /// これは残しておく
      // final LatLng newCenter = mapController.camera.center;

      final double newZoom = mapController.camera.zoom;

      setState(() => currentZoom = newZoom);

      appParamNotifier.setCurrentZoom(zoom: newZoom);
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();

    getNeighborArea();

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

                if (widget.polygons != null) ...<Widget>[
                  // ignore: always_specify_types
                  PolygonLayer(polygons: makeAreaPolygons()),
                ],

                if (neighborsList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolygonLayer(polygons: getNeighborArea()),
                ],
              ],
            ),

            if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
          ],
        ),
      ),
    );
  }

  ///
  void makeMinMaxLatLng() {
    if (widget.latList.isNotEmpty && widget.lngList.isNotEmpty) {
      minLat = widget.latList.reduce(min);
      maxLat = widget.latList.reduce(max);
      minLng = widget.lngList.reduce(min);
      maxLng = widget.lngList.reduce(max);
    }
  }

  ///
  // ignore: always_specify_types
  List<Polygon> makeAreaPolygons() {
    // ignore: always_specify_types
    final List<Polygon<Object>> polygonList = <Polygon>[];

    for (final List<List<List<double>>> element in widget.polygons!) {
      final Polygon<Object>? polygon = getColorPaintPolygon(polygon: element, color: Colors.redAccent);

      if (polygon != null) {
        polygonList.add(polygon);
      }
    }

    return polygonList;
  }

  ///
  // ignore: always_specify_types
  List<Polygon> getNeighborArea() {
    neighborsList.clear();

    // ignore: always_specify_types
    final List<Polygon<Object>> polygonList = <Polygon>[];

    if (appParamState.keepTokyoMunicipalMap[widget.cityTownName] != null) {
      neighborsList = getNeighborsArea(
        target: appParamState.keepTokyoMunicipalMap[widget.cityTownName]!,
        all: appParamState.keepTokyoMunicipalList,
      );

      if (neighborsList.isNotEmpty) {
        for (final TokyoMunicipalModel element in neighborsList) {
          for (final List<List<List<double>>> element2 in element.polygons) {
            final Polygon<Object>? polygon = getColorPaintPolygon(polygon: element2, color: Colors.blueAccent);

            if (polygon != null) {
              polygonList.add(polygon);
            }
          }
        }
      }
    }

    return polygonList;
  }
}
