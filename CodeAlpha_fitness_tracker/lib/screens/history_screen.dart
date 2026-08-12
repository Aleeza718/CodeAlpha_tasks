import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../animations/page_transitions.dart';
import '../models/activity_type.dart';
import '../providers/app_provider.dart';
import '../screens/add_activity_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import '../widgets/activity_list_card.dart';

/// Workout history with search, filters, and swipe actions.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final grouped = provider.groupedActivities;
        final sortedKeys = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Responsive.screenPadding(context).copyWith(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('History', style: AppTextStyles.heading1()),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.filteredActivities.length} activities',
                      style: AppTextStyles.caption(),
                    ),
                    const SizedBox(height: 16),

                    // Search
                    TextField(
                      onChanged: provider.setSearchQuery,
                      style: AppTextStyles.body(),
                      decoration: InputDecoration(
                        hintText: 'Search activities...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.subtitle),
                        suffixIcon: provider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () => provider.setSearchQuery(''),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter chips
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(
                            label: 'All',
                            isSelected: provider.filterType == null,
                            onTap: () => provider.setFilterType(null),
                          ),
                          ...ActivityType.values.map((type) {
                            return _FilterChip(
                              label: type.label,
                              isSelected: provider.filterType == type,
                              color: type.color,
                              onTap: () => provider.setFilterType(
                                provider.filterType == type ? null : type,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: sortedKeys.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: 48,
                              color: AppColors.subtitle.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No activities found',
                              style: AppTextStyles.caption(),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: Responsive.screenPadding(context),
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, groupIndex) {
                          final key = sortedKeys[groupIndex];
                          final activities = grouped[key]!;
                          final date = activities.first.date;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  AppFormatters.formatGroupDate(date),
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.orangeStart,
                                  ),
                                ),
                              ),
                              ...activities.map((activity) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Slidable(
                                    key: ValueKey(activity.id),
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (_) async {
                                            await Navigator.of(context).push(
                                              FadeSlidePageRoute(
                                                page: AddActivityScreen(
                                                  editActivity: activity,
                                                ),
                                              ),
                                            );
                                          },
                                          backgroundColor: AppColors.blue,
                                          foregroundColor: AppColors.textWhite,
                                          icon: Icons.edit,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.inputRadius,
                                          ),
                                        ),
                                        SlidableAction(
                                          onPressed: (_) async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                backgroundColor: AppColors.card,
                                                title: Text(
                                                  'Delete Activity',
                                                  style: AppTextStyles.heading3(),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete this activity?',
                                                  style: AppTextStyles.body(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(ctx, false),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(ctx, true),
                                                    child: Text(
                                                      'Delete',
                                                      style: AppTextStyles.body(
                                                        color: AppColors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              await provider.deleteActivity(activity.id);
                                            }
                                          },
                                          backgroundColor: AppColors.red,
                                          foregroundColor: AppColors.textWhite,
                                          icon: Icons.delete,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.inputRadius,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: ActivityListCard(activity: activity),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (color ?? AppColors.orangeStart).withValues(alpha: 0.2)
                : AppColors.secondaryCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? (color ?? AppColors.orangeStart)
                  : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption(
              color: isSelected
                  ? (color ?? AppColors.orangeStart)
                  : AppColors.subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
