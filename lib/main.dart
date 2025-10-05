import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/_get_data/station/station.dart';
import 'controllers/_get_data/temple/temple.dart';
import 'controllers/_get_data/temple_lat_lng/temple_lat_lng.dart';
import 'controllers/_get_data/temple_list/temple_list.dart';
import 'controllers/_get_data/temple_photo/temple_photo.dart';
import 'controllers/_get_data/tokyo_municipal/tokyo_municipal.dart';
import 'controllers/_get_data/tokyo_train/tokyo_train.dart';

import 'controllers/controllers_mixin.dart';

import 'screens/home_screen.dart';

///
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // メモリ保護のためキャッシュ上限を控えめに（必要に応じて調整）
  PaintingBinding.instance.imageCache.maximumSize = 150; // デフォルト200
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 << 20; // 80MB

  runApp(const ProviderScope(child: AppRoot()));
}

///
final FutureProvider<void> appInitProvider = FutureProvider<void>((FutureProviderRef<void> ref) async {
  await Future.wait<void>(<Future<void>>[
    ref.read(templeProvider.notifier).getAllTemple(),
    ref.read(templeLatLngProvider.notifier).getAllTempleLatLng(),
    ref.read(stationProvider.notifier).getAllStation(),
    ref.read(tokyoMunicipalProvider.notifier).getAllTokyoMunicipalData(),
    ref.read(templePhotoProvider.notifier).getAllTemplePhoto(),
    ref.read(templeListProvider.notifier).getAllTempleList(),
    ref.read(tokyoTrainProvider.notifier).getAllTokyoTrain(),
  ]);
});

///
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => AppRootState();
}

///
class AppRootState extends State<AppRoot> {
  Key _appKey = UniqueKey();

  void restartApp() => setState(() => _appKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return MyApp(key: _appKey, onRestart: restartApp);
  }
}

///
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
  Widget build(BuildContext context) {
    final AsyncValue<void> init = ref.watch(appInitProvider);

    return init.when(
      loading: () => MaterialApp(
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
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),

      error: (Object e, StackTrace st) => MaterialApp(
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
        home: Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text('初期化に失敗しました'),
                    const SizedBox(height: 8),
                    Text('$e'),
                    const SizedBox(height: 24),
                    FilledButton(onPressed: () => ref.refresh(appInitProvider), child: const Text('リトライ')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      data: (_) => MaterialApp(
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
          ),
        ),
      ),
    );
  }
}
