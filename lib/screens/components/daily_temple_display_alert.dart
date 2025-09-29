import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';
import '../../models/common/temple_data.dart';

class DailyTempleDisplayAlert extends ConsumerStatefulWidget {
  const DailyTempleDisplayAlert({super.key, required this.date, required this.templeDataList});

  final String date;
  final List<TempleData> templeDataList;

  @override
  ConsumerState<DailyTempleDisplayAlert> createState() => _DailyTempleDisplayAlertState();
}

class _DailyTempleDisplayAlertState extends ConsumerState<DailyTempleDisplayAlert>
    with ControllersMixin<DailyTempleDisplayAlert> {
  List<TempleData> templeDataList = <TempleData>[];

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const FlutterMap(children: <Widget>[]),

            Column(children: <Widget>[Expanded(child: displayDailyTempleList())]),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayDailyTempleList() {
    final List<Widget> list = <Widget>[];

    for (final TempleData element in widget.templeDataList) {
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
