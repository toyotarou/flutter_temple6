import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../utility/tile_provider.dart';
import '../parts/expandable_box.dart';
import '../parts/temple_overlay.dart';

class DailyTempleMapAlert extends ConsumerStatefulWidget {
  const DailyTempleMapAlert({
    super.key,
    required this.date,
    required this.templeDataList,
    required this.templeMunicipalList,
  });

  final String date;
  final List<TempleData> templeDataList;
  final List<String> templeMunicipalList;

  @override
  ConsumerState<DailyTempleMapAlert> createState() => _DailyTempleMapAlertState();
}

class _DailyTempleMapAlertState extends ConsumerState<DailyTempleMapAlert> with ControllersMixin<DailyTempleMapAlert> {
  bool isLoading = false;

  List<double> latList = <double>[];
  List<double> lngList = <double>[];

  double minLat = 0.0;
  double maxLat = 0.0;
  double minLng = 0.0;
  double maxLng = 0.0;

  final MapController mapController = MapController();

  double? currentZoom;

  double currentZoomEightTeen = 18;

  List<Marker> markerList = <Marker>[];

  List<LatLng> latLngList = <LatLng>[];

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
    if (widget.templeDataList.isNotEmpty) {
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

      callFirstBox();
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();

    makeMarker();

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

                // ignore: always_specify_types
                PolylineLayer(polylines: makeTransportationPolyline()),

                MarkerLayer(markers: markerList),
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
                      child: GestureDetector(
                        onTap: () {
                          setDefaultBoundsMap();
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0x66000000),

                          child: Icon(Icons.filter_center_focus, size: 18, color: Colors.white),
                        ),
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
                  child: Text(
                    widget.templeDataList[i].mark,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      );
    }
  }

  ///
  void makeMinMaxLatLng() {
    latList.clear();
    lngList.clear();

    latLngList.clear();

    for (int i = 0; i < widget.templeDataList.length; i++) {
      latList.add(widget.templeDataList[i].latitude.toDouble());
      lngList.add(widget.templeDataList[i].longitude.toDouble());

      latLngList.add(
        LatLng(widget.templeDataList[i].latitude.toDouble(), widget.templeDataList[i].longitude.toDouble()),
      );
    }

    if (latList.isNotEmpty && lngList.isNotEmpty) {
      minLat = latList.reduce(min);
      maxLat = latList.reduce(max);
      minLng = lngList.reduce(min);
      maxLng = lngList.reduce(max);
    }
  }

  ///
  Widget displayDailyTempleList() {
    final List<Widget> list = <Widget>[];

    for (final TempleData element in widget.templeDataList) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),

          padding: const EdgeInsets.symmetric(vertical: 5),

          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.pinkAccent.withValues(alpha: 0.5),

                  radius: 15,
                  child: Text(
                    (int.tryParse(element.mark) != null) ? (element.mark.toInt() + 1).toString() : element.mark,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(element.name),

                      Text('${element.latitude} / ${element.longitude}', style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ),

                if (int.tryParse(element.mark) != null) ...<Widget>[
                  GestureDetector(
                    onTap: () {},
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
      Polyline(points: latLngList, color: Colors.redAccent.withValues(alpha: 0.5), strokeWidth: 5),
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
          children: <Widget>[
            const SizedBox(width: double.infinity),

            Container(
              margin: const EdgeInsets.all(5),

              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.5))),

              child: const Column(
                children: <Widget>[
                  SizedBox(width: double.infinity),

                  Text('CLEAR', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),

            Column(
              children: widget.templeMunicipalList.map((String e) {
                return Container(
                  margin: const EdgeInsets.all(5),

                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                  decoration: BoxDecoration(border: Border.all(color: Colors.white.withValues(alpha: 0.5))),

                  child: Column(
                    children: <Widget>[
                      const SizedBox(width: double.infinity),

                      Text(e, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),

      fixedFlag: true,

      firstEntries: _firstEntries,
      secondEntries: _secondEntries,
      onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
    );
  }
}
