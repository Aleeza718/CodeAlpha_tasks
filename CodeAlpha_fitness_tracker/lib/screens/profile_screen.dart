import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../animations/page_transitions.dart';
import '../providers/app_provider.dart';
import '../screens/body_details_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import '../widgets/profile_widgets.dart';
import '../widgets/progress_ring.dart';

/// User profile with achievements, BMI, goals, and settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final profile = provider.profile;
        final goals = provider.goals;
        final settings = provider.settings;
        final bmi = profile.bmi; // null when height/weight not set
        final hasWeight = profile.weightKg != null && profile.weightKg! > 0;
        // Progress toward the target-weight goal is only meaningful if we
        // have a real current weight to compare against.
        final goalProgress = hasWeight
            ? (profile.weightKg! / goals.targetWeight).clamp(0.0, 1.0)
            : 0.0;
        final achievements = provider.earnedAchievements;

        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: Responsive.screenPadding(context).copyWith(top: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ProfileHeader(
                      name: profile.name,
                      email: profile.email,
                      streakDays: profile.streakDays,
                      totalWorkouts: profile.totalWorkouts,
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // BMI Card — only shows real numbers when the user has
                    // actually entered height and weight. Tapping it opens
                    // Body Details to add/edit those values.
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                        onTap: () => Navigator.of(context).push(
                          FadeSlidePageRoute(page: const BodyDetailsScreen()),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimensions.cardPadding),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: bmi != null
                              ? Row(
                                  children: [
                                    ProgressRing(
                                      progress: (bmi / 30).clamp(0.0, 1.0),
                                      size: 80,
                                      strokeWidth: 6,
                                      centerValue: AppFormatters.formatBmi(bmi),
                                      centerLabel: 'BMI',
                                      gradient: const LinearGradient(
                                        colors: [AppColors.green, AppColors.blue],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Body Mass Index', style: AppTextStyles.heading3()),
                                              Icon(Icons.edit, size: 16, color: AppColors.subtitle),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            profile.bmiCategory!,
                                            style: AppTextStyles.bodyMedium(color: AppColors.green),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Height: ${AppFormatters.formatHeight(profile.heightCm!, settings.unitsMetric)}'
                                            ' · Weight: ${AppFormatters.formatWeight(profile.weightKg!, settings.unitsMetric)}',
                                            style: AppTextStyles.caption(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppColors.border.withValues(alpha: 0.4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.monitor_weight_outlined,
                                        color: AppColors.subtitle,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Body Mass Index', style: AppTextStyles.heading3()),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Add your height and weight to calculate BMI.',
                                            style: AppTextStyles.caption(),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Add details',
                                                style: AppTextStyles.bodyMedium(color: AppColors.orangeStart)
                                                    .copyWith(fontWeight: FontWeight.w600),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: AppColors.orangeStart,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Goal Progress — these are saved GOALS/targets, not
                    // claims about what the user has already achieved.
                    Text('Goal Progress', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.cardPadding),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _GoalRow(
                            label: 'Target Weight',
                            value: AppFormatters.formatWeight(
                              goals.targetWeight,
                              settings.unitsMetric,
                            ),
                            progress: goalProgress,
                            color: AppColors.purple,
                          ),
                          const Divider(height: 24),
                          _GoalRow(
                            label: 'Daily Steps',
                            value: '${goals.dailySteps}',
                            progress: provider.dailyStats.stepsProgress,
                            color: AppColors.green,
                          ),
                          const Divider(height: 24),
                          _GoalRow(
                            label: 'Weekly Workouts',
                            value: '${provider.weeklyWorkoutCount}/${goals.weeklyWorkouts}',
                            progress: goals.weeklyWorkouts > 0
                                ? provider.weeklyWorkoutCount / goals.weeklyWorkouts
                                : 0.0,
                            color: AppColors.orangeStart,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Achievements — computed live from real activity
                    // history (see AppProvider.earnedAchievements).
                    Text('Achievements', style: AppTextStyles.heading3()),
                    const SizedBox(height: 12),
                    if (achievements.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Log your first activity to start earning achievements.',
                          style: AppTextStyles.caption(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: achievements.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final icons = [
                              Icons.emoji_events,
                              Icons.local_fire_department,
                              Icons.directions_walk,
                              Icons.wb_sunny,
                              Icons.military_tech,
                            ];
                            final colors = [
                              AppColors.orangeStart,
                              AppColors.red,
                              AppColors.green,
                              AppColors.blue,
                              AppColors.purple,
                            ];
                            return AchievementBadge(
                              title: achievements[index],
                              icon: icons[index % icons.length],
                              color: colors[index % colors.length],
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Settings — only real, working settings. Dark Theme,
                    // Notifications, and Logout were removed: there is no
                    // theme switching, no notification/reminder system,
                    // and no authentication in this app.
                    Text('Settings', style: AppTextStyles.heading3()),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          SettingsTile(
                            icon: Icons.monitor_weight_outlined,
                            title: 'Body Details',
                            subtitle: bmi != null
                                ? '${AppFormatters.formatHeight(profile.heightCm!, settings.unitsMetric)}'
                                    ' · ${AppFormatters.formatWeight(profile.weightKg!, settings.unitsMetric)}'
                                : 'Add your height & weight',
                            iconColor: AppColors.red,
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: AppColors.subtitle,
                            ),
                            onTap: () => Navigator.of(context).push(
                              FadeSlidePageRoute(page: const BodyDetailsScreen()),
                            ),
                          ),
                          const Divider(height: 1),
                          SettingsTile(
                            icon: Icons.straighten,
                            title: 'Units',
                            subtitle: settings.unitsMetric
                                ? 'Metric (km, kg)'
                                : 'Imperial (mi, lb)',
                            iconColor: AppColors.green,
                            trailing: Switch.adaptive(
                              value: settings.unitsMetric,
                              activeTrackColor: AppColors.orangeStart,
                              onChanged: (v) {
                                settings.unitsMetric = v;
                                provider.updateSettings(settings);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium()),
            Text(value, style: AppTextStyles.caption(color: color)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}