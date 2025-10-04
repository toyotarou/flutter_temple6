import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/station_model.dart';
import '../../models/tokyo_municipal_model.dart';
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';
import '../parts/expandable_box.dart';
import '../parts/temple_overlay.dart';

class CityTownTempleMapAlert extends ConsumerStatefulWidget {
  const CityTownTempleMapAlert({
    super.key,
    required this.cityTownName,
    required this.latList,
    required this.lngList,
    this.polygons,
    required this.visitedMunicipalSpotDataListMap,
    required this.noReachMunicipalSpotDataListMap,
  });

  final String cityTownName;
  final List<double> latList;
  final List<double> lngList;
  final List<List<List<List<double>>>>? polygons;
  final Map<String, List<SpotDataModel>> visitedMunicipalSpotDataListMap;
  final Map<String, List<SpotDataModel>> noReachMunicipalSpotDataListMap;

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

  List<String> neighborAreaNameList = <String>[];

  List<Marker> visitedTemplesMarkerList = <Marker>[];

  List<Marker> noReachTemplesMarkerList = <Marker>[];

  List<Marker> tokyoStationMarkerList = <Marker>[];

  bool displayStation = false;

  List<Marker> neighborTempleMarkerList = <Marker>[];

  bool displayNeighborTemple = false;

  // ignore: unused_field
  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

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

    makeVisitedMunicipalSpotDataMarker();

    makeNoReachMunicipalSpotDataMarker();

    makeTokyoStationMarkerList();

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

                if (visitedTemplesMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: visitedTemplesMarkerList)],

                if (noReachTemplesMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: noReachTemplesMarkerList)],

                if (tokyoStationMarkerList.isNotEmpty && displayStation) ...<Widget>[
                  MarkerLayer(markers: tokyoStationMarkerList),
                ],

                if (neighborTempleMarkerList.isNotEmpty && displayNeighborTemple) ...<Widget>[
                  MarkerLayer(markers: neighborTempleMarkerList),
                ],
              ],
            ),

            Column(
              children: <Widget>[
                Stack(
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
                          const SizedBox(height: 15),

                          Expanded(child: buildExpandedChildContents()),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(widget.cityTownName, style: const TextStyle(fontSize: 20)),
                    ),

                    Positioned(
                      top: 5,
                      right: 60,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              makeNeighborTempleMarker();

                              setState(() => displayNeighborTemple = !displayNeighborTemple);
                            },
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0x66000000),

                              child: Icon(FontAwesomeIcons.toriiGate, size: 18, color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 15),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                displayStation = !displayStation;
                              });
                            },
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0x66000000),

                              child: Icon(Icons.train, size: 18, color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 15),

                          GestureDetector(
                            onTap: () => setDefaultBoundsMap(),
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0x66000000),

                              child: Icon(Icons.filter_center_focus, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  bool isSetNeighborAreaNameList = false;

  ///
  // ignore: always_specify_types
  List<Polygon> getNeighborArea() {
    neighborsList.clear();

    final List<String> list = <String>[];

    // ignore: always_specify_types
    final List<Polygon<Object>> polygonList = <Polygon>[];

    if (appParamState.keepTokyoMunicipalMap[widget.cityTownName] != null) {
      neighborsList = getNeighborsArea(
        target: appParamState.keepTokyoMunicipalMap[widget.cityTownName]!,
        all: appParamState.keepTokyoMunicipalList,
      );

      if (neighborsList.isNotEmpty) {
        for (final TokyoMunicipalModel element in neighborsList) {
          list.add(element.name);

          if (appParamState.neighborAreaNameList.contains(element.name)) {
            for (final List<List<List<double>>> element2 in element.polygons) {
              final Polygon<Object>? polygon = getColorPaintPolygon(polygon: element2, color: Colors.blueAccent);

              if (polygon != null) {
                polygonList.add(polygon);
              }
            }
          }
        }
      }
    }

    if (!isSetNeighborAreaNameList) {
      setState(() => neighborAreaNameList = list);

      // ignore: always_specify_types
      Future(() => appParamNotifier.setDefaultNeighborAreaNameList(list: list));

      isSetNeighborAreaNameList = true;
    }

    return polygonList;
  }

  ///
  void makeVisitedMunicipalSpotDataMarker() {
    visitedTemplesMarkerList.clear();

    widget.visitedMunicipalSpotDataListMap[widget.cityTownName]?.forEach((SpotDataModel element) {
      visitedTemplesMarkerList.add(
        Marker(
          point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),

          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSelectedSpotDataModel(spotDataModel: element);

              callSecondBox();
            },
            child: Stack(
              children: <Widget>[
                Positioned(bottom: 0, right: 0, child: Text(element.rank, style: const TextStyle(fontSize: 30))),

                CircleAvatar(
                  backgroundColor: Colors.orangeAccent.withValues(alpha: 0.4),
                  child: Text(
                    element.mark.padLeft(3, '0'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  ///
  void makeNoReachMunicipalSpotDataMarker() {
    noReachTemplesMarkerList.clear();

    widget.noReachMunicipalSpotDataListMap[widget.cityTownName]?.forEach((SpotDataModel element) {
      noReachTemplesMarkerList.add(
        Marker(
          point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSelectedSpotDataModel(spotDataModel: element);

              callSecondBox();
            },
            child: CircleAvatar(
              backgroundColor: Colors.pinkAccent.withValues(alpha: 0.4),
              child: Text(
                element.mark.padLeft(3, '0'),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    });
  }

  ///
  Widget buildExpandedChildContents() {
    final List<Widget> list = <Widget>[];

    list.add(const SizedBox(height: 20));

    list.add(
      Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
        ),

        padding: const EdgeInsets.symmetric(vertical: 5),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Visited'),
            Text(
              (widget.visitedMunicipalSpotDataListMap[widget.cityTownName] != null)
                  ? widget.visitedMunicipalSpotDataListMap[widget.cityTownName]!.length.toString()
                  : '0',
            ),
          ],
        ),
      ),
    );

    list.add(
      Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
        ),

        padding: const EdgeInsets.symmetric(vertical: 5),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('No Reach'),
            Text(
              (widget.noReachMunicipalSpotDataListMap[widget.cityTownName] != null)
                  ? widget.noReachMunicipalSpotDataListMap[widget.cityTownName]!.length.toString()
                  : '0',
            ),
          ],
        ),
      ),
    );

    list.add(
      SizedBox(
        height: 60,

        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: neighborAreaNameList.map((String e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    appParamNotifier.setNeighborAreaNameList(name: e);

                    setState(() => displayNeighborTemple = false);
                  },

                  child: CircleAvatar(
                    backgroundColor: (appParamState.neighborAreaNameList.contains(e))
                        ? Colors.yellowAccent.withValues(alpha: 0.4)
                        : Colors.blueAccent.withValues(alpha: 0.4),

                    child: Text(e, style: const TextStyle(fontSize: 10, color: Colors.black)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    list.add(
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: <String>['-', 'S', 'A', 'B', 'C'].map((String e) {
            return GestureDetector(
              onTap: () {
                if (e == '-') {
                  appParamNotifier.clearSelectedCityTownTempleMapRankList();
                } else {
                  appParamNotifier.setSelectedCityTownTempleMapRankList(rank: e);
                }
              },
              child: Container(
                width: context.screenSize.width / 8,
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (e == '-')
                      ? Colors.black.withValues(alpha: 0.3)
                      : (appParamState.selectedCityTownTempleMapRankList.contains(e))
                      ? Colors.yellowAccent.withValues(alpha: 0.3)
                      : const Color(0xFFFBB6CE).withValues(alpha: 0.5),
                ),

                child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomScrollView(
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

  ///
  void makeTokyoStationMarkerList() {
    tokyoStationMarkerList.clear();

    for (final StationModel element in appParamState.keepTokyoStationList) {
      tokyoStationMarkerList.add(
        Marker(
          point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
          child: Icon(Icons.circle_outlined, color: Colors.green[900]),
        ),
      );
    }
  }

  ///
  void makeNeighborTempleMarker() {
    neighborTempleMarkerList.clear();

    for (final String element in appParamState.neighborAreaNameList) {
      widget.visitedMunicipalSpotDataListMap[element]?.forEach((SpotDataModel element2) {
        neighborTempleMarkerList.add(
          Marker(
            point: LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()),

            child: GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedSpotDataModel(spotDataModel: element2);

                callSecondBox();
              },
              child: Stack(
                children: <Widget>[
                  Positioned(bottom: 0, right: 0, child: Text(element2.rank, style: const TextStyle(fontSize: 30))),

                  CircleAvatar(
                    backgroundColor: Colors.orangeAccent.withValues(alpha: 0.4),
                    child: Text(
                      element2.mark.padLeft(3, '0'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

      widget.noReachMunicipalSpotDataListMap[element]?.forEach((SpotDataModel element2) {
        neighborTempleMarkerList.add(
          Marker(
            point: LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()),

            child: GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedSpotDataModel(spotDataModel: element2);

                callSecondBox();
              },
              child: CircleAvatar(
                backgroundColor: Colors.pinkAccent.withValues(alpha: 0.4),
                child: Text(
                  element2.mark.padLeft(3, '0'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  ///
  void callSecondBox() {
    appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

    addSecondOverlay(
      context: context,
      secondEntries: _secondEntries,
      setStateCallback: setState,
      width: context.screenSize.width,
      height: context.screenSize.height * 0.2,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(0, context.screenSize.height * 0.8),

      widget: displaySelectedSpotDataModel(),

      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
      fixedFlag: true,
    );
  }

  ///
  Widget displaySelectedSpotDataModel() {
    if (appParamState.selectedSpotDataModel == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: <Widget>[
        if (appParamState.selectedSpotDataModel!.rank != '') ...<Widget>[
          Positioned(
            top: 5,
            right: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(appParamState.selectedSpotDataModel!.mark.padLeft(3, '0')),

                const SizedBox(width: 10),

                Text(
                  appParamState.selectedSpotDataModel!.rank,
                  style: const TextStyle(fontSize: 60, color: Color(0xFFFBB6CE)),
                ),
              ],
            ),
          ),
        ],

        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: double.infinity),

              Text(appParamState.selectedSpotDataModel!.name, style: const TextStyle(fontSize: 16)),
              Text(appParamState.selectedSpotDataModel!.address),
              Text(
                '${appParamState.selectedSpotDataModel!.latitude} / ${appParamState.selectedSpotDataModel!.longitude}',
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
