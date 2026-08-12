/// User fitness goals configuration.
class GoalsModel {
  GoalsModel({
    this.dailyCalories = 2500,
    this.dailySteps = 10000,
    this.weeklyWorkouts = 5,
    this.dailyWaterGlasses = 8,
    this.targetWeight = 70.0,
  });

  int dailyCalories;
  int dailySteps;
  int weeklyWorkouts;
  int dailyWaterGlasses;
  double targetWeight;

  Map<String, dynamic> toJson() => {
        'dailyCalories': dailyCalories,
        'dailySteps': dailySteps,
        'weeklyWorkouts': weeklyWorkouts,
        'dailyWaterGlasses': dailyWaterGlasses,
        'targetWeight': targetWeight,
      };

  factory GoalsModel.fromJson(Map<String, dynamic> json) {
    return GoalsModel(
      dailyCalories: json['dailyCalories'] as int? ?? 2500,
      dailySteps: json['dailySteps'] as int? ?? 10000,
      weeklyWorkouts: json['weeklyWorkouts'] as int? ?? 5,
      dailyWaterGlasses: json['dailyWaterGlasses'] as int? ?? 8,
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 70.0,
    );
  }
}
