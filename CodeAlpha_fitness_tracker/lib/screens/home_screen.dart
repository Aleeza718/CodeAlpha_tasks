import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../animations/scale_animation.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import '../widgets/activity_list_card.dart';
import '../widgets/chart_widgets.dart';
import '../widgets/hero_card.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/streak_card.dart';

/// Home dashboard with greeting, hero card, stats, and recent activities.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final stats = provider.dailyStats;
        final profile = provider.profile;
        final recent = provider.activities.take(4).toList();

        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: Responsive.screenPadding(context).copyWith(top: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Dynamic time-based greeting
                    Builder(
                      builder: (context) {
                        final hour = DateTime.now().hour;

                        String greeting;
                        String emoji;

                        if (hour >= 5 && hour < 12) {
                          greeting = 'Good Morning';
                          emoji = '🌞';
                        } else if (hour >= 12 && hour < 17) {
                          greeting = 'Good Afternoon';
                          emoji = '☀️';
                        } else if (hour >= 17 && hour < 21) {
                          greeting = 'Good Evening';
                          emoji = '🌆';
                        } else {
                          greeting = 'Good Night';
                          emoji = '🌙';
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting $emoji',
                              style: AppTextStyles.heading1(),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Keep going — every workout counts.',
                              style: AppTextStyles.caption(),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Hero card
                    AppearScaleAnimation(
                      child: HeroCard(
                        progress: stats.overallProgress,
                        calories: stats.calories,
                        caloriesGoal: stats.caloriesGoal,
                        userName: profile.name,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Stat cards grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: StatCard(
                                icon: Icons.local_fire_department,
                                label: 'Calories',
                                value: AppFormatters.formatCalories(
                                  stats.calories,
                                ),
                                color: AppColors.orangeStart,
                                subtitle:
                                    '${(stats.caloriesProgress * 100).toInt()}% of goal',
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: StatCard(
                                icon: Icons.directions_walk,
                                label: 'Steps',
                                value: AppFormatters.formatSteps(
                                  stats.steps,
                                ),
                                color: AppColors.green,
                                subtitle:
                                    '${(stats.stepsProgress * 100).toInt()}% of goal',
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: StatCard(
                                icon: Icons.fitness_center,
                                label: 'Workout',
                                value: AppFormatters.formatDuration(
                                  stats.workoutMinutes,
                                ),
                                color: AppColors.purple,
                                subtitle:
                                    '${(stats.workoutProgress * 100).toInt()}% of goal',
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - 12) / 2,
                              child: StatCard(
                                icon: Icons.water_drop,
                                label: 'Water',
                                value:
                                    '${stats.waterGlasses}/${stats.waterGoal}',
                                color: AppColors.blue,
                                subtitle: 'glasses today',
                                onTap: () => provider.addWaterGlass(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Overview cards
                    const SectionHeader(title: 'Overview'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OverviewCard(
                            icon: Icons.local_fire_department,
                            label: 'Calories',
                            value: AppFormatters.formatCalories(
                              stats.calories,
                            ),
                            progress: stats.caloriesProgress,
                            color: AppColors.orangeStart,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OverviewCard(
                            icon: Icons.directions_walk,
                            label: 'Steps',
                            value: AppFormatters.formatSteps(
                              stats.steps,
                            ),
                            progress: stats.stepsProgress,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Weekly chart
                    WeeklyBarChart(
                      title: 'Weekly Activity',
                      data: provider.weeklyCalories,
                      barColor: AppColors.orangeStart,
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Recent activities
                    SectionHeader(
                      title: 'Recent Activities',
                      actionLabel: 'See All',
                      onAction: () => provider.setNavIndex(2),
                    ),
                    const SizedBox(height: 12),

                    if (recent.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.cardRadius,
                          ),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_toggle_off,
                              color: AppColors.subtitle,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No activities logged yet',
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.subtitle,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...recent.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AppearScaleAnimation(
                            delay: Duration(
                              milliseconds: 100 * entry.key,
                            ),
                            child: ActivityListCard(
                              activity: entry.value,
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // Daily streak — real streak/best-streak/last-7-days
                    // data from AppProvider, no fabricated numbers.
                    StreakCard(
                      streakDays: profile.streakDays,
                      bestStreakDays: profile.bestStreakDays,
                      last7Days: provider.last7DaysActivity,
                    ),

                    // Small bottom breathing room.
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