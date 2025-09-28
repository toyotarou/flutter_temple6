import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/common/temple_data.dart';

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
  void makeTempleDataList() {}

  ///
  Widget displayDailyTempleList() {
    final List<Widget> list = <Widget>[];

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
