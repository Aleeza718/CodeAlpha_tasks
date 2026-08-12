import '../models/activity_type.dart';
import '../models/daily_stats_model.dart';
import 'hive_service.dart';

/// Handles first-run initialization and loading of stored daily stats.
///
/// This does NOT create any demo/sample activities, profile info, or
/// water history. A first-time user starts with genuinely empty data;
/// HiveService's getters already return sensible zeroed defaults
/// (GoalsModel(), SettingsModel(), UserProfileModel()) when nothing has
/// been saved yet, so there is nothing fake to seed here.
class DataSeedService {
  DataSeedService(this._hive);

  final HiveService _hive;

  /// Kept for backward-compatible call sites. Intentionally a no-op:
  /// the app must not start with fake activities, profile data, or
  /// water history. Real data only ever comes from what the user enters.
  Future<void> seedIfEmpty() async {}

  /// Loads today's daily stats from Hive, or a real empty/zeroed
  /// DailyStatsModel (using the user's saved goals) if none exist yet.
  DailyStatsModel loadDailyStats() {
    final now = DateTime.now();
    final stored = _hive.getDailyStats(now);
    final goals = _hive.getGoals();

    if (stored != null) {
      return DailyStatsModel(
        calories: stored['calories'] as int? ?? 0,
        caloriesGoal: stored['caloriesGoal'] as int? ?? goals.dailyCalories,
        steps: stored['steps'] as int? ?? 0,
        stepsGoal: stored['stepsGoal'] as int? ?? goals.dailySteps,
        workoutMinutes: stored['workoutMinutes'] as int? ?? 0,
        workoutGoal: stored['workoutGoal'] as int? ?? 60,
        waterGlasses: stored['waterGlasses'] as int? ?? 0,
        waterGoal: stored['waterGoal'] as int? ?? goals.dailyWaterGlasses,
        heartRate: stored['heartRate'] as int? ?? 0,
      );
    }

    return DailyStatsModel(
      caloriesGoal: goals.dailyCalories,
      stepsGoal: goals.dailySteps,
      waterGoal: goals.dailyWaterGlasses,
      heartRate: 0,
    );
  }
}

/// Utility for estimating calories/distance based on activity parameters.
/// This is a real calculation, not sample/demo data.
abstract final class CalorieEstimator {
  static int estimate({
    required ActivityType type,
    required int durationMinutes,
    required IntensityLevel intensity,
  }) {
    const baseRates = {
      ActivityType.running: 10.0,
      ActivityType.cycling: 8.0,
      ActivityType.swimming: 11.0,
      ActivityType.walking: 4.0,
      ActivityType.gym: 7.0,
      ActivityType.yoga: 3.5,
      ActivityType.hiking: 6.0,
      ActivityType.dancing: 5.5,
    };
    final base = baseRates[type] ?? 5.0;
    return (base * durationMinutes * intensity.multiplier).round();
  }

  static double estimateDistance({
    required ActivityType type,
    required int durationMinutes,
    required IntensityLevel intensity,
  }) {
    const speedKmH = {
      ActivityType.running: 9.0,
      ActivityType.cycling: 20.0,
      ActivityType.swimming: 2.0,
      ActivityType.walking: 5.0,
      ActivityType.hiking: 4.0,
      ActivityType.dancing: 3.0,
    };
    final speed = speedKmH[type];
    if (speed == null) return 0;
    return double.parse(
      (speed * (durationMinutes / 60) * intensity.multiplier * 0.9)
          .toStringAsFixed(1),
    );
  }
}
