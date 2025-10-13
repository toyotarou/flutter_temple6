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
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';

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

  Utility utility = Utility();

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

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
                TileLayer(urlTemplate: 'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png'),

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
                    child: Row(
                      children: <Widget>[
                        Expanded(
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

                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: () {
                            if (appParamState.selectedTempleHistoryYear == '') {
                              // ignore: always_specify_types
                              Future.delayed(
                                Duration.zero,
                                () => error_dialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  title: 'エラー',
                                  content: 'yearが選択されていません。',
                                ),
                              );

                              return;
                            }

                            if (appParamState.templeHistoryDateList.isNotEmpty) {
                              appParamNotifier.clearTempleHistoryDateList();
                            } else {
                              final List<String> list = <String>[];

                              for (final Map<String, dynamic> element
                                  in widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]!) {
                                if (element.entries.first.key == 'date') {
                                  list.add(element.entries.first.value.toString());
                                }
                              }

                              appParamNotifier.setAllTempleHistoryDateList(list: list);
                            }
                          },
                          child: const CircleAvatar(radius: 15, child: Text('ALL', style: TextStyle(fontSize: 12))),
                        ),
                      ],
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

            Positioned(
              top: 5,
              right: 5,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isLoading = true);

                        latList.clear();
                        lngList.clear();

                        // ignore: always_specify_types
                        Future.delayed(const Duration(seconds: 2), () {
                          setDefaultBoundsMap();

                          setState(() => isLoading = false);
                        });
                      },
                      child: const Column(
                        children: <Widget>[
                          Spacer(),
                          Icon(Icons.center_focus_strong, size: 15),
                          SizedBox(height: 3),
                          Text('ALL', style: TextStyle(fontSize: 10)),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  CircleAvatar(
                    child: GestureDetector(
                      onTap: () {
                        if (appParamState.templeHistoryDateList.isEmpty) {
                          // ignore: always_specify_types
                          Future.delayed(
                            Duration.zero,
                            () => error_dialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              title: 'エラー',
                              content: '日付が選択されていません。',
                            ),
                          );

                          return;
                        }

                        setState(() => isLoading = true);

                        if (widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear] != null) {
                          final String lastDate = appParamState.templeHistoryDateList.last;

                          for (
                            int i = 0;
                            i < widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]!.length;
                            i++
                          ) {
                            final Map<String, dynamic> val =
                                widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]![i];

                            if (val['date'] == lastDate) {
                              final List<double> selectDateLatList = <double>[];
                              final List<double> selectDateLngList = <double>[];

                              for (final SpotDataModel element2 in (val['value'] as List<SpotDataModel>)) {
                                selectDateLatList.add(element2.latitude.toDouble());
                                selectDateLngList.add(element2.longitude.toDouble());
                              }

                              setState(() {
                                latList = selectDateLatList;
                                lngList = selectDateLngList;
                              });
                            }
                          }
                        }

                        // ignore: always_specify_types
                        Future.delayed(const Duration(seconds: 2), () {
                          setDefaultBoundsMap();

                          setState(() => isLoading = false);
                        });
                      },
                      child: const Column(
                        children: <Widget>[
                          Spacer(),
                          Icon(Icons.center_focus_strong, size: 15),
                          SizedBox(height: 3),
                          Text('LAST', style: TextStyle(fontSize: 10)),
                          Spacer(),
                        ],
                      ),
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

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
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
        child: Icon(Icons.home, color: Colors.purpleAccent),
      ),
    );

    homeMarkerList.add(
      const Marker(
        point: LatLng(zenpukujiLat, zenpukujiLng),
        child: Icon(Icons.home, color: Colors.purpleAccent),
      ),
    );
  }

  ///
  // ignore: always_specify_types
  List<Polyline> makeTempleHistoryPolyline() {
    // ignore: always_specify_types
    final List<Polyline> polylineList = [];

    final List<Color> twentyFourColor = utility.getTwentyFourColor();

    if (widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear] != null) {
      for (int i = 0; i < widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]!.length; i++) {
        final Map<String, dynamic> val =
            widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]![i];

        if (appParamState.templeHistoryDateList.contains(val['date'])) {
          final List<LatLng> points = <LatLng>[];
          for (final SpotDataModel element2 in (val['value'] as List<SpotDataModel>)) {
            points.add(LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()));
          }

          // ignore: always_specify_types
          polylineList.add(Polyline(points: points, color: twentyFourColor[i % 24], strokeWidth: 5));
        }
      }
    }

    return polylineList;
  }
}
