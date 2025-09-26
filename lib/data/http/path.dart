enum APIPath { getAllTemple, getTempleLatLng, getTempleDatePhoto }

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getAllTemple:
        return 'getAllTemple';
      case APIPath.getTempleLatLng:
        return 'getTempleLatLng';
      case APIPath.getTempleDatePhoto:
        return 'getTempleDatePhoto';
    }
  }
}
