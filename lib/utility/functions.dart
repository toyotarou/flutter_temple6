import '../models/common/spot_data_model.dart';
import '../models/tokyo_municipal_model.dart';

const double _eps = 1e-12;

///
bool pointInMunicipality(double lat, double lng, TokyoMunicipalModel muni) {
  for (final List<List<List<double>>> polygon in muni.polygons) {
    if (polygon.isEmpty) {
      continue;
    }

    final List<List<double>> outerRing = polygon.first;

    if (!pointInRingOrOnEdge(lat, lng, outerRing)) {
      continue;
    }

    bool inAnyHole = false;

    for (int i = 1; i < polygon.length; i++) {
      final List<List<double>> holeRing = polygon[i];

      if (pointInRingOrOnEdge(lat, lng, holeRing)) {
        inAnyHole = true;

        break;
      }
    }

    if (!inAnyHole) {
      return true;
    }
  }

  return false;
}

///
bool pointInRingOrOnEdge(double lat, double lng, List<List<double>> ring) {
  for (int i = 0; i < ring.length; i++) {
    final List<double> a = ring[i];

    final List<double> b = ring[(i + 1) % ring.length];

    final double aLng = a[0], aLat = a[1];

    final double bLng = b[0], bLat = b[1];

    if (_pointOnSegment(lat, lng, aLat, aLng, bLat, bLng)) {
      return true;
    }
  }

  return _rayCasting(lat, lng, ring);
}

///
bool _rayCasting(double lat, double lng, List<List<double>> ring) {
  bool inside = false;

  for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final double xiLat = ring[i][1], xiLng = ring[i][0];

    final double xjLat = ring[j][1], xjLng = ring[j][0];

    final bool crossesVertically = (xiLat > lat) != (xjLat > lat);

    if (!crossesVertically) {
      continue;
    }

    final double t = (lat - xiLat) / (xjLat - xiLat);

    final double intersectionLng = xiLng + t * (xjLng - xiLng);

    if (intersectionLng > lng) {
      inside = !inside;
    }
  }

  return inside;
}

///
bool _pointOnSegment(double pLat, double pLng, double aLat, double aLng, double bLat, double bLng) {
  final double minLat = (aLat < bLat) ? aLat : bLat;

  final double maxLat = (aLat > bLat) ? aLat : bLat;

  final double minLng = (aLng < bLng) ? aLng : bLng;

  final double maxLng = (aLng > bLng) ? aLng : bLng;

  final bool withinBox =
      (pLat >= minLat - _eps) && (pLat <= maxLat + _eps) && (pLng >= minLng - _eps) && (pLng <= maxLng + _eps);

  if (!withinBox) {
    return false;
  }

  final double vLat = bLat - aLat;

  final double vLng = bLng - aLng;

  final double wLat = pLat - aLat;

  final double wLng = pLng - aLng;

  final double cross = (vLng * wLat) - (vLat * wLng);

  if (cross.abs() > 1e-10) {
    return false;
  }

  final double vLen2 = vLat * vLat + vLng * vLng;

  if (vLen2 < 1e-20) {
    final double d2 = wLat * wLat + wLng * wLng;

    return d2 < 1e-20;
  }

  final double t = (wLat * vLat + wLng * vLng) / vLen2;

  return t >= -_eps && t <= 1 + _eps;
}

///
List<SpotDataModel> getUniqueTemples(List<SpotDataModel> input) {
  final Map<String, List<SpotDataModel>> map = <String, List<SpotDataModel>>{};
  for (final SpotDataModel t in input) {
    map.putIfAbsent(t.name, () => <SpotDataModel>[]).add(t);
  }

  final List<SpotDataModel> result = <SpotDataModel>[];

  for (final MapEntry<String, List<SpotDataModel>> entry in map.entries) {
    if (entry.value.length == 1) {
      result.add(entry.value.first);
    } else {
      final double avgLat = averageOf<SpotDataModel>(entry.value, (SpotDataModel e) => double.tryParse(e.latitude));

      final double avgLng = averageOf<SpotDataModel>(
        entry.value,
        (SpotDataModel e) => double.tryParse(e.longitude),
      );

      result.add(
        SpotDataModel(
          name: entry.key,
          address: '',
          latitude: avgLat.toString(),
          longitude: avgLng.toString(),
          rank: entry.value.first.rank,
        ),
      );
    }
  }
  return result;
}

///
double averageOf<T>(Iterable<T> items, double? Function(T) selector) {
  double sum = 0.0;
  int count = 0;
  // ignore: always_specify_types
  for (final it in items) {
    final double? v = selector(it);
    if (v != null && v.isFinite) {
      sum += v;
      count++;
    }
  }
  return count == 0 ? 0.0 : sum / count;
}
