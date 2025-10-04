import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_list_model.dart';
import '../../models/tokyo_municipal_model.dart';
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

  int allNoReachCount = 0;

  Map<String, String> visitedTempleNameRankMap = <String, String>{};

  ///
  @override
  void initState() {
    super.initState();

    cityTownNameList = cityTownNames.split('\n').where((String e) => e.trim().isNotEmpty).toList();

    // ignore: always_specify_types
    Future(() {
      for (final TempleLatLngModel element in appParamState.keepTempleLatLngList) {
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
                                onPressed: () {},
                                icon: Icon(Icons.map, color: Colors.white.withValues(alpha: 0.4)),
                              ),
                            ],
                          ),

                          Text(allNoReachCount.toString(), style: const TextStyle(color: Colors.yellowAccent)),
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

    final List<String> visitedTemples = appParamState.keepTempleLatLngList
        .map((TempleLatLngModel e) => e.temple)
        .toList();

    appParamState.keepTokyoMunicipalMap.forEach((String key, TokyoMunicipalModel value) {
      for (final TempleListModel element in appParamState.keepTempleListList) {
        if (spotInMunicipality(element.lat.toDouble(), element.lng.toDouble(), value)) {
          (cityTownMunicipalSpotDataListMap[key] ??= <SpotDataModel>[]).add(
            SpotDataModel(name: element.name, address: element.address, latitude: element.lat, longitude: element.lng),
          );

          if (visitedTemples.contains(element.name)) {
            (visitedMunicipalSpotDataListMap[key] ??= <SpotDataModel>[]).add(
              SpotDataModel(
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
    final List<Widget> list = <Widget>[];

    int noReachCount = 0;

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

      noReachCount += noReachMunicipalSpotDataCount;

      final List<List<List<List<double>>>>? polygons = appParamState.keepTokyoMunicipalMap[element]?.polygons;

      final List<double> latList = polygons == null
          ? <double>[]
          : polygons
                .expand((List<List<List<double>>> e2) => e2)
                .expand((List<List<double>> e3) => e3)
                .map((List<double> p) => p[1])
                .toList();

      final List<double> lngList = polygons == null
          ? <double>[]
          : polygons
                .expand((List<List<List<double>>> e2) => e2)
                .expand((List<List<double>> e3) => e3)
                .map((List<double> p) => p[0])
                .toList();

      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
          ),
          padding: const EdgeInsets.all(5),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(element)),

              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    alignment: Alignment.topRight,
                    child: Text(cityTownMunicipalSpotDataCount.toString()),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.topRight,
                    child: Text(visitedMunicipalSpotDataCount.toString()),
                  ),

                  Container(
                    width: 50,
                    alignment: Alignment.topRight,
                    child: Text(
                      noReachMunicipalSpotDataCount.toString(),

                      style: TextStyle(color: (noReachMunicipalSpotDataCount > 0) ? Colors.yellowAccent : Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              IconButton(
                onPressed: () {
                  appParamNotifier.clearSelectedCityTownTempleMapRankList();

                  TempleDialog(
                    context: context,
                    widget: CityTownTempleMapAlert(
                      cityTownName: element,

                      latList: latList,
                      lngList: lngList,

                      visitedMunicipalSpotDataListMap: visitedMunicipalSpotDataListMap,
                      noReachMunicipalSpotDataListMap: noReachMunicipalSpotDataListMap,

                      polygons: appParamState.keepTokyoMunicipalMap[element]?.polygons,
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
      );
    }

    setState(() => allNoReachCount = noReachCount);

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
