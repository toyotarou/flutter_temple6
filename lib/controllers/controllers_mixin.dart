import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_get_data/temple/temple.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//

  TempleState get templeState => ref.watch(templeProvider);

  Temple get templeNotifier => ref.read(templeProvider.notifier);

  //==========================================//
}
