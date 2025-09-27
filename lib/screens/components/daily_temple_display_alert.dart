import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class DailyTempleDisplayAlert extends ConsumerStatefulWidget {
  const DailyTempleDisplayAlert({super.key});

  @override
  ConsumerState<DailyTempleDisplayAlert> createState() => _DailyTempleDisplayAlertState();
}

class _DailyTempleDisplayAlertState extends ConsumerState<DailyTempleDisplayAlert>
    with ControllersMixin<DailyTempleDisplayAlert> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
