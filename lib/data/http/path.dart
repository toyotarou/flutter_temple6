enum APIPath { getAllTemple, getTempleLatLng, getTempleDatePhoto, getAllStation, getDupSpot, getTempleListTemple }

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getAllTemple:
        return 'getAllTemple';
      case APIPath.getTempleLatLng:
        return 'getTempleLatLng';
      case APIPath.getTempleDatePhoto:
        return 'getTempleDatePhoto';
      case APIPath.getAllStation:
        return 'getAllStation';
      case APIPath.getDupSpot:
        return 'getDupSpot';
      case APIPath.getTempleListTemple:
        return 'getTempleListTemple';
    }
  }
}
