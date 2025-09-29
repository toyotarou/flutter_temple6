import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const/const.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../models/common/temple_data.dart';
import '../models/station_model.dart';
import '../models/temple_lat_lng_model.dart';
import '../models/temple_model.dart';
import '../models/tokyo_municipal_model.dart';
import 'components/daily_temple_map_alert.dart';
import 'parts/error_dialog.dart';
import 'parts/temple_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.templeList,
    required this.templeLatLngMap,
    required this.stationMap,
    required this.tokyoMunicipalList,
  });

  final List<TempleModel> templeList;
  final Map<String, TempleLatLngModel> templeLatLngMap;
  final Map<String, StationModel> stationMap;
  final List<TokyoMunicipalModel> tokyoMunicipalList;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final Map<int, GlobalKey> _yearAnchorKeys = <int, GlobalKey<State<StatefulWidget>>>{};

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _headerKey = GlobalKey();

  static const double _yearBarHeight = 56.0;

  ///
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (widget.templeList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Map<int, List<TempleModel>> byYear = <int, List<TempleModel>>{};

    for (final TempleModel e in widget.templeList) {
      byYear.putIfAbsent(e.date.year, () => <TempleModel>[]).add(e);
    }

    final List<int> years = byYear.keys.toList()..sort();

    for (final int y in years) {
      _yearAnchorKeys.putIfAbsent(y, () => GlobalKey());
    }

    final double dpr = MediaQuery.of(context).devicePixelRatio;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appParamNotifier.setKeepTempleList(list: widget.templeList);
      appParamNotifier.setKeepTempleLatLngMap(map: widget.templeLatLngMap);
      appParamNotifier.setKeepStationMap(map: widget.stationMap);
      appParamNotifier.setKeepTokyoMunicipalList(list: widget.tokyoMunicipalList);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('TEMPLE LIST'), centerTitle: true),
      body: CustomScrollView(
        controller: _scrollController,
        cacheExtent: 400,
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: _YearBarDelegate(
              minExtentHeight: _yearBarHeight,
              maxExtentHeight: _yearBarHeight,
              child: Container(
                key: _headerKey,

                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: years.length,
                  itemBuilder: (_, int i) {
                    final int y = years[i];
                    return ChoiceChip(label: Text('$y'), selected: false, onSelected: (_) => _jumpToYear(y));
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            ),
          ),

          for (final int y in years) ...<Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(key: _yearAnchorKeys[y], height: 0),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text('$y 年', style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
            ),

            SliverList.builder(
              itemCount: byYear[y]!.length,
              itemBuilder: (BuildContext context, int index) {
                final TempleModel item = byYear[y]![index];
                final double screenW = MediaQuery.of(context).size.width;
                final int targetPxW = max(1, (screenW * dpr).round());

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 3 / 2,
                          child: CachedNetworkImage(
                            imageUrl: item.thumbnail,
                            memCacheWidth: targetPxW,
                            fit: BoxFit.cover,
                            placeholder: (BuildContext c, _) => const ColoredBox(color: Colors.black12),
                            errorWidget: (BuildContext c, _, __) => const Icon(Icons.broken_image),
                          ),
                        ),

                        displayTempleNameParts(templeModel: item),

                        displayTempleInfoParts(templeModel: item),

                        displayTempleRankParts(templeModel: item),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  ///
  Widget displayTempleNameParts({required TempleModel templeModel}) {
    return Positioned(
      top: 5,
      right: 2,
      left: 2,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 100, child: Text(templeModel.date.yyyymmdd)),

                  Expanded(child: Text(templeModel.temple, maxLines: 1, overflow: TextOverflow.ellipsis)),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.stationMap.isEmpty || widget.templeLatLngMap.isEmpty) {
                          // ignore: always_specify_types
                          Future.delayed(
                            Duration.zero,
                            () => error_dialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              title: 'エラー',
                              content: '表示に必要なデータが作成されていません。',
                            ),
                          );

                          return;
                        }

                        ///////////////////////////////////////////////////////////////////////////

                        final List<TempleData> templeDataList = <TempleData>[];

                        final List<String> templeMunicipalList = <String>[];

                        if (templeModel.startPoint != '') {
                          switch (templeModel.startPoint) {
                            case '自宅':
                              templeDataList.add(
                                TempleData(
                                  name: templeModel.startPoint,
                                  address: '千葉県船橋市二子町492-25-101',
                                  latitude: funabashiLat.toString(),
                                  longitude: funabashiLng.toString(),
                                  mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'S',
                                ),
                              );

                            case '実家':
                              templeDataList.add(
                                TempleData(
                                  name: templeModel.startPoint,
                                  address: '東京都杉並区善福寺4-22-11',
                                  latitude: zenpukujiLat.toString(),
                                  longitude: zenpukujiLng.toString(),
                                  mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'S',
                                ),
                              );

                            default:
                              final StationModel? stationModel = widget.stationMap[templeModel.startPoint];

                              if (stationModel != null) {
                                templeDataList.add(
                                  TempleData(
                                    name: stationModel.stationName,
                                    address: stationModel.address,
                                    latitude: stationModel.lat,
                                    longitude: stationModel.lng,
                                    mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'S',
                                  ),
                                );
                              }
                          }
                        }

                        //////////////////////////
                        final List<String> templeNameList = <String>[templeModel.temple];

                        if (templeModel.memo != '') {
                          templeNameList.addAll(templeModel.memo.split('、'));
                        }

                        for (int i = 0; i < templeNameList.length; i++) {
                          final TempleLatLngModel? templeLatLngModel = widget.templeLatLngMap[templeNameList[i]];

                          if (templeLatLngModel != null) {
                            templeDataList.add(
                              TempleData(
                                name: templeLatLngModel.temple,
                                address: templeLatLngModel.address,
                                latitude: templeLatLngModel.lat,
                                longitude: templeLatLngModel.lng,
                                mark: i.toString(),
                              ),
                            );

                            final String? name = findMunicipalityForPoint(
                              templeLatLngModel.lat.toDouble(),
                              templeLatLngModel.lng.toDouble(),
                            );

                            if (name != null && !templeMunicipalList.contains(name)) {
                              templeMunicipalList.add(name);
                            }
                          }
                        }

                        //////////////////////////

                        if (templeModel.endPoint != '') {
                          switch (templeModel.endPoint) {
                            case '自宅':
                              templeDataList.add(
                                TempleData(
                                  name: templeModel.endPoint,
                                  address: '千葉県船橋市二子町492-25-101',
                                  latitude: funabashiLat.toString(),
                                  longitude: funabashiLng.toString(),
                                  mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'E',
                                ),
                              );

                            case '実家':
                              templeDataList.add(
                                TempleData(
                                  name: templeModel.endPoint,
                                  address: '東京都杉並区善福寺4-22-11',
                                  latitude: zenpukujiLat.toString(),
                                  longitude: zenpukujiLng.toString(),
                                  mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'E',
                                ),
                              );

                            default:
                              final StationModel? stationModel = widget.stationMap[templeModel.endPoint];

                              if (stationModel != null) {
                                templeDataList.add(
                                  TempleData(
                                    name: stationModel.stationName,
                                    address: stationModel.address,
                                    latitude: stationModel.lat,
                                    longitude: stationModel.lng,
                                    mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'E',
                                  ),
                                );
                              }
                          }
                        }

                        ///////////////////////////////////////////////////////////////////////////

                        TempleDialog(
                          context: context,
                          widget: DailyTempleMapAlert(
                            date: templeModel.date.yyyymmdd,
                            templeDataList: templeDataList,
                            templeMunicipalList: templeMunicipalList,
                          ),
                        );
                      },

                      child: Icon(Icons.info, color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayTempleInfoParts({required TempleModel templeModel}) {
    return Positioned(
      bottom: 15,

      right: 2,
      left: 2,

      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(templeModel.address),
                if (templeModel.station.isNotEmpty) ...<Widget>[const SizedBox(height: 2), Text(templeModel.station)],
                if (templeModel.gohonzon.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(templeModel.gohonzon, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                if (templeModel.memo.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 6),
                  Text('With. ${templeModel.memo}', maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _jumpToYear(int year) async {
    final BuildContext? ctx = _yearAnchorKeys[year]?.currentContext;
    if (ctx == null) {
      return;
    }

    final RenderObject? renderObj = ctx.findRenderObject();
    if (renderObj == null) {
      return;
    }

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObj);

    final double baseOffset = viewport.getOffsetToReveal(renderObj, 0.0).offset;

    final double headerHeight = _headerKey.currentContext?.size?.height ?? _yearBarHeight;

    double target = baseOffset - headerHeight;

    target = target.clamp(_scrollController.position.minScrollExtent, _scrollController.position.maxScrollExtent);

    await _scrollController.animateTo(target, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);

    // ignore: inference_failure_on_instance_creation, always_specify_types
    await Future.delayed(const Duration(milliseconds: 16));
    // ignore: use_build_context_synchronously
    final RenderBox? box = ctx.findRenderObject() as RenderBox?;
    final RenderBox? vpBox = _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && vpBox != null) {
      final Offset topLeft = box.localToGlobal(Offset.zero);
      final double headerBottomY = vpBox.localToGlobal(Offset.zero).dy + headerHeight;
      final double delta = topLeft.dy - headerBottomY;

      if (delta.abs() > 0.5) {
        final double tweak = (_scrollController.offset + delta).clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        );
        await _scrollController.animateTo(tweak, duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
      }
    }
  }

  ///
  Widget displayTempleRankParts({required TempleModel templeModel}) {
    final List<Widget> list = <Widget>[];

    final List<String> templeNameList = <String>[templeModel.temple];

    if (templeModel.memo != '') {
      templeNameList.addAll(templeModel.memo.split('、'));
    }

    for (int i = 0; i < templeNameList.length; i++) {
      final TempleLatLngModel? templeLatLngModel = widget.templeLatLngMap[templeNameList[i]];

      if (templeLatLngModel != null) {
        list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CircleAvatar(
              backgroundColor: Colors.pinkAccent.withOpacity(0.5),
              radius: 10,
              child: Text(templeLatLngModel.rank, style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
        );
      }
    }

    return Positioned(
      bottom: 3,
      right: 3,
      left: 3,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: list),
      ),
    );
  }

  ///
  String? findMunicipalityForPoint(double lat, double lng) {
    for (final TokyoMunicipalModel m in widget.tokyoMunicipalList) {
      if (pointInMunicipality(lat, lng, m)) {
        return m.name;
      }
    }

    return null;
  }

  final double _eps = 1e-12;

  ///
  bool pointInMunicipality(double lat, double lng, TokyoMunicipalModel muni) {
    for (final List<List<List<double>>> polygon in muni.polygons) {
      if (polygon.isEmpty) {
        continue;
      }

      final List<List<double>> outerRing = polygon.first;

      if (!pointInRingOrOnEdge(lat, lng, outerRing)) {
        continue;
      }

      bool inAnyHole = false;

      for (int i = 1; i < polygon.length; i++) {
        final List<List<double>> holeRing = polygon[i];

        if (pointInRingOrOnEdge(lat, lng, holeRing)) {
          inAnyHole = true;

          break;
        }
      }

      if (!inAnyHole) {
        return true;
      }
    }

    return false;
  }

  ///
  bool pointInRingOrOnEdge(double lat, double lng, List<List<double>> ring) {
    for (int i = 0; i < ring.length; i++) {
      final List<double> a = ring[i];

      final List<double> b = ring[(i + 1) % ring.length];

      final double aLng = a[0], aLat = a[1];

      final double bLng = b[0], bLat = b[1];

      if (_pointOnSegment(lat, lng, aLat, aLng, bLat, bLng)) {
        return true;
      }
    }

    return _rayCasting(lat, lng, ring);
  }

  ///
  bool _rayCasting(double lat, double lng, List<List<double>> ring) {
    bool inside = false;

    for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final double xiLat = ring[i][1], xiLng = ring[i][0];

      final double xjLat = ring[j][1], xjLng = ring[j][0];

      final bool crossesVertically = (xiLat > lat) != (xjLat > lat);

      if (!crossesVertically) {
        continue;
      }

      final double t = (lat - xiLat) / (xjLat - xiLat);

      final double intersectionLng = xiLng + t * (xjLng - xiLng);

      if (intersectionLng > lng) {
        inside = !inside;
      }
    }

    return inside;
  }

  ///
  bool _pointOnSegment(double pLat, double pLng, double aLat, double aLng, double bLat, double bLng) {
    final double minLat = (aLat < bLat) ? aLat : bLat;

    final double maxLat = (aLat > bLat) ? aLat : bLat;

    final double minLng = (aLng < bLng) ? aLng : bLng;

    final double maxLng = (aLng > bLng) ? aLng : bLng;

    final bool withinBox =
        (pLat >= minLat - _eps) && (pLat <= maxLat + _eps) && (pLng >= minLng - _eps) && (pLng <= maxLng + _eps);

    if (!withinBox) {
      return false;
    }

    final double vLat = bLat - aLat;

    final double vLng = bLng - aLng;

    final double wLat = pLat - aLat;

    final double wLng = pLng - aLng;

    final double cross = (vLng * wLat) - (vLat * wLng);

    if (cross.abs() > 1e-10) {
      return false;
    }

    final double vLen2 = vLat * vLat + vLng * vLng;

    if (vLen2 < 1e-20) {
      final double d2 = wLat * wLat + wLng * wLng;

      return d2 < 1e-20;
    }

    final double t = (wLat * vLat + wLng * vLng) / vLen2;

    return t >= -_eps && t <= 1 + _eps;
  }
}

///
class _YearBarDelegate extends SliverPersistentHeaderDelegate {
  _YearBarDelegate({required this.minExtentHeight, required this.maxExtentHeight, required this.child});

  final double minExtentHeight;
  final double maxExtentHeight;
  final Widget child;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant _YearBarDelegate old) =>
      old.child != child || old.minExtentHeight != minExtentHeight || old.maxExtentHeight != maxExtentHeight;
}
