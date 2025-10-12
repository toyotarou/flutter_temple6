import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/app_param/app_param.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../utility/functions.dart';
import '../../utility/tile_provider.dart';
import '../parts/expandable_box.dart';
import '../parts/temple_dialog.dart';
import '../parts/temple_overlay.dart';
import 'temple_photo_list_alert.dart';

class DailyTempleMapAlert extends ConsumerStatefulWidget {
  const DailyTempleMapAlert({
    super.key,
    required this.date,
    required this.templeDataList,
    required this.templeMunicipalList,
  });

  final String date;
  final List<SpotDataModel> templeDataList;
  final List<String> templeMunicipalList;

  @override
  ConsumerState<DailyTempleMapAlert> createState() => _DailyTempleMapAlertState();
}

class _DailyTempleMapAlertState extends ConsumerState<DailyTempleMapAlert> with ControllersMixin<DailyTempleMapAlert> {
  bool isLoading = false;

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  List<Marker> markerList = <Marker>[];

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  List<Marker> municipalTempleMarkerList = <Marker>[];

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
    if (widget.templeDataList.isNotEmpty) {
      mapController.rotate(0);

      final LatLngBounds bounds = LatLngBounds.fromPoints(
        widget.templeDataList.map((SpotDataModel e) => LatLng(e.latitude.toDouble(), e.longitude.toDouble())).toList(),
      );

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

      if (widget.templeMunicipalList.isNotEmpty) {
        callFirstBox();
      }
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMarker();

    makeMunicipalTempleMarkerList();

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

                if (appParamState.selectedMunicipalNameList.isNotEmpty) ...<Widget>[
                  // ignore: always_specify_types
                  PolygonLayer(polygons: makeAreaPolygons()),
                ],

                // ignore: always_specify_types
                PolylineLayer(polylines: makeTransportationPolyline()),

                MarkerLayer(markers: markerList),

                if (municipalTempleMarkerList.isNotEmpty) MarkerLayer(markers: municipalTempleMarkerList),
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
                      expandedSize: Size(0, context.screenSize.height * 0.2),

                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                      ),
                      collapsedChild: const Icon(Icons.square_outlined, color: Colors.transparent),
                      expandedChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),

                          Expanded(child: displayDailyTempleList()),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(widget.date, style: const TextStyle(fontSize: 20)),
                    ),

                    Positioned(
                      top: 5,
                      right: 60,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
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
  void makeMarker() {
    markerList.clear();

    for (int i = 0; i < widget.templeDataList.length; i++) {
      markerList.add(
        Marker(
          point: LatLng(widget.templeDataList[i].latitude.toDouble(), widget.templeDataList[i].longitude.toDouble()),
          width: 20,
          height: 20,

          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSelectedSpotDataModel(spotDataModel: widget.templeDataList[i]);

              callSecondBox();
            },

            child: (int.tryParse(widget.templeDataList[i].mark) != null)
                ? Stack(
                    children: <Widget>[
                      const Icon(FontAwesomeIcons.toriiGate, size: 20, color: Colors.pinkAccent),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(radius: 8, child: Text(i.toString(), style: const TextStyle(fontSize: 10))),
                      ),
                    ],
                  )
                : CircleAvatar(
                    backgroundColor: Colors.green[900],

                    child: Text(
                      widget.templeDataList[i].mark,
                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ),
      );
    }
  }

  ///
  Widget displayDailyTempleList() {
    final List<Widget> list = <Widget>[];

    for (final SpotDataModel element in widget.templeDataList) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),

          padding: const EdgeInsets.symmetric(vertical: 5),

          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                CircleAvatar(
                  backgroundColor: (int.tryParse(element.mark) != null)
                      ? Colors.pinkAccent.withValues(alpha: 0.5)
                      : Colors.green[900]?.withValues(alpha: 0.5),

                  radius: 15,
                  child: Text(
                    (int.tryParse(element.mark) != null) ? (element.mark.toInt() + 1).toString() : element.mark,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Text(element.rank, style: const TextStyle(fontSize: 40, color: Color(0xFFFBB6CE))),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(element.name),

                          Text('${element.latitude} / ${element.longitude}', style: const TextStyle(fontSize: 10)),

                          Text(element.address),
                        ],
                      ),
                    ],
                  ),
                ),

                if (int.tryParse(element.mark) != null) ...<Widget>[
                  GestureDetector(
                    onTap: () {
                      try {
                        closeAllOverlays(ref: ref);
                        // ignore: empty_catches
                      } catch (e) {}

                      TempleDialog(
                        context: context,
                        widget: TemplePhotoListAlert(temple: element.name),
                        clearBarrierColor: true,

                        paddingTop: context.screenSize.height * 0.2,
                        paddingRight: context.screenSize.width * 0.2,
                      );
                    },
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0x66000000),

                      child: Icon(Icons.photo_outlined, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
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
  // ignore: always_specify_types
  List<Polyline> makeTransportationPolyline() {
    // ignore: always_specify_types
    return <Polyline<Object>>[
      // ignore: always_specify_types
      Polyline(
        points: widget.templeDataList
            .map((SpotDataModel e) => LatLng(e.latitude.toDouble(), e.longitude.toDouble()))
            .toList(),
        color: Colors.redAccent.withValues(alpha: 0.5),
        strokeWidth: 5,
      ),
    ];
  }

  ///
  void callFirstBox() {
    appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

    addFirstOverlay(
      context: context,
      setStateCallback: setState,
      width: context.screenSize.width * 0.25,
      height: context.screenSize.height * 0.25,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(context.screenSize.width * 0.75, context.screenSize.height * 0.3),

      widget: SingleChildScrollView(
        child: Column(
          children: widget.templeMunicipalList.map((String e) {
            return GestureDetector(
              onTap: () {
                appParamNotifier.setSelectedMunicipalNameList(municipal: e);
              },

              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final List<String> selectedMunicipalNameList = ref.watch(
                    appParamProvider.select((AppParamState value) => value.selectedMunicipalNameList),
                  );

                  return Container(
                    margin: const EdgeInsets.all(5),

                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    decoration: BoxDecoration(
                      color: (selectedMunicipalNameList.contains(e))
                          ? Colors.yellowAccent.withValues(alpha: 0.1)
                          : Colors.transparent,

                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                    ),

                    child: Column(
                      children: <Widget>[
                        const SizedBox(width: double.infinity),

                        Text(e, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),

      fixedFlag: true,

      firstEntries: _firstEntries,
      secondEntries: _secondEntries,
      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
    );
  }

  ///
  // ignore: always_specify_types
  List<Polygon> makeAreaPolygons() {
    // ignore: always_specify_types
    final List<Polygon<Object>> polygonList = <Polygon>[];

    for (final String element in appParamState.selectedMunicipalNameList) {
      if (getDataState.keepTokyoMunicipalMap[element] != null) {
        for (final List<List<List<double>>> element2 in getDataState.keepTokyoMunicipalMap[element]!.polygons) {
          final Polygon<Object>? polygon = getColorPaintPolygon(polygon: element2, color: Colors.redAccent);

          if (polygon != null) {
            polygonList.add(polygon);
          }
        }
      }
    }

    return polygonList;
  }

  ///
  void makeMunicipalTempleMarkerList() {
    municipalTempleMarkerList.clear();

    //-------------------------------------------------------------//
    final List<SpotDataModel> list = <SpotDataModel>[];

    for (final TempleLatLngModel element in getDataState.keepTempleLatLngList) {
      list.add(
        SpotDataModel(
          type: 'temple',
          name: element.temple,
          address: element.address,
          latitude: element.lat,
          longitude: element.lng,
          rank: element.rank,
        ),
      );
    }
    //-------------------------------------------------------------//

    final List<SpotDataModel> uniqueTemples = getUniqueTemples(list);

    final List<SpotDataModel> filteredTemples = uniqueTemples.where((SpotDataModel t) {
      return !widget.templeDataList.any((SpotDataModel w) => w.latitude == t.latitude && w.longitude == t.longitude);
    }).toList();

    for (final String element in appParamState.selectedMunicipalNameList) {
      if (getDataState.keepTokyoMunicipalMap[element] != null) {
        for (final SpotDataModel element2 in filteredTemples) {
          if (spotInMunicipality(
            element2.latitude.toDouble(),
            element2.longitude.toDouble(),
            getDataState.keepTokyoMunicipalMap[element]!,
          )) {
            municipalTempleMarkerList.add(
              Marker(
                point: LatLng(element2.latitude.toDouble(), element2.longitude.toDouble()),

                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 10,

                    backgroundColor: Colors.pinkAccent.withValues(alpha: 0.6),

                    child: Text(
                      element2.rank,
                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
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
        Positioned(
          top: 5,
          right: 5,
          child: Text(
            appParamState.selectedSpotDataModel!.rank,

            style: const TextStyle(fontSize: 60, color: Color(0xFFFBB6CE)),
          ),
        ),

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
