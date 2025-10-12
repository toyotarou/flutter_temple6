import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/municipal_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../utility/functions.dart';
import '../parts/temple_dialog.dart';
import 'city_town_temple_map_alert.dart';

class CityTownTempleListAlert extends ConsumerStatefulWidget {
  const CityTownTempleListAlert({super.key});

  @override
  ConsumerState<CityTownTempleListAlert> createState() => _CityTownTempleListAlertState();
}

class _CityTownTempleListAlertState extends ConsumerState<CityTownTempleListAlert>
    with ControllersMixin<CityTownTempleListAlert> {
  List<String> cityTownNameList = <String>[];

  Map<String, List<SpotDataModel>> cityTownMunicipalSpotDataListMap = <String, List<SpotDataModel>>{};

  Map<String, List<SpotDataModel>> visitedMunicipalSpotDataListMap = <String, List<SpotDataModel>>{};

  Map<String, List<SpotDataModel>> noReachMunicipalSpotDataListMap = <String, List<SpotDataModel>>{};

  List<SpotDataModel> allNoReachSpotDataList = <SpotDataModel>[];

  Map<String, String> visitedTempleNameRankMap = <String, String>{};

  List<double> allLatList = <double>[];

  List<double> allLngList = <double>[];

  List<List<List<List<double>>>>? allPolygons = <List<List<List<double>>>>[];

  ///
  @override
  void initState() {
    super.initState();

    cityTownNameList = cityTownNames.split('\n').where((String e) => e.trim().isNotEmpty).toList();

    // ignore: always_specify_types
    Future(() {
      for (final TempleLatLngModel element in getDataState.keepTempleLatLngList) {
        visitedTempleNameRankMap[element.temple] = element.rank;
      }
    });
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 10), child: Text('市区町村別神社リスト')),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox.shrink(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Text('all no reach :'),

                              IconButton(
                                onPressed: () {
                                  appParamNotifier.clearSelectedCityTownTempleMapRankList();

                                  appParamNotifier.setSelectedTrainName(name: '');

                                  appParamNotifier.clearAddRouteSpotDataModelList();

                                  appParamNotifier.clearSelectedMunicipalNameList();

                                  appParamNotifier.clearSelectedSpotDataModel();

                                  appParamNotifier.setIsJrInclude(flag: true);

                                  final Map<String, List<SpotDataModel>> tempNoReachMap =
                                      Map<String, List<SpotDataModel>>.from(noReachMunicipalSpotDataListMap);
                                  tempNoReachMap['tokyo'] = List<SpotDataModel>.from(allNoReachSpotDataList);

                                  TempleDialog(
                                    context: context,
                                    widget: CityTownTempleMapAlert(
                                      cityTownName: 'tokyo',
                                      latList: allLatList,
                                      lngList: allLngList,
                                      visitedMunicipalSpotDataListMap: const <String, List<SpotDataModel>>{},
                                      noReachMunicipalSpotDataListMap: tempNoReachMap,
                                      selectArealPolygons: allPolygons,
                                    ),
                                    clearBarrierColor: true,
                                    executeFunctionWhenDialogClose: true,
                                    ref: ref,
                                    from: 'CityTownTempleMapAlert',
                                  );
                                },
                                icon: Icon(Icons.map, color: Colors.white.withValues(alpha: 0.4)),
                              ),
                            ],
                          ),

                          Text(
                            allNoReachSpotDataList.length.toString(),
                            style: const TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

            Expanded(child: displayCityTownNameList()),
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
  Widget displayCityTownNameList() {
    allLatList.clear();
    allLngList.clear();
    allPolygons?.clear();

    final List<Widget> list = <Widget>[];

    for (final String element in cityTownNameList) {
      final int cityTownMunicipalSpotDataCount = (cityTownMunicipalSpotDataListMap[element] != null)
          ? cityTownMunicipalSpotDataListMap[element]!.length
          : 0;

      final int visitedMunicipalSpotDataCount = (visitedMunicipalSpotDataListMap[element] != null)
          ? visitedMunicipalSpotDataListMap[element]!.length
          : 0;

      final int noReachMunicipalSpotDataCount = (noReachMunicipalSpotDataListMap[element] != null)
          ? noReachMunicipalSpotDataListMap[element]!.length
          : 0;

      final List<List<List<List<double>>>>? polygons = getDataState.keepTokyoMunicipalMap[element]?.polygons;

      final Map<String, List<double>> municipalLatLng = getMunicipalLatLng(polygons: polygons);

      allLatList.addAll(municipalLatLng['latList'] ?? <double>[]);
      allLngList.addAll(municipalLatLng['lngList'] ?? <double>[]);

      if (polygons != null) {
        allPolygons?.addAll(polygons);
      }

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text(element)),

                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      alignment: Alignment.topRight,
                      child: Text(cityTownMunicipalSpotDataCount.toString()),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.topRight,
                      child: Text(visitedMunicipalSpotDataCount.toString()),
                    ),

                    Container(
                      width: 40,
                      alignment: Alignment.topRight,
                      child: Text(
                        noReachMunicipalSpotDataCount.toString(),
                        style: TextStyle(
                          color: (noReachMunicipalSpotDataCount > 0) ? Colors.yellowAccent : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                IconButton(
                  onPressed: () {
                    appParamNotifier.clearSelectedCityTownTempleMapRankList();

                    appParamNotifier.setSelectedTrainName(name: '');

                    appParamNotifier.clearAddRouteSpotDataModelList();

                    appParamNotifier.clearSelectedMunicipalNameList();

                    appParamNotifier.clearSelectedSpotDataModel();

                    appParamNotifier.setIsJrInclude(flag: true);

                    TempleDialog(
                      context: context,
                      widget: CityTownTempleMapAlert(
                        cityTownName: element,
                        latList: municipalLatLng['latList'] ?? <double>[],
                        lngList: municipalLatLng['lngList'] ?? <double>[],
                        visitedMunicipalSpotDataListMap: visitedMunicipalSpotDataListMap,
                        noReachMunicipalSpotDataListMap: noReachMunicipalSpotDataListMap,
                        selectArealPolygons: getDataState.keepTokyoMunicipalMap[element]?.polygons,
                      ),
                      clearBarrierColor: true,
                      executeFunctionWhenDialogClose: true,
                      ref: ref,
                      from: 'CityTownTempleMapAlert',
                    );
                  },
                  icon: Icon(Icons.map, color: Colors.white.withValues(alpha: 0.4)),
                ),
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
}
