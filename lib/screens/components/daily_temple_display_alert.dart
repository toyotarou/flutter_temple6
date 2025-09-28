import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/common/temple_data.dart';
import '../../models/station_model.dart';
import '../../models/temple_lat_lng_model.dart';
import '../../models/temple_model.dart';

class DailyTempleDisplayAlert extends ConsumerStatefulWidget {
  const DailyTempleDisplayAlert({super.key, required this.date});

  final String date;

  @override
  ConsumerState<DailyTempleDisplayAlert> createState() => _DailyTempleDisplayAlertState();
}

class _DailyTempleDisplayAlertState extends ConsumerState<DailyTempleDisplayAlert>
    with ControllersMixin<DailyTempleDisplayAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  ///
  @override
  Widget build(BuildContext context) {
    makeTempleDataList();

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(children: []),

            Column(children: <Widget>[Expanded(child: displayDailyTempleList())]),
          ],
        ),
      ),
    );
  }

  ///
  void makeTempleDataList() {
    templeDataList.clear();

    StationModel? stationModel;
    TempleLatLngModel? templeLatLngModel;

    final List<TempleModel> templeModel = appParamState.keepTempleList
        .where((TempleModel value) => value.date.yyyymmdd == widget.date)
        .toList();

    if (templeModel.isNotEmpty) {
      //-------------------------------------------------//
      if (templeModel.first.startPoint != '') {
        switch (templeModel.first.startPoint) {
          case '自宅':
            templeDataList.add(
              TempleData(
                name: templeModel.first.startPoint,
                address: '千葉県船橋市二子町492-25-101',
                latitude: funabashiLat.toString(),
                longitude: funabashiLng.toString(),
                mark: (templeModel.first.startPoint == templeModel.first.endPoint) ? 'S/E' : 'S',
              ),
            );

          case '実家':
            templeDataList.add(
              TempleData(
                name: templeModel.first.startPoint,
                address: '東京都杉並区善福寺4-22-11',
                latitude: zenpukujiLat.toString(),
                longitude: zenpukujiLng.toString(),
                mark: (templeModel.first.startPoint == templeModel.first.endPoint) ? 'S/E' : 'S',
              ),
            );

          default:
            stationModel = appParamState.keepStationMap[templeModel.first.startPoint];

            if (stationModel != null) {
              templeDataList.add(
                TempleData(
                  name: stationModel.stationName,
                  address: stationModel.address,
                  latitude: stationModel.lat,
                  longitude: stationModel.lng,
                ),
              );
            }
        }
      }
      //-------------------------------------------------//

      if (templeModel.first.temple != '') {
        templeLatLngModel = appParamState.keepTempleLatLngMap[templeModel.first.temple];

        if (templeLatLngModel != null) {
          templeDataList.add(
            TempleData(
              name: templeLatLngModel.temple,
              address: templeLatLngModel.address,
              latitude: templeLatLngModel.lat,
              longitude: templeLatLngModel.lng,
            ),
          );
        }
      }

      if (templeModel.first.memo != '') {
        templeModel.first.memo.split('、').forEach((String element) {
          templeLatLngModel = appParamState.keepTempleLatLngMap[element];

          if (templeLatLngModel != null) {
            templeDataList.add(
              TempleData(
                name: templeLatLngModel!.temple,
                address: templeLatLngModel!.address,
                latitude: templeLatLngModel!.lat,
                longitude: templeLatLngModel!.lng,
              ),
            );
          }
        });
      }

      //-------------------------------------------------//
      if (templeModel.first.endPoint != '') {
        switch (templeModel.first.endPoint) {
          case '自宅':
            templeDataList.add(
              TempleData(
                name: templeModel.first.endPoint,
                address: '千葉県船橋市二子町492-25-101',
                latitude: funabashiLat.toString(),
                longitude: funabashiLng.toString(),
                mark: (templeModel.first.startPoint == templeModel.first.endPoint) ? 'S/E' : 'S',
              ),
            );

          case '実家':
            templeDataList.add(
              TempleData(
                name: templeModel.first.endPoint,
                address: '東京都杉並区善福寺4-22-11',
                latitude: zenpukujiLat.toString(),
                longitude: zenpukujiLng.toString(),
                mark: (templeModel.first.startPoint == templeModel.first.endPoint) ? 'S/E' : 'S',
              ),
            );

          default:
            stationModel = appParamState.keepStationMap[templeModel.first.endPoint];

            if (stationModel != null) {
              templeDataList.add(
                TempleData(
                  name: stationModel.stationName,
                  address: stationModel.address,
                  latitude: stationModel.lat,
                  longitude: stationModel.lng,
                ),
              );
            }
        }
      }
      //-------------------------------------------------//
    }
  }

  ///
  Widget displayDailyTempleList() {
    final List<Widget> list = <Widget>[];

    for (final TempleData element in templeDataList) {
      list.add(Text(element.name));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
