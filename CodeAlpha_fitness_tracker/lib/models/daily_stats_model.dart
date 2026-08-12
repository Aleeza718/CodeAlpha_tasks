/// Daily fitness summary for home screen stats.
class DailyStatsModel {
  DailyStatsModel({
    this.calories = 0,
    this.caloriesGoal = 2500,
    this.steps = 0,
    this.stepsGoal = 10000,
    this.workoutMinutes = 0,
    this.workoutGoal = 60,
    this.waterGlasses = 0,
    this.waterGoal = 8,
    this.heartRate = 0,
  });

  int calories;
  int caloriesGoal;
  int steps;
  int stepsGoal;
  int workoutMinutes;
  int workoutGoal;
  int waterGlasses;
  int waterGoal;

  /// Latest heart-rate reading in BPM, or 0 when no real reading exists.
  /// There is currently no sensor/Health Connect/wearable integration —
  /// this field is intentionally the single source of truth so that
  /// wiring up a real source later (e.g. Health Connect or a paired
  /// smartwatch) only requires setting this to a genuine measured
  /// value; every UI that reads it already treats <= 0 as "no data".
  int heartRate;

  /// True only when [heartRate] is a genuine measurement, never a
  /// placeholder or fabricated value.
  bool get hasHeartRateReading => heartRate > 0;

  double get caloriesProgress => (calories / caloriesGoal).clamp(0.0, 1.0);
  double get stepsProgress => (steps / stepsGoal).clamp(0.0, 1.0);
  double get workoutProgress => (workoutMinutes / workoutGoal).clamp(0.0, 1.0);
  double get waterProgress => (waterGlasses / waterGoal).clamp(0.0, 1.0);

  /// Overall daily progress ring value.
  double get overallProgress =>
      (caloriesProgress + stepsProgress + workoutProgress + waterProgress) / 4;
}
