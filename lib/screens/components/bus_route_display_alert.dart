import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../models/bus_total_info_model.dart';

class BusRouteDisplayAlert extends ConsumerStatefulWidget {
  const BusRouteDisplayAlert({super.key, required this.selectedBusTotalInfoModel});

  final BusTotalInfoModel selectedBusTotalInfoModel;

  @override
  ConsumerState<BusRouteDisplayAlert> createState() => _BusRouteDisplayAlertState();
}

class _BusRouteDisplayAlertState extends ConsumerState<BusRouteDisplayAlert>
    with ControllersMixin<BusRouteDisplayAlert> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),

            Expanded(child: displayBusRouteList()),

            // Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
            //
            // Text(widget.selectedBusTotalInfoModel.line),
            //
            // // Expanded(child: displayCityTownNameList()),
            // //
            // //
            // //
            // //
          ],
        ),
      ),
    );
  }

  ///
  Widget displayBusRouteList() {
    final List<Widget> list = <Widget>[];

    getDataState.keepBusTotalInfoViaStationMap[appParamState.selectedSpotDataModel!.name]?.forEach((
      BusTotalInfoModel element,
    ) {
      if (element == widget.selectedBusTotalInfoModel) {
        for (final BusStopModel element2 in element.stops) {
          list.add(
            DefaultTextStyle(
              style: const TextStyle(fontSize: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                ),
                padding: const EdgeInsets.all(5),

                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Expanded(flex: 2, child: SizedBox.shrink()),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[Text(element2.lat), Text(element2.lon)],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Expanded(flex: 2, child: Text(element2.name)),

                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    });

    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent, width: 2)),

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
