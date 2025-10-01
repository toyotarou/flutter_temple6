class TempleDataModel {
  TempleDataModel({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.mark = '',
    this.cnt = 0,
    this.rank = '',
  });

  String name;
  String address;
  String latitude;
  String longitude;
  String mark;
  int cnt;
  String rank;
}
