import 'package:flutter/material.dart';

import '../models/activity_type.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Selectable intensity chip for add activity screen.
class IntensityChip extends StatelessWidget {
  const IntensityChip({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final IntensityLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.orangeGradient : null,
          color: isSelected ? null : AppColors.secondaryCard,
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Text(
          level.label,
          style: AppTextStyles.caption(
            color: isSelected ? AppColors.textWhite : AppColors.subtitle,
          ).copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
        ),
      ),
    );
  }
}

/// Activity type grid item for selection.
class ActivityTypeTile extends StatelessWidget {
  const ActivityTypeTile({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? type.color.withValues(alpha: 0.2)
              : AppColors.secondaryCard,
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          border: Border.all(
            color: isSelected ? type.color : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type.icon,
              color: isSelected ? type.color : AppColors.subtitle,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              style: AppTextStyles.caption(
                color: isSelected ? type.color : AppColors.subtitle,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
