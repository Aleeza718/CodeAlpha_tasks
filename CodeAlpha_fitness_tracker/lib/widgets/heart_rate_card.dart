import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'stat_card.dart';

/// Heart-rate tile for the Activity screen's statistics grid.
///
/// Delegates to [StatCard] so its size, padding, border radius, and
/// spacing are always pixel-identical to the Weekly Calories, Active
/// Minutes, and Workouts cards next to it — there is no separate
/// layout to drift out of sync.
///
/// There is currently no heart-rate sensor, smartwatch, or Health
/// Connect integration, so this never fabricates a value. It shows a
/// real BPM only when [heartRate] is a genuine measurement (> 0).
/// FUTURE INTEGRATION: once a real source (Health Connect, a paired
/// wearable, etc.) is wired up, feed its reading into [heartRate] —
/// this widget will automatically switch from "Not available" to the
/// live BPM with no other changes needed.
class HeartRateCard extends StatelessWidget {
  const HeartRateCard({
    super.key,
    required this.heartRate,
  });

  /// A real measured BPM value, or null/<=0 if no reading exists yet.
  final int? heartRate;

  bool get _hasData => heartRate != null && heartRate! > 0;

  @override
  Widget build(BuildContext context) {
    return StatCard(
      icon: Icons.favorite,
      label: 'Heart Rate',
      value: _hasData ? '$heartRate BPM' : '-- BPM',
      color: AppColors.red,
      subtitle: _hasData ? null : 'Not available',
    );
  }
}

/// Timeline item for activity screen.
class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isLast = false,
  });

  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: AppTextStyles.caption()),
                  const SizedBox(height: 4),
                  Text(title, style: AppTextStyles.bodyMedium()),
                  Text(subtitle, style: AppTextStyles.caption()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
