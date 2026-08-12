import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/activity_model.dart';
import '../models/activity_type.dart';
import '../models/daily_stats_model.dart';
import '../models/goals_model.dart';
import '../models/settings_model.dart';
import '../models/user_profile_model.dart';
import '../models/water_model.dart';
import '../services/data_seed_service.dart';
import '../services/hive_service.dart';

/// Central app state provider managing all fitness data.
class AppProvider extends ChangeNotifier {
  AppProvider(this._hive);

  final HiveService _hive;
  static const _uuid = Uuid();

  bool _isLoading = true;
  List<ActivityModel> _activities = [];
  DailyStatsModel _dailyStats = DailyStatsModel();
  GoalsModel _goals = GoalsModel();
  SettingsModel _settings = SettingsModel();
  UserProfileModel _profile = UserProfileModel();
  WaterModel? _todayWater;
  int _currentNavIndex = 0;
  String _searchQuery = '';
  ActivityType? _filterType;

  bool get isLoading => _isLoading;
  List<ActivityModel> get activities => _activities;
  DailyStatsModel get dailyStats => _dailyStats;
  GoalsModel get goals => _goals;
  SettingsModel get settings => _settings;
  UserProfileModel get profile => _profile;
  WaterModel? get todayWater => _todayWater;
  int get currentNavIndex => _currentNavIndex;
  String get searchQuery => _searchQuery;
  ActivityType? get filterType => _filterType;

  List<ActivityModel> get filteredActivities {
    var list = _activities;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((a) =>
              a.type.label.toLowerCase().contains(q) ||
              a.notes.toLowerCase().contains(q))
          .toList();
    }
    if (_filterType != null) {
      list = list.where((a) => a.type == _filterType).toList();
    }
    return list;
  }

  Map<String, List<ActivityModel>> get groupedActivities {
    final map = <String, List<ActivityModel>>{};
    for (final activity in filteredActivities) {
      final key = _dateKey(activity.date);
      map.putIfAbsent(key, () => []).add(activity);
    }
    return map;
  }

  /// Weekly chart data: calories per day for last 7 days.
  List<double> get weeklyCalories {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return _activities
          .where((a) =>
              a.date.year == day.year &&
              a.date.month == day.month &&
              a.date.day == day.day)
          .fold<double>(0, (sum, a) => sum + a.calories);
    });
  }

  /// Weekly steps approximation from activities.
  List<double> get weeklyActivityMinutes {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return _activities
          .where((a) =>
              a.date.year == day.year &&
              a.date.month == day.month &&
              a.date.day == day.day)
          .fold<double>(0, (sum, a) => sum + a.durationMinutes);
    });
  }

  /// Calories per day for the current calendar week, Monday→Sunday
  /// (fixed week, not a rolling 7-day window). Used by the Activity
  /// screen so its chart labels line up with Monday…Sunday.
  List<double> get weeklyCaloriesCalendarWeek {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (i) {
      final day = weekStart.add(Duration(days: i));
      return _activities
          .where((a) =>
              a.date.year == day.year &&
              a.date.month == day.month &&
              a.date.day == day.day)
          .fold<double>(0, (sum, a) => sum + a.calories);
    });
  }

  /// Active minutes per day for the current calendar week, Monday→Sunday.
  List<double> get weeklyActivityMinutesCalendarWeek {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (i) {
      final day = weekStart.add(Duration(days: i));
      return _activities
          .where((a) =>
              a.date.year == day.year &&
              a.date.month == day.month &&
              a.date.day == day.day)
          .fold<double>(0, (sum, a) => sum + a.durationMinutes);
    });
  }

  int get weeklyWorkoutCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    return _activities
        .where((a) => !a.date.isBefore(weekStart))
        .length;
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final seedService = DataSeedService(_hive);
    await seedService.seedIfEmpty();

    _activities = _hive.getActivities();
    _goals = _hive.getGoals();
    _settings = _hive.getSettings();
    _profile = _hive.getProfile();
    _todayWater = _hive.getWaterForDate(DateTime.now());
    _dailyStats = seedService.loadDailyStats();

    // Keep totalWorkouts/streak accurate even if they drifted from the
    // real activity history (e.g. after a restore), without spamming
    // Hive writes when nothing actually changed.
    final realTotal = _activities.length;
    final realStreak = _calculateStreak();
    final realBest = realStreak > _profile.bestStreakDays ? realStreak : _profile.bestStreakDays;
    if (_profile.totalWorkouts != realTotal ||
        _profile.streakDays != realStreak ||
        _profile.bestStreakDays != realBest) {
      _profile.totalWorkouts = realTotal;
      _profile.streakDays = realStreak;
      _profile.bestStreakDays = realBest;
      await _hive.saveProfile(_profile);
    }

    _isLoading = false;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterType(ActivityType? type) {
    _filterType = type;
    notifyListeners();
  }

  Future<void> addActivity(ActivityModel activity) async {
    await _hive.saveActivity(activity);
    _activities = _hive.getActivities();
    _updateDailyStatsFromActivities();
    await _syncProfileStats();
    notifyListeners();
  }

  Future<void> updateActivity(ActivityModel activity) async {
    await _hive.saveActivity(activity);
    _activities = _hive.getActivities();
    _updateDailyStatsFromActivities();
    await _syncProfileStats();
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    await _hive.deleteActivity(id);
    _activities = _hive.getActivities();
    _updateDailyStatsFromActivities();
    await _syncProfileStats();
    notifyListeners();
  }

  /// Recomputes totalWorkouts and the current streak from the real
  /// activity history (never from a hand-incremented counter) and
  /// persists the result so the Profile screen reflects real data.
  /// Also keeps the all-time best streak in sync — it only ever moves
  /// up to match a new real high, never guessed or reset by hand.
  Future<void> _syncProfileStats() async {
    _profile.totalWorkouts = _activities.length;
    _profile.streakDays = _calculateStreak();
    if (_profile.streakDays > _profile.bestStreakDays) {
      _profile.bestStreakDays = _profile.streakDays;
    }
    await _hive.saveProfile(_profile);
  }

  /// Consecutive-day streak ending today (or yesterday, if today has no
  /// activity yet but yesterday's streak is still "live").
  int _calculateStreak() {
    if (_activities.isEmpty) return 0;

    final activeDays = _activities
        .map((a) => DateTime(a.date.year, a.date.month, a.date.day))
        .toSet();

    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month, now.day);

    if (!activeDays.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      if (!activeDays.contains(cursor)) return 0;
    }

    var streak = 0;
    while (activeDays.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Which of the last 7 calendar days (oldest to newest, ending
  /// today) have a real logged activity — powers the streak card's
  /// dot row with real Hive data instead of a decorative placeholder.
  List<bool> get last7DaysActivity {
    final activeDays = _activities
        .map((a) => DateTime(a.date.year, a.date.month, a.date.day))
        .toSet();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      return activeDays.contains(day);
    });
  }

  Future<void> addWaterGlass() async {
    final now = DateTime.now();
    _todayWater ??= WaterModel(
      date: now,
      glasses: 0,
      goalGlasses: _goals.dailyWaterGlasses,
    );
    _todayWater!.glasses++;
    _dailyStats.waterGlasses = _todayWater!.glasses;
    await _hive.saveWater(_todayWater!);
    await _saveDailyStats();
    notifyListeners();
  }

  Future<void> updateSettings(SettingsModel settings) async {
    _settings = settings;
    await _hive.saveSettings(settings);
    notifyListeners();
  }

  /// Persists height/weight (and any other profile field) edits made
  /// on the Body Details screen using the same profile box that
  /// already stores name/streak/achievements — no separate storage.
  Future<void> updateProfile(UserProfileModel profile) async {
    _profile = profile;
    await _hive.saveProfile(profile);
    notifyListeners();
  }

  void _updateDailyStatsFromActivities() {
    final now = DateTime.now();
    final todayActivities = _activities.where((a) =>
        a.date.year == now.year &&
        a.date.month == now.month &&
        a.date.day == now.day);

    _dailyStats.calories =
        todayActivities.fold(0, (sum, a) => sum + a.calories);
    _dailyStats.workoutMinutes =
        todayActivities.fold(0, (sum, a) => sum + a.durationMinutes);
    _saveDailyStats();
  }

  Future<void> _saveDailyStats() async {
    await _hive.saveDailyStats(DateTime.now(), {
      'calories': _dailyStats.calories,
      'caloriesGoal': _dailyStats.caloriesGoal,
      'steps': _dailyStats.steps,
      'stepsGoal': _dailyStats.stepsGoal,
      'workoutMinutes': _dailyStats.workoutMinutes,
      'workoutGoal': _dailyStats.workoutGoal,
      'waterGlasses': _dailyStats.waterGlasses,
      'waterGoal': _dailyStats.waterGoal,
      'heartRate': _dailyStats.heartRate,
    });
  }

  /// Real achievements derived from actual activity history — never
  /// a hardcoded/seeded list. Recomputed on demand from _activities.
  List<String> get earnedAchievements {
    if (_activities.isEmpty) return [];
    final result = <String>[];

    result.add('First Workout');
    if (_activities.length >= 10) result.add('10 Workouts');
    if (_calculateStreak() >= 7) result.add('7 Day Streak');
    if (_activities.any((a) => a.date.hour < 7)) result.add('Early Bird');

    final totalCalories = _activities.fold<int>(0, (sum, a) => sum + a.calories);
    if (totalCalories >= 5000) result.add('5K Calories Burned');

    return result;
  }

  String createActivityId() => _uuid.v4();

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}