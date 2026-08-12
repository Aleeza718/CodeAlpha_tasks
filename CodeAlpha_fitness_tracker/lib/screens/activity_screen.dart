import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import '../widgets/chart_widgets.dart';
import '../widgets/heart_rate_card.dart';
import '../widgets/stat_card.dart';

/// Activity statistics screen with charts and timeline.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final stats = provider.dailyStats;
        // Fixed Monday→Sunday calendar week, so the top stat cards and
        // the charts below always agree with the same date range.
        final weeklyCalories = provider.weeklyCaloriesCalendarWeek;
        final weeklyMinutes = provider.weeklyActivityMinutesCalendarWeek;
        final totalCalories = weeklyCalories.fold<double>(0, (a, b) => a + b);
        final totalMinutes = weeklyMinutes.fold<double>(0, (a, b) => a + b);

        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: Responsive.screenPadding(context).copyWith(top: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text('Activity', style: AppTextStyles.heading1()),
                    const SizedBox(height: 4),
                    Text(
                      'Your fitness statistics',
                      style: AppTextStyles.caption(),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Top statistics: 2×2 grid. Heart Rate lives in the
                    // grid as a StatCard-identical tile (via
                    // HeartRateCard), so all four cards share the same
                    // size, padding, radius, and spacing automatically.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.local_fire_department,
                            label: 'Weekly Calories',
                            value: AppFormatters.formatCalories(totalCalories.toInt()),
                            color: AppColors.orangeStart,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.timer,
                            label: 'Active Minutes',
                            value: AppFormatters.formatDuration(totalMinutes.toInt()),
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.fitness_center,
                            label: 'Workouts',
                            value: '${provider.weeklyWorkoutCount}',
                            color: AppColors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // No wearable/sensor/Health Connect integration
                        // exists yet, so this honestly shows "Not
                        // available" instead of a fabricated BPM.
                        Expanded(
                          child: HeartRateCard(heartRate: stats.heartRate),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Weekly chart
                    WeeklyBarChart(
                      title: 'Weekly Calories',
                      data: weeklyCalories,
                      barColor: AppColors.orangeStart,
                      dayLabels: AppConstants.calendarWeekDays,
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Line chart
                    SmoothLineChart(
                      title: 'Active Minutes',
                      data: weeklyMinutes,
                      lineColor: AppColors.blue,
                      dayLabels: AppConstants.calendarWeekDays,
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Timeline
                    Text('Today\'s Timeline', style: AppTextStyles.heading3()),
                    const SizedBox(height: 16),
                    ..._buildTimeline(provider),
                    // Small breathing-room gap only — the bottom nav's
                    // full height is now already reserved automatically
                    // by Scaffold (see MainShell's extendBody: false),
                    // so a large manual buffer here would just leave a
                    // big empty gap before the nav, as it did before.
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildTimeline(AppProvider provider) {
    final todayActivities = provider.activities
        .where((a) {
          final now = DateTime.now();
          return a.date.year == now.year &&
              a.date.month == now.month &&
              a.date.day == now.day;
        })
        .toList();

    if (todayActivities.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              'No activities today yet.\nTap + to add one!',
              style: AppTextStyles.caption(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
    }

    return todayActivities.asMap().entries.map((entry) {
      final activity = entry.value;
      final isLast = entry.key == todayActivities.length - 1;
      return TimelineItem(
        time: AppFormatters.formatTime(activity.date),
        title: activity.type.label,
        subtitle:
            '${activity.calories} kcal · ${AppFormatters.formatDuration(activity.durationMinutes)}',
        icon: activity.type.icon,
        color: activity.type.color,
        isLast: isLast,
      );
    }).toList();
  }
}