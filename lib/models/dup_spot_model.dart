class DupSpotModel {
  DupSpotModel({required this.id, required this.name, required this.area});

  /// JSON → モデル
  factory DupSpotModel.fromJson(Map<String, dynamic> json) =>
      DupSpotModel(id: json['id'] as int, name: json['name'] as String, area: json['area'] as String);

  final int id;
  final String name;
  final String area;

  /// モデル → JSON
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name, 'area': area};
}
