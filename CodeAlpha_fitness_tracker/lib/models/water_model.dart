/// Daily water intake tracking model.
class WaterModel {
  WaterModel({
    required this.date,
    required this.glasses,
    this.goalGlasses = 8,
  });

  final DateTime date;
  int glasses;
  final int goalGlasses;

  double get progress => (glasses / goalGlasses).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'glasses': glasses,
        'goalGlasses': goalGlasses,
      };

  factory WaterModel.fromJson(Map<String, dynamic> json) {
    return WaterModel(
      date: DateTime.parse(json['date'] as String),
      glasses: json['glasses'] as int,
      goalGlasses: json['goalGlasses'] as int? ?? 8,
    );
  }
}
