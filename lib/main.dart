import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/controllers_mixin.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // メモリ保護のためキャッシュ上限を控えめに（必要に応じて調整）
  PaintingBinding.instance.imageCache.maximumSize = 150; // デフォルト200
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 << 20; // 80MB

  runApp(const ProviderScope(child: AppRoot()));
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  Key _appKey = UniqueKey();

  ///
  void restartApp() => setState(() => _appKey = UniqueKey());

  ///
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MyApp(key: _appKey, onRestart: restartApp),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.onRestart});

  // ignore: unreachable_from_main
  final VoidCallback onRestart;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with ControllersMixin<MyApp> {
  ///
  @override
  void initState() {
    super.initState();

    templeNotifier.getAllTemple();
    templeLatLngNotifier.getAllTempleLatLng();
    stationNotifier.getAllStation();
    tokyoMunicipalNotifier.getAllTokyoMunicipalData();
    templePhotoNotifier.getAllTemplePhoto();
    templeListNotifier.getAllTempleList();
    tokyoTrainNotifier.getAllTokyoTrain();
    trainNotifier.getAllTrain();
    chibaMunicipalNotifier.getAllChibaMunicipalData();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const <Locale>[Locale('en'), Locale('ja')],
      theme: ThemeData.dark(useMaterial3: false),
      themeMode: ThemeMode.dark,
      title: 'LIFETIME LOG',
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: HomeScreen(
          //---
          templeList: templeState.templeList,

          //---
          templeLatLngList: templeLatLngState.templeLatLngList,
          templeLatLngMap: templeLatLngState.templeLatLngMap,

          //---
          stationMap: stationState.stationMap,

          //---
          tokyoMunicipalList: tokyoMunicipalState.tokyoMunicipalList,
          tokyoMunicipalMap: tokyoMunicipalState.tokyoMunicipalMap,

          //---
          templePhotoMap: templePhotoState.templePhotoMap,

          //---
          templeListMap: templeListState.templeListMap,
          templeListList: templeListState.templeListList,

          //---
          tokyoTrainList: tokyoTrainState.tokyoTrainList,
          tokyoTrainMap: tokyoTrainState.tokyoTrainMap,
          tokyoStationTokyoTrainModelListMap: tokyoTrainState.tokyoStationTokyoTrainModelListMap,

          //---
          trainList: trainState.trainList,
        ),
      ),
    );
  }
}
