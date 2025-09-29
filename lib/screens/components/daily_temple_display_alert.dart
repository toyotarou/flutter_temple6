import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../utility/tile_provider.dart';
import '../parts/expandable_box.dart';

class DailyTempleDisplayAlert extends ConsumerStatefulWidget {
  const DailyTempleDisplayAlert({super.key, required this.date, required this.templeDataList});

  final String date;
  final List<TempleData> templeDataList;

  @override
  ConsumerState<DailyTempleDisplayAlert> createState() => _DailyTempleDisplayAlertState();
}

class _DailyTempleDisplayAlertState extends ConsumerState<DailyTempleDisplayAlert>
    with ControllersMixin<DailyTempleDisplayAlert> {
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
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMinMaxLatLng();

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

            Column(
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
                    children: <Widget>[
                      const SizedBox(height: 20),

                      Expanded(child: displayDailyTempleList()),
                    ],
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
    latList.clear();
    lngList.clear();

    for (final TempleData element in widget.templeDataList) {
      latList.add(element.latitude.toDouble());
      lngList.add(element.longitude.toDouble());
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

          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.pinkAccent.withValues(alpha: 0.5),

                radius: 15,
                child: Text(element.mark, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),

              Text(element.name),
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
}
