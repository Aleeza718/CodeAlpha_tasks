import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Central text style factory. Every method accepts an optional color
/// override so callers can tint text (e.g. AppTextStyles.bodyMedium(color: AppColors.green)).
abstract final class AppTextStyles {
  static TextStyle heading1({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.5,
    );
  }

  static TextStyle heading2({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.3,
    );
  }

  static TextStyle heading3({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle body({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle bodyMedium({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle caption({Color color = AppColors.subtitle}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle statValue({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.3,
    );
  }

  static TextStyle statLabel({Color color = AppColors.subtitle}) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}
