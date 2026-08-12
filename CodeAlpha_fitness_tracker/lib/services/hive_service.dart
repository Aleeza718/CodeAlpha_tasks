import 'package:hive_flutter/hive_flutter.dart';

import '../models/activity_model.dart';
import '../models/goals_model.dart';
import '../models/settings_model.dart';
import '../models/user_profile_model.dart';
import '../models/water_model.dart';

/// Hive box names used across the app.
abstract final class HiveBoxes {
  static const activities = 'activities';
  static const water = 'water';
  static const goals = 'goals';
  static const settings = 'settings';
  static const profile = 'profile';
  static const dailyStats = 'daily_stats';
}

/// Initializes Hive and opens all required boxes.
class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  late Box<Map> _activitiesBox;
  late Box<Map> _waterBox;
  late Box<Map> _goalsBox;
  late Box<Map> _settingsBox;
  late Box<Map> _profileBox;
  late Box<Map> _dailyStatsBox;

  bool _initialized = false;

  /// Initializes Hive and opens all required boxes.
  ///
  /// [testPath] is only used by widget/unit tests, which have no
  /// `path_provider` platform channel available: passing a directory
  /// switches to the plain `Hive.init(path)` instead of
  /// `Hive.initFlutter()`. Production app startup (main.dart) never
  /// passes this, so real app behavior is unchanged.
  Future<void> init({String? testPath}) async {
    if (_initialized) return;
    if (testPath != null) {
      Hive.init(testPath);
    } else {
      await Hive.initFlutter();
    }

    _activitiesBox = await Hive.openBox<Map>(HiveBoxes.activities);
    _waterBox = await Hive.openBox<Map>(HiveBoxes.water);
    _goalsBox = await Hive.openBox<Map>(HiveBoxes.goals);
    _settingsBox = await Hive.openBox<Map>(HiveBoxes.settings);
    _profileBox = await Hive.openBox<Map>(HiveBoxes.profile);
    _dailyStatsBox = await Hive.openBox<Map>(HiveBoxes.dailyStats);

    _initialized = true;
  }

  // --- Activities ---

  List<ActivityModel> getActivities() {
    return _activitiesBox.values
        .map((e) => ActivityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveActivity(ActivityModel activity) async {
    await _activitiesBox.put(activity.id, activity.toJson());
  }

  Future<void> deleteActivity(String id) async {
    await _activitiesBox.delete(id);
  }

  // --- Water ---

  WaterModel? getWaterForDate(DateTime date) {
    final key = _dateKey(date);
    final data = _waterBox.get(key);
    if (data == null) return null;
    return WaterModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveWater(WaterModel water) async {
    await _waterBox.put(_dateKey(water.date), water.toJson());
  }

  // --- Goals ---

  GoalsModel getGoals() {
    final data = _goalsBox.get('goals');
    if (data == null) return GoalsModel();
    return GoalsModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveGoals(GoalsModel goals) async {
    await _goalsBox.put('goals', goals.toJson());
  }

  // --- Settings ---

  SettingsModel getSettings() {
    final data = _settingsBox.get('settings');
    if (data == null) return SettingsModel();
    return SettingsModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await _settingsBox.put('settings', settings.toJson());
  }

  // --- Profile ---

  UserProfileModel getProfile() {
    final data = _profileBox.get('profile');
    if (data == null) return UserProfileModel();
    return UserProfileModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    await _profileBox.put('profile', profile.toJson());
  }

  // --- Daily Stats ---

  Map<String, dynamic>? getDailyStats(DateTime date) {
    final data = _dailyStatsBox.get(_dateKey(date));
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<void> saveDailyStats(DateTime date, Map<String, dynamic> stats) async {
    await _dailyStatsBox.put(_dateKey(date), stats);
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
 