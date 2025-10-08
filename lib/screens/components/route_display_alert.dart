import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../utility/utility.dart';

class RouteDisplayAlert extends ConsumerStatefulWidget {
  const RouteDisplayAlert({super.key});

  @override
  ConsumerState<RouteDisplayAlert> createState() => _RouteDisplayAlertState();
}

class _RouteDisplayAlertState extends ConsumerState<RouteDisplayAlert> with ControllersMixin<RouteDisplayAlert> {
  Utility utility = Utility();

  int templeCount = 0;

  List<int> walkMinutesList = <int>[];

  int walkSum = 0;

  String? endTime;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(width: context.screenSize.width),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    //                    routingNotifier.insertRoute();
                  },
                  icon: const Icon(Icons.input, color: Colors.white),
                ),
                Container(),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Expanded(child: displayRouteList()),
            Divider(color: Colors.white.withOpacity(0.5), thickness: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('start: ${appParamState.startTime}'), Text('end: $endTime')],
                ),

                const Divider(color: Colors.white),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('temple: $templeCount spots. -> ${templeCount * appParamState.stayTime.toInt()} 分'),
                        Text('walk sum: $walkSum 分'),
                      ],
                    ),

                    Text(calculateHourAndMinutes(<int>[(templeCount * appParamState.stayTime.toInt()), walkSum])),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayRouteList() {
    walkMinutesList.clear();

    final List<Widget> list = <Widget>[];

    int tCount = 0;

    for (int i = 0; i < appParamState.addRouteSpotDataModelList.length; i++) {
      if (appParamState.addRouteSpotDataModelList[i].type == 'temple') {
        tCount++;
      }

      list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.2),

                child: (appParamState.addRouteSpotDataModelList[i].type == 'station')
                    ? const Icon(Icons.train)
                    : const Icon(FontAwesomeIcons.toriiGate),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(appParamState.addRouteSpotDataModelList[i].name),
                    Text(appParamState.addRouteSpotDataModelList[i].address),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      if (i != appParamState.addRouteSpotDataModelList.length - 1) {
        final double distance = utility.calculateDistance(
          LatLng(
            appParamState.addRouteSpotDataModelList[i].latitude.toDouble(),
            appParamState.addRouteSpotDataModelList[i].longitude.toDouble(),
          ),
          LatLng(
            appParamState.addRouteSpotDataModelList[i + 1].latitude.toDouble(),
            appParamState.addRouteSpotDataModelList[i + 1].longitude.toDouble(),
          ),
        );

        final double walkMinutes =
            ((distance / (appParamState.walkSpeed.toInt() * 1000)) * 60) *
            ((100 + appParamState.adjustPercent.toInt()) / 100);

        walkMinutesList.add(walkMinutes.toInt());

        list.add(
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.arrow_downward),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text('${distance.toInt()} m'), Text('${walkMinutes.toInt()} 分')],
                    ),
                  ],
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        );
      }
    }

    setState(() {
      templeCount = tCount;

      walkSum = walkMinutesList.fold(0, (int sum, int element) => sum + element);

      endTime = calculateEndTimeSafe(appParamState.startTime, <int>[
        (templeCount * appParamState.stayTime.toInt()),
        walkSum,
      ]);
    });

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

  ///
  String? calculateEndTimeSafe(String startTime, List<int> minutesList) {
    if (startTime.isEmpty) {
      return null;
    }

    final String normalized = startTime.trim().replaceAll('：', ':');

    final RegExpMatch? match = RegExp(r'^(\d{1,2})[:\-]?(\d{2})$').firstMatch(normalized);

    if (match == null) {
      return null;
    }

    final int hh = int.parse(match.group(1)!);
    final int mm = int.parse(match.group(2)!);

    if (hh < 0 || hh > 23 || mm < 0 || mm > 59) {
      return null;
    }

    final int totalMinutes = minutesList.fold<int>(0, (int sum, int e) => sum + e);

    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day, hh, mm);
    final DateTime end = start.add(Duration(minutes: totalMinutes));

    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(end.hour)}:${two(end.minute)}';
  }

  ///
  String calculateHourAndMinutes(List<int> minutesList) {
    final int totalMinutes = minutesList.fold<int>(0, (int sum, int value) => sum + value);

    final int hours = totalMinutes ~/ 60;
    final int mins = totalMinutes % 60;

    return '$hours時間$mins分';
  }
}
