class BusInfoModel {
  BusInfoModel({required this.id, required this.endA, required this.endB});

  /// JSON → モデル
  factory BusInfoModel.fromJson(Map<String, dynamic> json) {
    return BusInfoModel(id: json['id'] as int, endA: json['end_a'] as String, endB: json['end_b'] as String);
  }

  final int id;
  final String endA;
  final String endB;

  /// モデル → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'end_a': endA, 'end_b': endB};
  }
}
