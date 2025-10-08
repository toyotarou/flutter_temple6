import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../extensions/extensions.dart';

class Utility {
  /// 背景取得
  // ignore: always_specify_types
  Widget getBackGround({context}) {
    return Image.asset(
      'assets/images/bg.png',
      fit: BoxFit.fitHeight,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  ///
  void showError(String msg) {
    ScaffoldMessenger.of(
      NavigationService.navigatorKey.currentContext!,
    ).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 5)));
  }

  ///
  Color getYoubiColor({required DateTime date, required String youbiStr, required List<DateTime> holiday}) {
    Color color = Colors.black.withOpacity(0.2);

    switch (youbiStr) {
      case 'Sunday':
        color = Colors.redAccent.withOpacity(0.2);

      case 'Saturday':
        color = Colors.blueAccent.withOpacity(0.2);

      default:
        color = Colors.black.withOpacity(0.2);
    }

    if (holiday.contains(date)) {
      color = Colors.greenAccent.withOpacity(0.2);
    }

    return color;
  }

  ///
  Color getLeadingBgColor({required String month}) {
    switch (month.toInt() % 6) {
      case 0:
        return Colors.orangeAccent.withOpacity(0.2);
      case 1:
        return Colors.blueAccent.withOpacity(0.2);
      case 2:
        return Colors.redAccent.withOpacity(0.2);
      case 3:
        return Colors.purpleAccent.withOpacity(0.2);
      case 4:
        return Colors.greenAccent.withOpacity(0.2);
      case 5:
        return Colors.yellowAccent.withOpacity(0.2);
      default:
        return Colors.black;
    }
  }

  ///
  List<Color> getTwentyFourColor() {
    return <Color>[
      const Color(0xFFE53935), // 赤 (100%)
      const Color(0xFF1E88E5), // 青 (100%)
      const Color(0xFF43A047), // 緑 (100%)
      const Color(0xFFFFA726), // オレンジ (100%)
      const Color(0xFF8E24AA), // 紫 (100%)
      const Color(0xFF00ACC1), // シアン (100%)
      const Color(0xFFFDD835), // 黄 (100%)
      const Color(0xFF6D4C41), // 茶 (100%)
      const Color(0xFFD81B60), // ピンク (100%)
      const Color(0xFF3949AB), // インディゴ (100%)
      const Color(0xFF00897B), // ティール (100%)
      const Color(0xCCFF7043), // 明るいオレンジ (80%)
      const Color(0xFF7CB342), // ライムグリーン (100%)
      const Color(0xFF5E35B1), // ディープパープル (100%)
      const Color(0xCC26C6DA), // ライトシアン (80%)
      const Color(0xCCFFEE58), // 明るい黄 (80%)
      const Color(0xFFBDBDBD), // グレー (100%)
      const Color(0xCCEF5350), // 明るい赤 (80%)
      const Color(0xCC42A5F5), // 明るい青 (80%)
      const Color(0xCC66BB6A), // 明るい緑 (80%)
      const Color(0x99FFB74D), // 明るいオレンジ (60%)
      const Color(0xCCAB47BC), // 明るい紫 (80%)
      const Color(0xCC26A69A), // 明るいティール (80%)
      const Color(0xCCFF8A65), // サーモン (80%)
    ];
  }

  ///
  double calculateDistance(LatLng p1, LatLng p2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, p1, p2);
  }
}

class NavigationService {
  const NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
