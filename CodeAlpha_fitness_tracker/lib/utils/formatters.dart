/// Shared display-formatting helpers. No external dependencies —
/// keeps pubspec.yaml unchanged beyond what the app already needs.
abstract final class AppFormatters {
  static const _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String formatCalories(int calories) {
    if (calories >= 1000) {
      return '${(calories / 1000).toStringAsFixed(1)}k';
    }
    return '$calories';
  }

  static String formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return '$steps';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    if (remaining == 0) return '${hours}h';
    return '${hours}h ${remaining}m';
  }

  static String formatDistance(double km, [bool metric = true]) {
    if (km <= 0) return metric ? '0 km' : '0 mi';
    if (metric) return '${km.toStringAsFixed(1)} km';
    final miles = km * 0.621371;
    return '${miles.toStringAsFixed(1)} mi';
  }

  static String formatWeight(double kg, bool metric) {
    if (metric) return '${kg.toStringAsFixed(kg.truncateToDouble() == kg ? 0 : 1)} kg';
    final lb = kg * 2.20462;
    return '${lb.toStringAsFixed(lb.truncateToDouble() == lb ? 0 : 1)} lb';
  }

  /// Formats a height stored internally as centimeters into the
  /// active unit system: "170 cm" (metric) or "5'7\"" (imperial).
  static String formatHeight(double cm, bool metric) {
    if (cm <= 0) return '—';
    if (metric) {
      return '${cm.toStringAsFixed(cm.truncateToDouble() == cm ? 0 : 1)} cm';
    }
    final totalInches = cm / 2.54;
    var feet = totalInches ~/ 12;
    var inches = (totalInches - feet * 12).round();
    if (inches == 12) {
      feet += 1;
      inches = 0;
    }
    return "$feet'$inches\"";
  }

  static String formatBmi(double bmi) {
    if (bmi.isNaN || bmi.isInfinite) return '--';
    return bmi.toStringAsFixed(1);
  }

  static String formatTime(DateTime date) {
    final hour24 = date.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    var hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }

  static String formatGroupDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7 && diff > 0) return _weekdayNames[date.weekday - 1];
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) return 'Good night';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 21) return 'Good evening';
    return 'Good night';
  }
}
