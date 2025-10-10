import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../const/const.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../main.dart';
import '../models/common/search_result_model.dart';
import '../models/common/spot_data_model.dart';
import '../models/municipal_model.dart';
import '../models/station_model.dart';
import '../models/temple_lat_lng_model.dart';
import '../models/temple_list_model.dart';
import '../models/temple_model.dart';
import '../models/temple_photo_model.dart';
import '../models/tokyo_train_model.dart';
import '../models/train_model.dart';
import '../utility/functions.dart';
import '../utility/utility.dart';
import 'components/city_town_temple_list_alert.dart';
import 'components/daily_temple_map_alert.dart';
import 'components/home_centered_visited_spot_map_alert.dart';
import 'parts/error_dialog.dart';
import 'parts/temple_dialog.dart';
import 'parts/temple_overlay.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    //---
    required this.templeList,

    //---
    required this.templeLatLngList,
    required this.templeLatLngMap,

    //---
    required this.stationMap,

    //---
    required this.tokyoMunicipalList,
    required this.tokyoMunicipalMap,

    //---
    required this.templePhotoMap,

    //---
    required this.templeListList,
    required this.templeListMap,

    //---
    required this.tokyoTrainList,
    required this.tokyoTrainMap,
    required this.tokyoStationTokyoTrainModelListMap,

    //---
    required this.trainList,

    //---
    required this.chibaMunicipalMap,
    required this.busInfoStringMap,
  });

  //---
  final List<TempleModel> templeList;

  //---
  final List<TempleLatLngModel> templeLatLngList;
  final Map<String, TempleLatLngModel> templeLatLngMap;

  //---
  final Map<String, StationModel> stationMap;

  //---
  final List<MunicipalModel> tokyoMunicipalList;
  final Map<String, MunicipalModel> tokyoMunicipalMap;

  //---
  final Map<String, List<TemplePhotoModel>> templePhotoMap;

  //---
  final Map<String, TempleListModel> templeListMap;
  final List<TempleListModel> templeListList;

  //---
  final List<TokyoTrainModel> tokyoTrainList;
  final Map<String, TokyoTrainModel> tokyoTrainMap;
  final Map<String, List<TokyoTrainModel>> tokyoStationTokyoTrainModelListMap;

  //---
  final List<TrainModel> trainList;

  //---
  final Map<String, MunicipalModel> chibaMunicipalMap;

  //---
  final Map<String, String> busInfoStringMap;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen> {
  final Map<int, GlobalKey> _yearAnchorKeys = <int, GlobalKey<State<StatefulWidget>>>{};

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _headerKey = GlobalKey();

  static const double _yearBarHeight = 56.0;

  TextEditingController searchWordEditingController = TextEditingController();

  List<SearchResultModel> searchResultModelList = <SearchResultModel>[];

  final List<OverlayEntry> _firstEntries = <OverlayEntry>[];
  final List<OverlayEntry> _secondEntries = <OverlayEntry>[];

  Utility utility = Utility();

  List<String> cityTownNameList = <String>[];

  ///
  @override
  void initState() {
    super.initState();

    cityTownNameList = cityTownNames.split('\n').where((String e) => e.trim().isNotEmpty).toList();

    searchResultModelList.clear();
  }

  ///
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  bool tokyoStationSettedFlag = false;

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
      //---
      appParamNotifier.setKeepTempleList(list: widget.templeList);

      //---
      appParamNotifier.setKeepTempleLatLngList(list: widget.templeLatLngList);
      appParamNotifier.setKeepTempleLatLngMap(map: widget.templeLatLngMap);

      //---
      appParamNotifier.setKeepStationMap(map: widget.stationMap);

      //---
      appParamNotifier.setKeepTokyoMunicipalList(list: widget.tokyoMunicipalList);
      appParamNotifier.setKeepTokyoMunicipalMap(map: widget.tokyoMunicipalMap);

      //---
      appParamNotifier.setKeepTemplePhotoMap(map: widget.templePhotoMap);

      //---
      appParamNotifier.setKeepTempleListMap(map: widget.templeListMap);
      appParamNotifier.setKeepTempleListList(list: widget.templeListList);

      //---
      appParamNotifier.setKeepTokyoTrainList(list: widget.tokyoTrainList);
      appParamNotifier.setKeepTokyoTrainMap(map: widget.tokyoTrainMap);
      appParamNotifier.setKeepTokyoStationTokyoTrainModelListMap(map: widget.tokyoStationTokyoTrainModelListMap);

      //---
      appParamNotifier.setKeepTrainList(list: widget.trainList);

      //---
      appParamNotifier.setKeepChibaMunicipalMap(map: widget.chibaMunicipalMap);

      if (!tokyoStationSettedFlag) {
        final List<StationModel> tokyoStationList = <StationModel>[];
        final Map<String, StationModel> tokyoStationMap = <String, StationModel>{};

        widget.stationMap.forEach((String key, StationModel value) {
          for (final MunicipalModel element in widget.tokyoMunicipalList) {
            if (spotInMunicipality(value.lat.toDouble(), value.lng.toDouble(), element)) {
              tokyoStationList.add(value);

              tokyoStationMap[value.stationName] = value;
            }
          }
        });

        // ignore: always_specify_types
        Future(() {
          appParamNotifier.setKeepTokyoStationList(list: tokyoStationList);
          appParamNotifier.setKeepTokyoStationMap(map: tokyoStationMap);
        });

        tokyoStationSettedFlag = true;
      }
    });

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        utility.getBackGround(),

        Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
            title: const Text('Temple List'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            bottom: displayHomeAppBar(),
            leading: IconButton(
              onPressed: () => context.findAncestorStateOfType<AppRootState>()?.restartApp(),
              icon: const Icon(Icons.refresh),
            ),
          ),

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
                    final TempleModel templeModel = byYear[y]![index];
                    final double screenW = MediaQuery.of(context).size.width;
                    final int targetPxW = max(1, (screenW * dpr).round());

                    //=======================================================

                    bool showSearchHitBorder = false;

                    if (appParamState.searchWord != '') {
                      final List<String> templeNameList = <String>[templeModel.temple];

                      if (templeModel.memo != '') {
                        templeNameList.addAll(templeModel.memo.split('、'));
                      }

                      final RegExp reg = RegExp(appParamState.searchWord);

                      for (final String element in templeNameList) {
                        if (reg.firstMatch(element) != null) {
                          showSearchHitBorder = true;
                        }
                      }
                    }

                    //=======================================================

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: showSearchHitBorder
                                      ? Colors.yellowAccent.withValues(alpha: 0.6)
                                      : Colors.transparent,
                                  width: 5,
                                ),
                              ),

                              child: AspectRatio(
                                aspectRatio: 3 / 2,
                                child: CachedNetworkImage(
                                  imageUrl: templeModel.thumbnail,
                                  memCacheWidth: targetPxW,
                                  fit: BoxFit.cover,
                                  placeholder: (BuildContext c, _) => const ColoredBox(color: Colors.black12),
                                  errorWidget: (BuildContext c, _, __) => const Icon(Icons.broken_image),
                                ),
                              ),
                            ),

                            displayTempleNameParts(templeModel: templeModel),

                            displayTempleInfoParts(templeModel: templeModel),

                            displayTempleRankParts(templeModel: templeModel),
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

          endDrawer: _dispDrawer(),
        ),
      ],
    );
  }

  ///
  PreferredSize displayHomeAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Column(children: <Widget>[displaySearchForm()]),
    );
  }

  ///
  Widget displaySearchForm() {
    if (appParamState.searchWord != '') {
      searchResultModelList.clear();

      for (final TempleModel element in widget.templeList) {
        final List<String> templeNameList = <String>[element.temple];

        if (element.memo != '') {
          templeNameList.addAll(element.memo.split('、'));
        }

        final RegExp reg = RegExp(appParamState.searchWord);

        for (final String element2 in templeNameList) {
          if (reg.firstMatch(element2) != null) {
            searchResultModelList.add(SearchResultModel(date: element.date.yyyymmdd, name: element2));
          }
        }
      }
    }

    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            searchWordEditingController.text = '';

            appParamNotifier.setSearchWord(word: '');

            searchResultModelList.clear();

            setState(() {});
          },
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        Expanded(
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: searchWordEditingController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
            onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
            onChanged: (String value) {},
          ),
        ),
        IconButton(
          onPressed: () {
            appParamNotifier.setSearchWord(word: searchWordEditingController.text);

            setState(() {});
          },

          icon: const Icon(Icons.search, color: Colors.white),
        ),

        IconButton(
          onPressed: (searchResultModelList.isNotEmpty) ? () => callFirstBox() : null,

          icon: Icon(
            Icons.pages,
            color: (searchResultModelList.isNotEmpty) ? Colors.yellowAccent : Colors.white.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispDrawer() {
    return Drawer(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),

              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: GestureDetector(
                  onTap: () {
                    TempleDialog(context: context, widget: const CityTownTempleListAlert(), clearBarrierColor: true);
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.toriiGate),
                      SizedBox(width: 20),
                      Text('市区町村別神社リスト', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: GestureDetector(
                  onTap: () {
                    final List<double> allLatList = <double>[];
                    final List<double> allLngList = <double>[];

                    /// 東京
                    for (final String element in cityTownNameList) {
                      final Map<String, List<double>> municipalLatLng = getMunicipalLatLng(
                        polygons: appParamState.keepTokyoMunicipalMap[element]?.polygons,
                      );

                      allLatList.addAll(municipalLatLng['latList'] ?? <double>[]);
                      allLngList.addAll(municipalLatLng['lngList'] ?? <double>[]);
                    }

                    /// 東京

                    /// 千葉
                    widget.chibaMunicipalMap.forEach((String key, MunicipalModel value) {
                      final Map<String, List<double>> municipalLatLng = getMunicipalLatLng(polygons: value.polygons);

                      allLatList.addAll(municipalLatLng['latList'] ?? <double>[]);
                      allLngList.addAll(municipalLatLng['lngList'] ?? <double>[]);
                    });

                    /// 千葉

                    TempleDialog(
                      context: context,
                      widget: HomeCenteredVisitedSpotMapAlert(latList: allLatList, lngList: allLngList),
                      clearBarrierColor: true,
                    );
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.toriiGate),
                      SizedBox(width: 20),
                      Text('参拝神社リスト', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 10),

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

                        final List<SpotDataModel> templeDataList = <SpotDataModel>[];

                        final List<String> templeMunicipalList = <String>[];

                        if (templeModel.startPoint != '') {
                          switch (templeModel.startPoint) {
                            case '自宅':
                              templeDataList.add(
                                SpotDataModel(
                                  type: '',
                                  name: templeModel.startPoint,
                                  address: '千葉県船橋市二子町492-25-101',
                                  latitude: funabashiLat.toString(),
                                  longitude: funabashiLng.toString(),
                                  mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'S',
                                ),
                              );

                            case '実家':
                              templeDataList.add(
                                SpotDataModel(
                                  type: '',
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
                                  SpotDataModel(
                                    type: 'station',
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
                              SpotDataModel(
                                type: 'temple',
                                name: templeLatLngModel.temple,
                                address: templeLatLngModel.address,
                                latitude: templeLatLngModel.lat,
                                longitude: templeLatLngModel.lng,
                                mark: i.toString(),
                                rank: templeLatLngModel.rank,
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
                                SpotDataModel(
                                  type: '',
                                  name: templeModel.endPoint,
                                  address: '千葉県船橋市二子町492-25-101',
                                  latitude: funabashiLat.toString(),
                                  longitude: funabashiLng.toString(),
                                  mark: (templeModel.startPoint == templeModel.endPoint) ? 'S/E' : 'E',
                                ),
                              );

                            case '実家':
                              templeDataList.add(
                                SpotDataModel(
                                  type: '',
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
                                  SpotDataModel(
                                    type: 'station',
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

                        templeMunicipalList.sort();

                        appParamNotifier.clearSelectedMunicipalNameList();

                        TempleDialog(
                          context: context,
                          widget: DailyTempleMapAlert(
                            date: templeModel.date.yyyymmdd,
                            templeDataList: templeDataList,
                            templeMunicipalList: templeMunicipalList,
                          ),

                          clearBarrierColor: true,

                          executeFunctionWhenDialogClose: true,
                          ref: ref,
                          from: 'DailyTempleMapAlert',
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
    for (final MunicipalModel m in widget.tokyoMunicipalList) {
      if (spotInMunicipality(lat, lng, m)) {
        return m.name;
      }
    }

    return null;
  }

  ///
  void callFirstBox() {
    appParamNotifier.setFirstOverlayParams(firstEntries: _firstEntries);

    addFirstOverlay(
      context: context,
      setStateCallback: setState,
      width: context.screenSize.width * 0.6,
      height: context.screenSize.height * 0.5,
      color: Colors.blueGrey.withOpacity(0.3),
      initialPosition: Offset(10, context.screenSize.height * 0.25),

      widget: SingleChildScrollView(
        child: Column(
          children: searchResultModelList.map((SearchResultModel e) {
            return DefaultTextStyle(
              style: const TextStyle(fontSize: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: Row(
                  children: <Widget>[
                    SizedBox(width: 60, child: Text(e.date)),

                    const SizedBox(width: 10),

                    Expanded(child: Text(e.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
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
