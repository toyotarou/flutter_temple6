import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../utility/tile_provider.dart';

class HomeCenteredVisitedSpotMapAlert extends ConsumerStatefulWidget {
  const HomeCenteredVisitedSpotMapAlert({
    super.key,
    required this.latList,
    required this.lngList,
    required this.homeCenteredTempleHistoryMap,
  });

  final List<double> latList;
  final List<double> lngList;
  final Map<String, List<Map<String, dynamic>>> homeCenteredTempleHistoryMap;

  @override
  ConsumerState<HomeCenteredVisitedSpotMapAlert> createState() => _HomeCenteredVisitedSpotMapAlertState();
}

class _HomeCenteredVisitedSpotMapAlertState extends ConsumerState<HomeCenteredVisitedSpotMapAlert>
    with ControllersMixin<HomeCenteredVisitedSpotMapAlert> {
  bool isLoading = false;

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  List<Marker> homeMarkerList = <Marker>[];

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

    makeHomeMarkerList();

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

                // if (appParamState.selectedTrainName != '' &&
                //     appParamState.keepTokyoTrainMap[appParamState.selectedTrainName] != null &&
                //     appParamState.keepTokyoTrainMap[appParamState.selectedTrainName]!.station.isNotEmpty) ...<Widget>[
                //   // ignore: always_specify_types
                //   PolylineLayer(polylines: makeTrainPolyline()),
                // ],
                if (appParamState.selectedTempleHistoryYear != '' &&
                    appParamState.templeHistoryDateList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(polylines: makeTempleHistoryPolyline()),
                ],

                if (homeMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: homeMarkerList)],
              ],
            ),

            Positioned(
              bottom: 5,
              right: 5,
              left: 5,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 3),

                        bottom: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 3),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.homeCenteredTempleHistoryMap.entries.map((
                          MapEntry<String, List<Map<String, dynamic>>> e,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {
                                appParamNotifier.clearTempleHistoryDateList();

                                appParamNotifier.setSelectedTempleHistoryYear(year: e.key);
                              },

                              child: CircleAvatar(
                                radius: 15,

                                backgroundColor: (appParamState.selectedTempleHistoryYear == e.key)
                                    ? Colors.yellowAccent.withValues(alpha: 0.4)
                                    : Colors.blueGrey.withValues(alpha: 0.4),

                                child: Text(
                                  e.key,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: (appParamState.selectedTempleHistoryYear == e.key)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: context.screenSize.width * 2,
                      height: 220,

                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1), border: Border.all()),
                      child: displaySelectedTempleHistoryYearItem(),
                    ),
                  ),
                ],
              ),
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
  Widget displaySelectedTempleHistoryYearItem() {
    if (appParamState.selectedTempleHistoryYear == '') {
      return const SizedBox.shrink();
    }

    final List<Widget> list = <Widget>[];

    if (widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear] != null) {
      for (final Map<String, dynamic> element
          in widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]!) {
        if (element.entries.first.key == 'date') {
          list.add(
            GestureDetector(
              onTap: () {
                appParamNotifier.setTempleHistoryDateList(date: element.entries.first.value.toString());
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: (appParamState.templeHistoryDateList.contains(element.entries.first.value.toString()))
                      ? Colors.yellowAccent.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.2),

                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  element.entries.first.value.toString(),
                  style: TextStyle(
                    fontSize: 10,

                    color: (appParamState.templeHistoryDateList.contains(element.entries.first.value.toString()))
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return Wrap(children: list.map((Widget e) => e).toList());
  }

  ///
  void makeHomeMarkerList() {
    homeMarkerList.add(
      const Marker(
        point: LatLng(funabashiLat, funabashiLng),
        child: Icon(Icons.home, color: Colors.redAccent),
      ),
    );

    homeMarkerList.add(
      const Marker(
        point: LatLng(zenpukujiLat, zenpukujiLng),
        child: Icon(Icons.home, color: Colors.redAccent),
      ),
    );
  }

  ///
  // ignore: always_specify_types
  List<Polyline> makeTempleHistoryPolyline() {
    // ignore: always_specify_types
    final List<Polyline> polylineList = [];

    if (widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear] != null) {
      for (final Map<String, dynamic> element
          in widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]!) {
        if (appParamState.templeHistoryDateList.contains(element['date'])) {
          final List<LatLng> points = <LatLng>[];
          for (final SpotDataModel element2 in (element['value'] as List<SpotDataModel>)) {
            points.add(LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()));
          }

          // ignore: always_specify_types
          polylineList.add(Polyline(points: points, color: Colors.redAccent, strokeWidth: 5));
        }
      }
    }

    return polylineList;
  }
}
