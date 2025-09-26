import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // メモリ保護のためキャッシュ上限を控えめに（必要に応じて調整）
  PaintingBinding.instance.imageCache.maximumSize = 150; // デフォルト200
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 << 20; // 80MB

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
