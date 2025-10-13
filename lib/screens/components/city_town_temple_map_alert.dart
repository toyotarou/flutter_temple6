import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/_get_data/get_data.dart';
import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/municipal_model.dart';
import '../../models/station_model.dart';
import '../../models/tokyo_train_model.dart';
import '../../models/train_model.dart';
import '../../utility/map_functions.dart';
import '../../utility/tile_provider.dart';
import '../../utility/utility.dart';
import '../parts/error_dialog.dart';
import '../parts/expandable_box.dart';
import '../parts/temple_dialog.dart';
import '../parts/temple_overlay.dart';
import 'required_time_calculate_setting_alert.dart';

class CityTownTempleMapAlert extends ConsumerStatefulWidget {
  const CityTownTempleMapAlert({
    super.key,
    required this.cityTownName,
    required this.latList,
    required this.lngList,
    this.selectArealPolygons,
    required this.visitedMunicipalSpotDataListMap,
    required this.noReachMunicipalSpotDataListMap,
  });

  final String cityTownName;
  final List<double> latList;
  final List<double> lngList;
  final List<List<List<List<double>>>>? selectArealPolygons;
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

  List<MunicipalModel> neighborsTokyoMunicipalModelList = <MunicipalModel>[];

  List<String> neighborAreaNameList = <String>[];

  List<Marker> visitedTemplesMarkerList = <Marker>[];

  List<Marker> noReachTemplesMarkerList = <Marker>[];

  List<Marker> tokyoStationMarkerList = <Marker>[];

  bool displayStations = false;

  List<Marker> neighborTemplesMarkerList = <Marker>[];

  bool displayNeighborTemples = false;

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  List<Marker> selectedSpotsMarkerList = <Marker>[];

  Utility utility = Utility();

  // ignore: always_specify_types
  List<PolylineLayer> busRoutePolylineLayerList = <PolylineLayer>[];

  bool makeBusPolylineFlag = false;

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

    makeTokyoStationMarker();

    makeSelectedSpotsMarkerList();

    /////////////////////////////////////////////// bus
    if (appParamState.busInfoDisplayFlag) {
      if (!makeBusPolylineFlag) {
        makeBusRoutePolylineLayerList();

        makeBusPolylineFlag = true;
      }
    } else {
      makeBusPolylineFlag = false;

      busRoutePolylineLayerList.clear();
    }
    /////////////////////////////////////////////// bus

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

                if (widget.selectArealPolygons != null) ...<Widget>[
                  // ignore: always_specify_types
                  PolygonLayer(polygons: makeAreaPolygons()),
                ],

                if (neighborsTokyoMunicipalModelList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolygonLayer(polygons: getNeighborArea()),
                ],

                if (appParamState.selectedTrainName != '' &&
                    getDataState.keepTokyoTrainMap[appParamState.selectedTrainName] != null &&
                    getDataState.keepTokyoTrainMap[appParamState.selectedTrainName]!.station.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(polylines: makeTrainPolyline()),
                ],

                /////////////////////////////////////////////// bus
                for (int i = 0; i < busRoutePolylineLayerList.length; i++) busRoutePolylineLayerList[i],

                if (appParamState.addRouteSpotDataModelList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolylineLayer(polylines: makeAddSpotsPolyline()),
                ],

                if (selectedSpotsMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: selectedSpotsMarkerList)],

                if (visitedTemplesMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: visitedTemplesMarkerList)],

                if (noReachTemplesMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: noReachTemplesMarkerList)],

                if (tokyoStationMarkerList.isNotEmpty && displayStations) ...<Widget>[
                  MarkerLayer(markers: tokyoStationMarkerList),
                ],

                if (neighborTemplesMarkerList.isNotEmpty && displayNeighborTemples) ...<Widget>[
                  MarkerLayer(markers: neighborTemplesMarkerList),
                ],
              ],
            ),

            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ExpandableBox(
                      alignment: Alignment.topCenter,
                      keepFullWidth: true,

                      collapsedSize: Size(0, context.screenSize.height * 0.05),
                      expandedSize: Size(
                        0,
                        (widget.cityTownName == 'tokyo')
                            ? context.screenSize.height * 0.2
                            : context.screenSize.height * 0.3,
                      ),

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

                    if (appParamState.addRouteSpotDataModelList.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),

                      ExpandableBox(
                        alignment: Alignment.topLeft,
                        collapsedSize: Size(context.screenSize.width * 0.1, 80),
                        expandedSize: Size(context.screenSize.width * 0.7, context.screenSize.height * 0.2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                        ),
                        collapsedChild: const Icon(Icons.square_outlined, color: Colors.transparent),
                        expandedChild: displayAddedSpotDataList(),
                      ),
                    ],
                  ],
                ),

                Positioned(top: 5, left: 50, child: Text(widget.cityTownName, style: const TextStyle(fontSize: 20))),

                if (widget.cityTownName != 'tokyo') ...<Widget>[
                  Positioned(
                    top: 5,
                    right: 60,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            makeNeighborTempleMarker();

                            setState(() => displayNeighborTemples = !displayNeighborTemples);
                          },
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0x66000000),
                            child: Icon(FontAwesomeIcons.toriiGate, size: 18, color: Colors.white),
                          ),
                        ),

                        const SizedBox(width: 15),

                        GestureDetector(
                          onTap: () => setState(() => displayStations = !displayStations),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0x66000000),
                            child: Text(
                              '駅',
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                Positioned(
                  top: 5,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => setDefaultBoundsMap(),
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0x66000000),
                      child: Icon(Icons.filter_center_focus, size: 18, color: Colors.white),
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

    final List<Color> twentyFourColor = utility.getTwentyFourColor();

    if (widget.selectArealPolygons != null) {
      for (int i = 0; i < widget.selectArealPolygons!.length; i++) {
        final Polygon<Object>? polygon = getColorPaintPolygon(
          polygon: widget.selectArealPolygons![i],
          color: (widget.cityTownName == 'tokyo') ? twentyFourColor[i % 24] : Colors.redAccent,
        );

        if (polygon != null) {
          polygonList.add(polygon);
        }
      }
    }

    return polygonList;
  }

  bool isSetNeighborAreaNameList = false;

  ///
  // ignore: always_specify_types
  List<Polygon> getNeighborArea() {
    neighborsTokyoMunicipalModelList.clear();

    final List<String> list = <String>[];

    // ignore: always_specify_types
    final List<Polygon<Object>> polygonList = <Polygon>[];

    if (getDataState.keepTokyoMunicipalMap[widget.cityTownName] != null) {
      neighborsTokyoMunicipalModelList = getNeighborsArea(
        target: getDataState.keepTokyoMunicipalMap[widget.cityTownName]!,
        all: getDataState.keepTokyoMunicipalList,
      );

      if (neighborsTokyoMunicipalModelList.isNotEmpty) {
        for (final MunicipalModel element in neighborsTokyoMunicipalModelList) {
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
      bool flag = true;

      if (appParamState.selectedCityTownTempleMapRankList.isNotEmpty) {
        if (!appParamState.selectedCityTownTempleMapRankList.contains(element.rank)) {
          flag = false;
        }
      }

      if (flag) {
        visitedTemplesMarkerList.add(
          Marker(
            point: LatLng(element.latitude.toDouble(), element.longitude.toDouble()),

            child: GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedSpotDataModel(spotDataModel: element);

                callSecondBox(type: 'temple');
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
      }
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

              callSecondBox(type: 'temple');
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
      Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
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
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox.shrink(),

                if (widget.cityTownName != 'tokyo') ...<Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => appParamNotifier.setIsJrInclude(flag: !appParamState.isJrInclude),
                        child: Text(
                          'JR',
                          style: TextStyle(
                            color: (appParamState.isJrInclude) ? Colors.yellowAccent : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      GestureDetector(
                        onTap: () => callFirstBox(),
                        child: CircleAvatar(
                          backgroundColor: Colors.green[900]?.withValues(alpha: 0.6),
                          child: const Icon(Icons.stacked_line_chart, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
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

                    setState(() => displayNeighborTemples = false);
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

    if (widget.cityTownName != 'tokyo') {
      list.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <String>['-', 'S', 'A', 'B', 'C'].map((String e) {
                  return GestureDetector(
                    onTap: () {
                      if (e == '-') {
                        appParamNotifier.clearSelectedCityTownTempleMapRankList();
                      } else {
                        appParamNotifier.setSelectedCityTownTempleMapRankList(rank: e);
                      }

                      makeNeighborTempleMarker();
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
            ],
          ),
        ),
      );
    }

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
  void makeTokyoStationMarker() {
    tokyoStationMarkerList.clear();

    final List<String?> jrTrainNumberList = getDataState.keepTrainList.map((TrainModel e) {
      if (matchJrInTrainName(str: e.trainName)) {
        return e.trainNumber;
      }
    }).toList();

    jrTrainNumberList.removeWhere((String? e) => e == null);

    for (final StationModel element in getDataState.keepTokyoStationList) {
      for (final MunicipalModel? element2 in <MunicipalModel?>[
        getDataState.keepTokyoMunicipalMap[widget.cityTownName],
        ...neighborsTokyoMunicipalModelList,
      ]) {
        if (element2 != null) {
          if (spotInMunicipality(element.lat.toDouble(), element.lng.toDouble(), element2)) {
            bool flag = true;

            if (!appParamState.isJrInclude) {
              if (jrTrainNumberList.contains(element.lineNumber)) {
                flag = false;
              }
            }

            if (flag) {
              final List<String> busKeyList = getDataState.keepBusInfoSpotDataModelMap.keys
                  .map((SpotDataModel key) => key.name)
                  .toList();

              tokyoStationMarkerList.add(
                Marker(
                  point: LatLng(element.lat.toDouble(), element.lng.toDouble()),
                  child: GestureDetector(
                    onTap: () {
                      appParamNotifier.setSelectedSpotDataModel(
                        spotDataModel: SpotDataModel(
                          type: 'station',
                          name: element.stationName,
                          address: element.address,
                          latitude: element.lat,
                          longitude: element.lng,
                        ),
                      );

                      callSecondBox(type: 'station');
                    },

                    child: Icon(
                      Icons.circle_outlined,
                      color: (busKeyList.contains(element.stationName)) ? Colors.green[900] : Colors.red[900],
                    ),
                  ),
                ),
              );
            }
          }
        }
      }
    }
  }

  ///
  bool matchJrInTrainName({required String str}) => RegExp('JR').firstMatch(str) != null;

  ///
  void makeNeighborTempleMarker() {
    neighborTemplesMarkerList.clear();

    for (final String element in appParamState.neighborAreaNameList) {
      widget.visitedMunicipalSpotDataListMap[element]?.forEach((SpotDataModel element2) {
        bool flag = true;

        if (appParamState.selectedCityTownTempleMapRankList.isNotEmpty) {
          if (!appParamState.selectedCityTownTempleMapRankList.contains(element2.rank)) {
            flag = false;
          }
        }

        if (flag) {
          neighborTemplesMarkerList.add(
            Marker(
              point: LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()),

              child: GestureDetector(
                onTap: () {
                  appParamNotifier.setSelectedSpotDataModel(spotDataModel: element2);

                  callSecondBox(type: 'temple');
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
        }
      });

      widget.noReachMunicipalSpotDataListMap[element]?.forEach((SpotDataModel element2) {
        neighborTemplesMarkerList.add(
          Marker(
            point: LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()),

            child: GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedSpotDataModel(spotDataModel: element2);

                callSecondBox(type: 'temple');
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
  void callFirstBox() {
    appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

    addFirstOverlay(
      context: context,
      setStateCallback: setState,
      width: MediaQuery.of(context).size.width * 0.7,
      height: 300,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: const Offset(20, 120),

      widget: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return displayTokyoTrainList(
            selectedTrainName: ref.watch(appParamProvider.select((AppParamState value) => value.selectedTrainName)),
          );
        },
      ),

      firstEntries: _firstEntries,
      secondEntries: _secondEntries,
      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
    );
  }

  ///
  Widget displayTokyoTrainList({required String selectedTrainName}) {
    final List<Widget> list = <Widget>[];

    final List<String> tokyoTrainNameList = <String>[];

    final RegExp reg = RegExp('新幹線');

    for (final MunicipalModel? element in <MunicipalModel?>[
      getDataState.keepTokyoMunicipalMap[widget.cityTownName],
      ...neighborsTokyoMunicipalModelList,
    ]) {
      if (element != null) {
        for (final TokyoTrainModel element2 in getDataState.keepTokyoTrainList) {
          for (final TokyoStationModel element3 in element2.station) {
            if (spotInMunicipality(element3.lat, element3.lng, element)) {
              if (reg.firstMatch(element2.trainName) == null) {
                bool flag = true;

                if (!appParamState.isJrInclude) {
                  if (matchJrInTrainName(str: element2.trainName)) {
                    flag = false;
                  }
                }

                if (flag) {
                  tokyoTrainNameList.add(element2.trainName);
                }
              }
            }
          }
        }
      }
    }

    final List<String> uniqueTrainNameList = tokyoTrainNameList.toSet().toList();

    for (final String element in uniqueTrainNameList) {
      if (getDataState.keepTokyoTrainMap[element] != null) {
        list.add(
          ExpansionTile(
            collapsedIconColor: Colors.white,
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            title: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 35),

                      Text(
                        element,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    appParamNotifier.setSelectedTrainName(name: element);
                  },

                  child: Icon(
                    Icons.check_circle,
                    color: (selectedTrainName == element) ? Colors.yellowAccent : Colors.white,
                  ),
                ),
              ],
            ),

            children: getDataState.keepTokyoTrainMap[element]!.station.map((TokyoStationModel e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(e.stationName, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox.shrink(),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: context.screenSize.height * 0.25,

          child: SingleChildScrollView(child: Column(children: list)),
        ),
      ],
    );
  }

  ///
  void callSecondBox({required String type}) {
    appParamNotifier.setSecondOverlayParams(secondEntries: _secondEntries);

    addSecondOverlay(
      context: context,
      secondEntries: _secondEntries,
      setStateCallback: setState,
      width: context.screenSize.width,
      height: (widget.cityTownName == 'tokyo') ? context.screenSize.height * 0.2 : context.screenSize.height * 0.3,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(
        0,
        (widget.cityTownName == 'tokyo') ? context.screenSize.height * 0.8 : context.screenSize.height * 0.7,
      ),

      widget: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final Map<String, List<TokyoTrainModel>> keepTokyoStationTokyoTrainModelListMap = ref.watch(
            getDataProvider.select((GetDataState value) => value.keepTokyoStationTokyoTrainModelListMap),
          );

          final SpotDataModel? selectedSpotDataModel = ref.watch(
            appParamProvider.select((AppParamState value) => value.selectedSpotDataModel),
          );

          return displaySelectedSpotDataModel(
            type: type,

            addRouteSpotDataModelList: ref.watch(
              appParamProvider.select((AppParamState value) => value.addRouteSpotDataModelList),
            ),

            isJrInclude: ref.watch(appParamProvider.select((AppParamState value) => value.isJrInclude)),

            busInfoDisplayFlag: ref.watch(appParamProvider.select((AppParamState value) => value.busInfoDisplayFlag)),

            tokyoStation: keepTokyoStationTokyoTrainModelListMap[selectedSpotDataModel?.name],
          );
        },
      ),

      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
      fixedFlag: true,
    );
  }

  ///
  Widget displaySelectedSpotDataModel({
    required String type,
    required List<SpotDataModel> addRouteSpotDataModelList,
    required bool isJrInclude,
    required bool busInfoDisplayFlag,
    List<TokyoTrainModel>? tokyoStation,
  }) {
    if (appParamState.selectedSpotDataModel == null) {
      return const SizedBox.shrink();
    }

    final List<String> busKeyList = getDataState.keepBusInfoSpotDataModelMap.keys
        .map((SpotDataModel key) => key.name)
        .toList();

    return Stack(
      children: <Widget>[
        if (type == 'temple') ...<Widget>[
          Positioned(
            right: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (appParamState.selectedSpotDataModel!.rank != '') ...<Widget>[
                  Text(
                    appParamState.selectedSpotDataModel!.rank,
                    style: const TextStyle(fontSize: 60, color: Color(0xFFFBB6CE)),
                  ),
                ],

                const SizedBox(width: 10),

                Transform(
                  transform: Matrix4.diagonal3Values(1.0, 3.0, 1.0),
                  child: Text(
                    appParamState.selectedSpotDataModel!.mark.padLeft(3, '0'),
                    style: TextStyle(fontSize: 40, color: Colors.white.withValues(alpha: 0.4)),
                  ),
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

              SizedBox(
                height: 30,
                child: (type == 'temple')
                    ? null
                    : (tokyoStation == null)
                    ? null
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: tokyoStation.map((TokyoTrainModel e) {
                            bool flag = true;

                            if (!isJrInclude) {
                              if (matchJrInTrainName(str: e.trainName)) {
                                flag = false;
                              }
                            }

                            if (flag) {
                              return GestureDetector(
                                onTap: () => appParamNotifier.setSelectedTrainName(name: e.trainName),

                                child: Container(
                                  width: context.screenSize.width / 3,
                                  margin: const EdgeInsets.all(3),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.4)),
                                  child: Text(e.trainName, style: const TextStyle(fontSize: 12)),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }).toList(),
                        ),
                      ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox.shrink(),

                  if (widget.cityTownName != 'tokyo') ...<Widget>[
                    Row(
                      children: <Widget>[
                        if (busKeyList.contains(appParamState.selectedSpotDataModel!.name)) ...<Widget>[
                          IconButton(
                            onPressed: () {
                              appParamNotifier.setBusInfoDisplayFlag();

                              appParamNotifier.setSelectedSpotDataModelForBusInfo(
                                spotDataModel: SpotDataModel(
                                  type: 'bus',
                                  name: appParamState.selectedSpotDataModel!.name,
                                  address: appParamState.selectedSpotDataModel!.address,
                                  latitude: appParamState.selectedSpotDataModel!.latitude,
                                  longitude: appParamState.selectedSpotDataModel!.longitude,
                                ),
                              );
                            },
                            icon: Icon(
                              FontAwesomeIcons.bus,
                              color: busInfoDisplayFlag ? Colors.yellowAccent : Colors.white,
                            ),
                          ),

                          const SizedBox(width: 20),
                        ],

                        ElevatedButton(
                          onPressed: () {
                            final SpotDataModel selected = appParamState.selectedSpotDataModel!;
                            final List<SpotDataModel> list = appParamState.addRouteSpotDataModelList;

                            final bool isAlreadyInList = list.contains(selected);

                            final Map<String, String> spotAddCheckValueMap = getSpotAddCheckValueMap(
                              list: list,
                              selected: selected,
                              isAlreadyInList: isAlreadyInList,
                            );

                            if (spotAddCheckValueMap.isNotEmpty) {
                              // ignore: always_specify_types
                              Future.delayed(
                                Duration.zero,
                                () => error_dialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  title: spotAddCheckValueMap['title'] ?? '',
                                  content: spotAddCheckValueMap['content'] ?? '',
                                ),
                              );

                              return;
                            }

                            appParamNotifier.setAddRouteSpotDataModelList(
                              spotDataModel: appParamState.selectedSpotDataModel!,
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),

                          child: Text(
                            (addRouteSpotDataModelList.contains(appParamState.selectedSpotDataModel))
                                ? 'remove from route'
                                : 'add to route',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Map<String, String> getSpotAddCheckValueMap({
    required List<SpotDataModel> list,
    required SpotDataModel selected,
    required bool isAlreadyInList,
  }) {
    if (isAlreadyInList) {
      return <String, String>{};
    }

    if (list.isEmpty) {
      if (selected.type != 'station') {
        return <String, String>{'title': 'エラー', 'content': 'ひとつめは station を選択してください。'};
      }
      return <String, String>{};
    }

    if (list.last.type == 'station' && selected.type == 'station') {
      return <String, String>{'title': 'エラー', 'content': '連続で station を登録することはできません。'};
    }

    if (selected.type == 'station') {
      final int stationCount = list.where((SpotDataModel e) => e.type == 'station').length;
      if (stationCount >= 2) {
        return <String, String>{'title': 'エラー', 'content': 'station は2件までです。現在$stationCount件登録済みです。'};
      }
    }

    return <String, String>{};
  }

  ///
  // ignore: always_specify_types
  List<Polyline> makeTrainPolyline() {
    return <Polyline<Object>>[
      for (int i = 0; i < getDataState.keepTokyoTrainMap[appParamState.selectedTrainName]!.station.length; i++)
        // ignore: always_specify_types
        Polyline(
          points: getDataState.keepTokyoTrainMap[appParamState.selectedTrainName]!.station
              .map((TokyoStationModel e) => LatLng(e.lat, e.lng))
              .toList(),
          color: Colors.redAccent,
          strokeWidth: 5,
        ),
    ];
  }

  ///
  Widget displayAddedSpotDataList() {
    return Padding(
      padding: const EdgeInsets.all(10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ReorderableListView.builder(
              proxyDecorator: (Widget child, int index, Animation<double> animation) {
                final ThemeData theme = Theme.of(context);

                return AnimatedBuilder(
                  animation: animation,

                  builder: (BuildContext context, _) {
                    return Material(
                      elevation: 8 * animation.value,
                      color: Colors.transparent,
                      child: Theme(
                        data: theme.copyWith(
                          listTileTheme: const ListTileThemeData(
                            textColor: Colors.yellowAccent,
                            iconColor: Colors.yellowAccent,
                          ),
                        ),

                        child: child,
                      ),
                    );
                  },
                );
              },

              onReorder: (int oldIndex, int newIndex) =>
                  appParamNotifier.reorderAddRouteSpotDataModelList(oldIndex: oldIndex, newIndex: newIndex),

              buildDefaultDragHandles: false,

              itemCount: appParamState.addRouteSpotDataModelList.length,

              itemBuilder: (BuildContext context, int index) {
                final bool isLocked = index == 0;

                return ListTile(
                  // ignore: always_specify_types
                  key: ValueKey(index),

                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),

                  title: Stack(
                    children: <Widget>[
                      if (index != 0 && appParamState.addRouteSpotDataModelList[index].type != 'station') ...<Widget>[
                        Positioned(
                          right: 10,
                          child: Transform(
                            transform: Matrix4.diagonal3Values(1.0, 3.0, 1.0),
                            child: Text(
                              appParamState.addRouteSpotDataModelList[index].mark.padLeft(3, '0'),
                              style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      ],

                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                        ),

                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: (appParamState.addRouteSpotDataModelList[index].type == 'station')
                                        ? Colors.blueAccent
                                        : Colors.black,
                                    radius: 15,
                                    child: Text(index.toString(), style: const TextStyle(color: Colors.white)),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Stack(
                                      children: <Widget>[
                                        if (index == 0 ||
                                            index == appParamState.addRouteSpotDataModelList.length - 1) ...<Widget>[
                                          Positioned(
                                            right: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              child: Text(
                                                (index == 0) ? 'START' : 'END',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],

                                        DefaultTextStyle(
                                          style: const TextStyle(fontSize: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(appParamState.addRouteSpotDataModelList[index].name),
                                              Text(
                                                appParamState.addRouteSpotDataModelList[index].type,
                                                style: const TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            if (isLocked)
                              const Icon(Icons.square_outlined, color: Colors.transparent)
                            else
                              ReorderableDragStartListener(index: index, child: const Icon(Icons.drag_handle)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              if (appParamState.addRouteSpotDataModelList.isNotEmpty) {
                if (appParamState.addRouteSpotDataModelList.last.type != 'station') {
                  // ignore: always_specify_types
                  Future.delayed(
                    Duration.zero,
                    () => error_dialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      title: 'エラー',
                      content: '最後の要素はstationを選択してください。',
                    ),
                  );

                  return;
                }
              }

              try {
                closeAllOverlays(ref: ref);
                // ignore: empty_catches
              } catch (e) {}

              TempleDialog(context: context, widget: const RequiredTimeCalculateSettingAlert());
            },
            child: const Icon(Icons.input),
          ),
        ],
      ),
    );
  }

  ///
  void makeSelectedSpotsMarkerList() {
    selectedSpotsMarkerList.clear();

    for (int i = 0; i < appParamState.addRouteSpotDataModelList.length; i++) {
      selectedSpotsMarkerList.add(
        Marker(
          width: 80,

          point: LatLng(
            appParamState.addRouteSpotDataModelList[i].latitude.toDouble(),
            appParamState.addRouteSpotDataModelList[i].longitude.toDouble(),
          ),

          child: Stack(
            children: <Widget>[
              const Row(
                children: <Widget>[
                  SizedBox(width: 20, height: 20, child: SizedBox()),
                  Icon(Icons.location_on, color: Colors.purpleAccent, size: 40),
                ],
              ),

              Positioned(
                left: 50,
                top: 10,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (i == 0) ? Colors.blueAccent : Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(i.toString()),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  ///
  // ignore: always_specify_types
  List<Polyline> makeAddSpotsPolyline() {
    return <Polyline<Object>>[
      for (int i = 0; i < appParamState.addRouteSpotDataModelList.length; i++)
        // ignore: always_specify_types
        Polyline(
          points: appParamState.addRouteSpotDataModelList
              .map((SpotDataModel e) => LatLng(e.latitude.toDouble(), e.longitude.toDouble()))
              .toList(),
          color: Colors.purpleAccent,
          strokeWidth: 5,
        ),
    ];
  }

  ///
  void makeBusRoutePolylineLayerList() {
    busRoutePolylineLayerList.clear();

    if (appParamState.selectedSpotDataModelForBusInfo != null) {
      final List<SpotDataModel> spotDataModelList = getDataState.keepBusInfoSpotDataModelMap.entries.firstWhere((
        MapEntry<SpotDataModel, List<SpotDataModel>> entry,
      ) {
        return entry.key.name == appParamState.selectedSpotDataModelForBusInfo!.name;
      }).value;

      for (final SpotDataModel element in spotDataModelList) {
        busRoutePolylineLayerList.add(
          // ignore: always_specify_types
          PolylineLayer(
            polylines: <Polyline<Object>>[
              // ignore: always_specify_types
              Polyline(
                points: <LatLng>[
                  LatLng(
                    appParamState.selectedSpotDataModelForBusInfo!.latitude.toDouble(),
                    appParamState.selectedSpotDataModelForBusInfo!.longitude.toDouble(),
                  ),
                  LatLng(element.latitude.toDouble(), element.longitude.toDouble()),
                ],
                color: Colors.purpleAccent.withOpacity(0.5),
                strokeWidth: 4,
              ),
            ],
          ),
        );
      }
    }
  }
}
