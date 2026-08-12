/// Shared constants. Weekday label lists are computed relative to
/// "today" so they always line up with the last-7-actual-calendar-days
/// data windows produced by AppProvider (index 6 == today).
abstract final class AppConstants {
  static const _shortNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _fullNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Short weekday labels for the last 7 calendar days, oldest to newest.
  static List<String> get weekDays => _lastSevenLabels(_shortNames);

  /// Full weekday labels for the last 7 calendar days, oldest to newest.
  static List<String> get weekDayFull => _lastSevenLabels(_fullNames);

  /// Fixed Monday→Sunday short labels for the current calendar week
  /// (not a rolling window) — used by the Activity screen charts.
  static List<String> get calendarWeekDays => _shortNames;

  /// Fixed Monday→Sunday full labels for the current calendar week.
  static List<String> get calendarWeekDayFull => _fullNames;

  static List<String> _lastSevenLabels(List<String> names) {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return names[day.weekday - 1];
    });
  }
}
