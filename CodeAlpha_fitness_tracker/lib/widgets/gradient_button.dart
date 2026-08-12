import 'package:flutter/material.dart';

import '../animations/scale_animation.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Primary gradient action button with ripple and scale.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ScaleAnimationWrapper(
      onTap: isLoading ? null : onPressed,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          splashColor: Colors.white24,
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              gradient: onPressed != null && !isLoading
                  ? AppColors.orangeGradient
                  : LinearGradient(
                      colors: [
                        AppColors.subtitle.withValues(alpha: 0.3),
                        AppColors.subtitle.withValues(alpha: 0.2),
                      ],
                    ),
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
              boxShadow: onPressed != null && !isLoading
                  ? [
                      BoxShadow(
                        color: AppColors.orangeStart.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textWhite,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: AppColors.textWhite, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.textWhite,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
