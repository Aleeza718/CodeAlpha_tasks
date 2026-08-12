import 'package:flutter/material.dart';

/// Central color palette for the Fitness Pro dark theme.
abstract final class AppColors {
  // Base surfaces
  static const Color background = Color(0xFF0F1115);
  static const Color card = Color(0xFF1A1D24);
  static const Color secondaryCard = Color(0xFF22262F);
  static const Color border = Color(0xFF2C303A);

  // Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color subtitle = Color(0xFF9098A8);

  // Accent palette (shared with ActivityType colors)
  static const Color orangeStart = Color(0xFFFFA53D);
  static const Color orangeEnd = Color(0xFFF2546B);
  static const Color blue = Color(0xFF38BDF8);
  static const Color green = Color(0xFF22C55E);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color red = Color(0xFFF2546B);

  // Gradients
  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [orangeStart, orangeEnd],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A3D), Color(0xFFF2546B)],
  );
}
