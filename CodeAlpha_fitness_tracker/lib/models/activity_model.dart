import 'activity_type.dart';

/// Represents a single fitness activity entry.
class ActivityModel {
  ActivityModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.intensity,
    required this.calories,
    required this.distanceKm,
    required this.date,
    this.notes = '',
  });

  final String id;
  final ActivityType type;
  final int durationMinutes;
  final IntensityLevel intensity;
  final int calories;
  final double distanceKm;
  final DateTime date;
  final String notes;

  ActivityModel copyWith({
    String? id,
    ActivityType? type,
    int? durationMinutes,
    IntensityLevel? intensity,
    int? calories,
    double? distanceKm,
    DateTime? date,
    String? notes,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      calories: calories ?? this.calories,
      distanceKm: distanceKm ?? this.distanceKm,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'durationMinutes': durationMinutes,
        'intensity': intensity.name,
        'calories': calories,
        'distanceKm': distanceKm,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.running,
      ),
      durationMinutes: json['durationMinutes'] as int,
      intensity: IntensityLevel.values.firstWhere(
        (e) => e.name == json['intensity'],
        orElse: () => IntensityLevel.moderate,
      ),
      calories: json['calories'] as int,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }
}
