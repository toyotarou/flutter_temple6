import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

class HomeCenteredVisitedSpotMapAlert extends ConsumerStatefulWidget {
  const HomeCenteredVisitedSpotMapAlert({super.key});

  @override
  ConsumerState<HomeCenteredVisitedSpotMapAlert> createState() => _HomeCenteredVisitedSpotMapAlertState();
}

class _HomeCenteredVisitedSpotMapAlertState extends ConsumerState<HomeCenteredVisitedSpotMapAlert>
    with ControllersMixin<HomeCenteredVisitedSpotMapAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),

            //
            //
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Stack(
            //     children: <Widget>[
            //       const Padding(padding: EdgeInsets.only(top: 10), child: Text('市区町村別神社リスト')),
            //
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           const SizedBox.shrink(),
            //
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.end,
            //             children: <Widget>[
            //               Row(
            //                 children: <Widget>[
            //                   const Text('all no reach :'),
            //
            //                   IconButton(
            //                     onPressed: () {
            //                       appParamNotifier.clearSelectedCityTownTempleMapRankList();
            //
            //                       appParamNotifier.setSelectedTrainName(name: '');
            //
            //                       appParamNotifier.clearAddRouteSpotDataModelList();
            //
            //                       appParamNotifier.clearSelectedMunicipalNameList();
            //
            //                       appParamNotifier.clearSelectedSpotDataModel();
            //
            //                       appParamNotifier.setIsJrInclude(flag: true);
            //
            //                       final Map<String, List<SpotDataModel>> tempNoReachMap =
            //                       Map<String, List<SpotDataModel>>.from(noReachMunicipalSpotDataListMap);
            //                       tempNoReachMap['tokyo'] = List<SpotDataModel>.from(allNoReachSpotDataList);
            //
            //                       TempleDialog(
            //                         context: context,
            //                         widget: CityTownTempleMapAlert(
            //                           cityTownName: 'tokyo',
            //                           latList: allLatList,
            //                           lngList: allLngList,
            //                           visitedMunicipalSpotDataListMap: const <String, List<SpotDataModel>>{},
            //                           noReachMunicipalSpotDataListMap: tempNoReachMap,
            //                           selectArealPolygons: allPolygons,
            //                         ),
            //                         clearBarrierColor: true,
            //                         executeFunctionWhenDialogClose: true,
            //                         ref: ref,
            //                         from: 'CityTownTempleMapAlert',
            //                       );
            //                     },
            //                     icon: Icon(Icons.map, color: Colors.white.withValues(alpha: 0.4)),
            //                   ),
            //                 ],
            //               ),
            //
            //               Text(
            //                 allNoReachSpotDataList.length.toString(),
            //                 style: const TextStyle(color: Colors.yellowAccent),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            //
            Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            //
            // Expanded(child: displayCityTownNameList()),
            //
            //
            //
            //
          ],
        ),
      ),
    );
  }
}
