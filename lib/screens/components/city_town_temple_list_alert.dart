import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/const.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

class CityTownTempleListAlert extends ConsumerStatefulWidget {
  const CityTownTempleListAlert({super.key});

  @override
  ConsumerState<CityTownTempleListAlert> createState() => _CityTownTempleListAlertState();
}

class _CityTownTempleListAlertState extends ConsumerState<CityTownTempleListAlert>
    with ControllersMixin<CityTownTempleListAlert> {
  List<String> cityTownNameList = <String>[];

  ///
  @override
  void initState() {
    super.initState();

    cityTownNameList = cityTownNames.split('\n').where((String e) => e.trim().isNotEmpty).toList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),

            Expanded(child: displayCityTownNameList()),
          ],
        ),
      ),
    );
  }

  ///
  Widget displayCityTownNameList() {
    final List<Widget> list = <Widget>[];

    for (final String element in cityTownNameList) {
      list.add(Text(element));
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
