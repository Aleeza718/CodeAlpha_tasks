import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';

/// Activity list item card for home and history screens.
class ActivityListCard extends StatelessWidget {
  const ActivityListCard({
    super.key,
    required this.activity,
    this.onTap,
  });

  final ActivityModel activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: activity.type.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  activity.type.icon,
                  color: activity.type.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.type.label,
                      style: AppTextStyles.bodyMedium(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppFormatters.formatTime(activity.date),
                      style: AppTextStyles.caption(),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${activity.calories} kcal',
                    style: AppTextStyles.bodyMedium(color: AppColors.orangeStart),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppFormatters.formatDuration(activity.durationMinutes),
                    style: AppTextStyles.caption(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
