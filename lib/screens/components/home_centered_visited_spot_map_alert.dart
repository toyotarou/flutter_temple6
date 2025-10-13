import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/expandable_box.dart';

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

  List<Marker> templeMarkerList = <Marker>[];

  Map<String, Color> dateColorMap = <String, Color>{};

  final AutoScrollController autoScrollController = AutoScrollController();

  List<Widget> templeHistoryList = <Widget>[];

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

                if (templeMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: templeMarkerList)],
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

                                      setState(() {
                                        templeMarkerList.clear();
                                      });
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

                              setState(() {
                                templeMarkerList.clear();
                              });
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

            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ExpandableBox(
                      alignment: Alignment.topCenter,
                      keepFullWidth: true,

                      collapsedSize: Size(0, context.screenSize.height * 0.05),
                      expandedSize: Size(0, context.screenSize.height * 0.3),

                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                      ),
                      collapsedChild: const Icon(Icons.square_outlined, color: Colors.transparent),
                      expandedChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),

                          Expanded(child: buildTempleHistoryList()),
                        ],
                      ),
                    ),
                  ],
                ),

                Positioned(
                  top: 5,
                  left: 20,
                  child: Text(appParamState.selectedTempleHistoryYear, style: const TextStyle(fontSize: 20)),
                ),

                Positioned(
                  top: 5,
                  right: 60,
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
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0x66000000),
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Icon(Icons.center_focus_strong, size: 15, color: Colors.white),
                          SizedBox(height: 3),
                          Text('ALL', style: TextStyle(fontSize: 10, color: Colors.white)),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (isLoading) ...<Widget>[const Center(child: CircularProgressIndicator())],
          ],
        ),
      ),
    );
  }

  ///
  Future<void> _scrollToBottom() async {
    await autoScrollController.scrollToIndex(templeHistoryList.length - 1, preferPosition: AutoScrollPosition.end);

    await autoScrollController.animateTo(
      autoScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
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

                _scrollToBottom();
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
    templeMarkerList.clear();

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
            final LatLng latlng = LatLng(element2.latitude.toDouble(), element2.longitude.toDouble());

            points.add(latlng);

            if (element2.type == 'temple') {
              templeMarkerList.add(
                Marker(
                  point: latlng,
                  child: const Icon(FontAwesomeIcons.toriiGate, color: Colors.pinkAccent),
                ),
              );
            }
          }

          final Color color = twentyFourColor[i % 24];

          dateColorMap[val['date'].toString()] = color;

          // ignore: always_specify_types
          polylineList.add(Polyline(points: points, color: color, strokeWidth: 5));
        }
      }
    }

    return polylineList;
  }

  ///
  Widget buildTempleHistoryList() {
    final List<Widget> list = <Widget>[];

    if (widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear] != null) {
      for (int i = 0; i < widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]!.length; i++) {
        final Map<String, dynamic> val =
            widget.homeCenteredTempleHistoryMap[appParamState.selectedTempleHistoryYear]![i];

        if (appParamState.templeHistoryDateList.contains(val['date'])) {
          final List<String> historyDateTempleList = <String>[];

          final List<String> startAndEndSpotList = <String>[];

          final List<double> selectDateLatList = <double>[];
          final List<double> selectDateLngList = <double>[];

          for (final SpotDataModel element2 in (val['value'] as List<SpotDataModel>)) {
            if (element2.type == 'temple') {
              historyDateTempleList.add(element2.name);
            } else {
              startAndEndSpotList.add(element2.name);
            }

            selectDateLatList.add(element2.latitude.toDouble());
            selectDateLngList.add(element2.longitude.toDouble());
          }

          list.add(
            AutoScrollTag(
              // ignore: always_specify_types
              key: ValueKey(i),
              index: i,
              controller: autoScrollController,

              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),

                child: Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  padding: const EdgeInsets.all(5),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 40,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(val['date'].toString().split('-')[0]),
                                      Text(
                                        '${val['date'].toString().split('-')[1]}-${val['date'].toString().split('-')[2]}',
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: (dateColorMap[val['date'].toString()] != null)
                                              ? dateColorMap[val['date'].toString()]!
                                              : Colors.transparent,

                                          width: 5,
                                        ),
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: historyDateTempleList.map((String e) => Text(e)).toList(),
                                        ),

                                        const Divider(color: Colors.white),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(startAndEndSpotList[0]),
                                            Text(startAndEndSpotList[1]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() => isLoading = true);

                          setState(() {
                            latList = selectDateLatList;
                            lngList = selectDateLngList;
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(seconds: 2), () {
                            setDefaultBoundsMap();

                            setState(() => isLoading = false);
                          });
                        },
                        icon: const Icon(Icons.filter_center_focus),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    setState(() => templeHistoryList = list);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomScrollView(
        controller: autoScrollController,

        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => list[index],
              childCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
}
