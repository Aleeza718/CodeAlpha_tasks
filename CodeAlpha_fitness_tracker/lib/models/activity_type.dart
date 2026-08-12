import 'package:flutter/material.dart';

/// Available activity types for the fitness tracker.
enum ActivityType {
  running('Running', Icons.directions_run, 0xFF38BDF8),
  cycling('Cycling', Icons.directions_bike, 0xFF22C55E),
  swimming('Swimming', Icons.pool, 0xFF8B5CF6),
  walking('Walking', Icons.directions_walk, 0xFFFFA53D),
  gym('Gym', Icons.fitness_center, 0xFFF2546B),
  yoga('Yoga', Icons.self_improvement, 0xFF22C55E),
  hiking('Hiking', Icons.terrain, 0xFF38BDF8),
  dancing('Dancing', Icons.music_note, 0xFF8B5CF6);

  const ActivityType(this.label, this.icon, this.colorValue);

  final String label;
  final IconData icon;
  final int colorValue;

  Color get color => Color(colorValue);
}

/// Intensity levels for workouts.
enum IntensityLevel {
  low('Low', 0.7),
  moderate('Moderate', 1.0),
  high('High', 1.4),
  extreme('Extreme', 1.8);

  const IntensityLevel(this.label, this.multiplier);

  final String label;
  final double multiplier;
}
