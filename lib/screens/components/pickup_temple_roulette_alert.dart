import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/municipal_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../utility/map_functions.dart';
import '../parts/error_dialog.dart';
import '../parts/temple_dialog.dart';
import '../parts/temple_pickup_list_card.dart';
import 'city_town_temple_map_alert.dart';

class PickupTempleRouletteAlert extends ConsumerStatefulWidget {
  const PickupTempleRouletteAlert({super.key, required this.getDailySpotDataInfoMap});

  final Map<String, List<SpotDataModel>> getDailySpotDataInfoMap;

  @override
  ConsumerState<PickupTempleRouletteAlert> createState() => _PickupTempleRouletteAlertState();
}

class _PickupTempleRouletteAlertState extends ConsumerState<PickupTempleRouletteAlert>
    with ControllersMixin<PickupTempleRouletteAlert> {
  Map<String, List<SpotDataModel>> templeRankMap = <String, List<SpotDataModel>>{};

  List<SpotDataModel> rouletteTempleList = <SpotDataModel>[];

  int _cursorIndex = 0;

  int? _selectedIndex;

  bool _spinning = false;

  final Random _random = Random();

  final ScrollController _scrollCtrl = ScrollController();

  static const double kItemExtent = 48.0;

  static const EdgeInsets kHInset = EdgeInsets.symmetric(horizontal: 8);

  int listItemNum = 0;

  Map<String, List<SpotDataModel>> cityTownMunicipalSpotDataListMap = <String, List<SpotDataModel>>{};

  Map<String, List<SpotDataModel>> visitedMunicipalSpotDataListMap = <String, List<SpotDataModel>>{};

  Map<String, List<SpotDataModel>> noReachMunicipalSpotDataListMap = <String, List<SpotDataModel>>{};

  List<SpotDataModel> allNoReachSpotDataList = <SpotDataModel>[];

  Map<String, String> visitedTempleNameRankMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    for (final String element in rankList) {
      widget.getDailySpotDataInfoMap.forEach((String key, List<SpotDataModel> value) {
        for (final SpotDataModel element2 in value) {
          if (element2.type == 'temple') {
            if (element == element2.rank) {
              (templeRankMap[element] ??= <SpotDataModel>[]).add(element2);
            }

            visitedTempleNameRankMap[element2.name] = element2.rank;
          }
        }
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeMunicipalSpotDataListMap();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('神社ピックアップ'), SizedBox.shrink()],
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            displayTempleRankList(),

            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _spinning
                      ? null
                      : () {
                          if (rouletteTempleList.isEmpty) {
                            // ignore: always_specify_types
                            Future.delayed(
                              Duration.zero,
                              () => error_dialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                title: 'エラー',
                                content: 'リストが作成されていません。',
                              ),
                            );

                            return;
                          }

                          _shuffleList();
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('shuffle'),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _spinning
                        ? null
                        : () {
                            if (rouletteTempleList.isEmpty) {
                              // ignore: always_specify_types
                              Future.delayed(
                                Duration.zero,
                                () => error_dialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  title: 'エラー',
                                  content: 'リストが作成されていません。',
                                ),
                              );

                              return;
                            }

                            _startRoulette();
                          },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: Text(_spinning ? 'now' : 'start'),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: _spinning
                      ? null
                      : () {
                          if (_selectedIndex == null) {
                            // ignore: always_specify_types
                            Future.delayed(
                              Duration.zero,
                              () => error_dialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                title: 'エラー',
                                content: 'ルーレットを回してください。',
                              ),
                            );

                            return;
                          }

                          final SpotDataModel spotDataModel = rouletteTempleList[_selectedIndex!];

                          MunicipalModel? municipalModel;

                          for (int i = 0; i < getDataState.keepTokyoMunicipalList.length; i++) {
                            if (spotInMunicipality(
                              spotDataModel.latitude.toDouble(),
                              spotDataModel.longitude.toDouble(),
                              getDataState.keepTokyoMunicipalList[i],
                            )) {
                              municipalModel = getDataState.keepTokyoMunicipalList[i];
                              break;
                            }
                          }

                          final List<List<List<List<double>>>>? polygons = municipalModel?.polygons;

                          final Map<String, List<double>> municipalLatLng = getMunicipalLatLng(polygons: polygons);

                          appParamNotifier.clearSelectedRankList();

                          TempleDialog(
                            context: context,

                            widget: CityTownTempleMapAlert(
                              cityTownName: municipalModel?.name ?? '',

                              selectedSpotDataModel: spotDataModel,

                              latList: municipalLatLng['latList'] ?? <double>[],
                              lngList: municipalLatLng['lngList'] ?? <double>[],
                              selectArealPolygons: municipalModel?.polygons,
                              visitedMunicipalSpotDataListMap: visitedMunicipalSpotDataListMap,
                              noReachMunicipalSpotDataListMap: noReachMunicipalSpotDataListMap,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('map'),
                ),
              ],
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 2),

            Expanded(child: displayRankedTempleList()),
          ],
        ),
      ),
    );
  }

  ///
  void makeMunicipalSpotDataListMap() {
    cityTownMunicipalSpotDataListMap.clear();
    visitedMunicipalSpotDataListMap.clear();
    noReachMunicipalSpotDataListMap.clear();

    allNoReachSpotDataList.clear();

    final List<String> visitedTemples = getDataState.keepTempleLatLngList
        .map((TempleLatLngModel e) => e.temple)
        .toList();

    getDataState.keepTokyoMunicipalMap.forEach((String key, MunicipalModel value) {
      for (final TempleListModel element in getDataState.keepTempleListList) {
        if (spotInMunicipality(element.lat.toDouble(), element.lng.toDouble(), value)) {
          (cityTownMunicipalSpotDataListMap[key] ??= <SpotDataModel>[]).add(
            SpotDataModel(
              type: 'temple',
              name: element.name,
              address: element.address,
              latitude: element.lat,
              longitude: element.lng,
            ),
          );

          if (visitedTemples.contains(element.name)) {
            (visitedMunicipalSpotDataListMap[key] ??= <SpotDataModel>[]).add(
              SpotDataModel(
                type: 'temple',
                mark: element.id.toString(),

                name: element.name,
                address: element.address,
                latitude: element.lat,
                longitude: element.lng,
                rank: visitedTempleNameRankMap[element.name] ?? '',

                ////////////////
              ),
            );
          } else {
            (noReachMunicipalSpotDataListMap[key] ??= <SpotDataModel>[]).add(
              SpotDataModel(
                type: 'temple',
                mark: element.id.toString(),
                name: element.name,
                address: element.address,
                latitude: element.lat,
                longitude: element.lng,
              ),
            );

            allNoReachSpotDataList.add(
              SpotDataModel(
                type: 'temple',
                mark: element.id.toString(),
                name: element.name,
                address: element.address,
                latitude: element.lat,
                longitude: element.lng,
              ),
            );
          }
        }
      }
    });
  }

  ///
  Widget displayTempleRankList() {
    return SizedBox(
      height: 60,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 20,
            child: Transform(
              transform: Matrix4.diagonal3Values(1.0, 3.0, 1.0),
              child: Text(
                listItemNum.toString(),
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: rankList.map((String e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          appParamNotifier.setSelectedRankList(rank: e);

                          _rebuildList();
                        },
                        child: CircleAvatar(
                          backgroundColor: (appParamState.selectedRankList.contains(e))
                              ? Colors.yellowAccent.withValues(alpha: 0.3)
                              : Colors.black,
                          child: Text(e, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget displayRankedTempleList() {
    return ListView.builder(
      controller: _scrollCtrl,
      itemExtent: kItemExtent,
      itemCount: rouletteTempleList.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (BuildContext context, int index) {
        final bool isCursor = index == _cursorIndex;
        final bool isSelected = index == _selectedIndex;

        final Color borderColor = isSelected
            ? Colors.yellowAccent.withValues(alpha: 0.6)
            : (isCursor ? Colors.redAccent.withValues(alpha: 0.6) : Colors.blueGrey.withValues(alpha: 0.6));

        final Color? tileColor = isSelected
            ? Colors.yellowAccent.withValues(alpha: 0.3)
            : (isCursor ? Colors.black.withValues(alpha: 0.3) : null);

        return Padding(
          padding: kHInset.copyWith(top: 2, bottom: 2),
          child: ListCard(
            isSelected: isSelected,
            child: Container(
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1.5, color: borderColor),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 40,
                    child: (rouletteTempleList[index].mark.toInt() == 0)
                        ? const SizedBox.shrink()
                        : Transform(
                            transform: Matrix4.diagonal3Values(1.0, 3.0, 1.0),
                            child: Text(
                              rouletteTempleList[index].mark.padLeft(3, '0'),
                              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.4)),
                            ),
                          ),
                  ),

                  ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      rouletteTempleList[index].name,
                      style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                    ),
                    trailing: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///
  Future<void> _startRoulette() async {
    if (_spinning) {
      return;
    }

    setState(() {
      _spinning = true;
      _selectedIndex = null;
    });

    final int itemCount = rouletteTempleList.length;

    final int normalDelayMs = 40 + _random.nextInt(20);

    final int normalSteps = 40 + _random.nextInt(60);

    for (int i = 0; i < normalSteps; i++) {
      if (!mounted) {
        return;
      }
      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(Duration(milliseconds: normalDelayMs));

      setState(() => _cursorIndex = (_cursorIndex + 1) % itemCount);

      await _scrollToCursor(animMs: (normalDelayMs * 0.8).clamp(30, 120).toInt());
    }

    int delayMs = (normalDelayMs * 2.0).clamp(100, 160).toInt();

    const int decelSteps = 6;

    const double decelGrow = 1.35;

    for (int i = 0; i < decelSteps; i++) {
      if (!mounted) {
        return;
      }

      // ignore: inference_failure_on_instance_creation, always_specify_types
      await Future.delayed(Duration(milliseconds: delayMs));

      setState(() => _cursorIndex = (_cursorIndex + 1) % itemCount);

      await _scrollToCursor(animMs: (delayMs * 0.9).clamp(70, 240).toInt());

      delayMs = (delayMs * decelGrow).round().clamp(100, 600);
    }

    setState(() {
      _selectedIndex = _cursorIndex;

      _spinning = false;
    });
  }

  ///
  Future<void> _scrollToCursor({int animMs = 120}) async {
    if (!_scrollCtrl.hasClients) {
      return;
    }

    final ScrollPosition position = _scrollCtrl.position;

    final double viewTop = position.pixels;

    final double viewBottom = viewTop + position.viewportDimension;

    final double itemTop = _cursorIndex * kItemExtent;

    final double itemBottom = itemTop + kItemExtent;

    double? target;
    const double margin = 4;

    if (itemTop < viewTop) {
      target = (itemTop - margin).clamp(0, position.maxScrollExtent);
    } else if (itemBottom > viewBottom) {
      target = (itemBottom - position.viewportDimension + margin).clamp(0, position.maxScrollExtent);
    }

    if (target != null) {
      await _scrollCtrl.animateTo(
        target,
        duration: Duration(milliseconds: animMs),
        curve: Curves.easeOutCubic,
      );
    }
  }

  ///
  void _shuffleList() {
    if (_spinning) {
      return;
    }

    setState(() {
      rouletteTempleList.shuffle(_random);

      _cursorIndex = 0;

      _selectedIndex = null;
    });

    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(0);
    }
  }

  ///
  void _rebuildList() {
    if (_spinning) {
      return;
    }

    rouletteTempleList.clear();

    final List<SpotDataModel> list = <SpotDataModel>[];

    for (final String element in appParamState.selectedRankList) {
      templeRankMap[element]?.forEach((SpotDataModel element2) {
        if (!list.contains(element2)) {
          for (final MunicipalModel element3 in getDataState.keepTokyoMunicipalList) {
            if (spotInMunicipality(element2.latitude.toDouble(), element2.longitude.toDouble(), element3)) {
              list.add(element2);
            }
          }
        }
      });
    }

    setState(() {
      rouletteTempleList = list;

      listItemNum = list.length;

      _cursorIndex = 0;

      _selectedIndex = null;
    });
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(0);
    }
  }
}
