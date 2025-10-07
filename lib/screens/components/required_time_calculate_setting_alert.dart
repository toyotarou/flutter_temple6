import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/controllers_mixin.dart';

class RequiredTimeCalculateSettingAlert extends ConsumerStatefulWidget {
  const RequiredTimeCalculateSettingAlert({super.key});

  @override
  ConsumerState<RequiredTimeCalculateSettingAlert> createState() => _RequiredTimeCalculateSettingAlertState();
}

class _RequiredTimeCalculateSettingAlertState extends ConsumerState<RequiredTimeCalculateSettingAlert>
    with ControllersMixin<RequiredTimeCalculateSettingAlert> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
