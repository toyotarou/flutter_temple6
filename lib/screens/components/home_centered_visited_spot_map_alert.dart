import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../utility/tile_provider.dart';

class HomeCenteredVisitedSpotMapAlert extends ConsumerStatefulWidget {
  const HomeCenteredVisitedSpotMapAlert({super.key, required this.latList, required this.lngList});

  final List<double> latList;
  final List<double> lngList;

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

                // if (widget.selectArealPolygons != null) ...<Widget>[
                //   // ignore: always_specify_types
                //   PolygonLayer(polygons: makeAreaPolygons()),
                // ],
                //
                // if (neighborsTokyoMunicipalModelList.isNotEmpty) ...<Widget>[
                //   // ignore: always_specify_types
                //   PolygonLayer(polygons: getNeighborArea()),
                // ],
                //
                // if (appParamState.selectedTrainName != '' &&
                //     appParamState.keepTokyoTrainMap[appParamState.selectedTrainName] != null &&
                //     appParamState.keepTokyoTrainMap[appParamState.selectedTrainName]!.station.isNotEmpty) ...<Widget>[
                //   // ignore: always_specify_types
                //   PolylineLayer(polylines: makeTrainPolyline()),
                // ],

                // if (appParamState.addRouteSpotDataModelList.isNotEmpty) ...<Widget>[
                //   // ignore: always_specify_types
                //   PolylineLayer(polylines: makeAddSpotsPolyline()),
                // ],
                //
                // if (selectedSpotsMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: selectedSpotsMarkerList)],
                //
                // if (visitedTemplesMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: visitedTemplesMarkerList)],
                //
                // if (noReachTemplesMarkerList.isNotEmpty) ...<Widget>[MarkerLayer(markers: noReachTemplesMarkerList)],
                //
                // if (tokyoStationMarkerList.isNotEmpty && displayStations) ...<Widget>[
                //   MarkerLayer(markers: tokyoStationMarkerList),
                // ],
                //
                // if (neighborTemplesMarkerList.isNotEmpty && displayNeighborTemples) ...<Widget>[
                //   MarkerLayer(markers: neighborTemplesMarkerList),
                // ],
              ],
            ),

            /*
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
*/
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
}
