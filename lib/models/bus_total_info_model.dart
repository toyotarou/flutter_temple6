import 'package:equatable/equatable.dart';

class BusTotalInfoModel extends Equatable {
  const BusTotalInfoModel({required this.operatorName, required this.line, required this.stops});

  factory BusTotalInfoModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> stopList = json['stops'] as List<dynamic>;
    return BusTotalInfoModel(
      operatorName: json['operator'] as String,
      line: json['line'] as String,
      // ignore: always_specify_types
      stops: stopList.map((e) => BusStopModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  final String operatorName;
  final String line;
  final List<BusStopModel> stops;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'operator': operatorName,
    'line': line,
    'stops': stops.map((BusStopModel e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => <Object?>[operatorName, line, stops];
}

class BusStopModel extends Equatable {
  const BusStopModel({required this.orderNum, required this.name, required this.lat, required this.lon});

  factory BusStopModel.fromJson(Map<String, dynamic> json) {
    return BusStopModel(
      orderNum: json['order_num'] as int,
      name: json['name'] as String,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
    );
  }

  final int orderNum;
  final String name;
  final String lat;
  final String lon;

  Map<String, dynamic> toJson() => <String, dynamic>{'order_num': orderNum, 'name': name, 'lat': lat, 'lon': lon};

  @override
  List<Object?> get props => <Object?>[orderNum, name, lat, lon];
}
