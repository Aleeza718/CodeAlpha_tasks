/// User profile and body metrics.
///
/// heightCm/weightKg are nullable: null means the user has never
/// entered a real value. Callers must never substitute a fake
/// default — an unset value must be displayed as an empty state.
class UserProfileModel {
  UserProfileModel({
    this.name = '',
    this.email = '',
    this.avatarUrl = '',
    this.heightCm,
    this.weightKg,
    this.age = 0,
    this.streakDays = 0,
    this.bestStreakDays = 0,
    this.totalWorkouts = 0,
    this.achievements = const [],
  });

  String name;
  String email;
  String avatarUrl;
  double? heightCm;
  double? weightKg;
  int age;
  int streakDays;

  /// Longest consecutive-day streak ever reached, kept in sync
  /// alongside [streakDays] (see AppProvider._syncProfileStats) —
  /// never a guessed/fabricated value.
  int bestStreakDays;
  int totalWorkouts;
  List<String> achievements;

  /// Only defined when both height and weight are real saved values.
  double? get bmi {
    final h = heightCm;
    final w = weightKg;
    if (h == null || w == null || h <= 0 || w <= 0) return null;
    return w / ((h / 100) * (h / 100));
  }

  /// Only defined when [bmi] is defined.
  String? get bmiCategory {
    final value = bmi;
    if (value == null) return null;
    if (value < 18.5) return 'Underweight';
    if (value < 25) return 'Normal';
    if (value < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'age': age,
        'streakDays': streakDays,
        'bestStreakDays': bestStreakDays,
        'totalWorkouts': totalWorkouts,
        'achievements': achievements,
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      age: json['age'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      bestStreakDays: json['bestStreakDays'] as int? ?? 0,
      totalWorkouts: json['totalWorkouts'] as int? ?? 0,
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}