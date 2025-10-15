import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/extensions.dart';
import '../../models/common/spot_data_model.dart';

class PickupTempleMapAlert extends ConsumerStatefulWidget {
  const PickupTempleMapAlert({super.key, required this.spotDataModel});

  final SpotDataModel spotDataModel;

  @override
  ConsumerState<PickupTempleMapAlert> createState() => _PickupTempleMapAlertState();
}

class _PickupTempleMapAlertState extends ConsumerState<PickupTempleMapAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(width: context.screenSize.width),

            Text(widget.spotDataModel.name),
            Text(widget.spotDataModel.address),
            Text(widget.spotDataModel.latitude),
            Text(widget.spotDataModel.longitude),
          ],
        ),
      ),
    );
  }
}
