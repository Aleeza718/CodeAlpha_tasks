import 'package:flutter/material.dart';

class AppColors {
  // ===========================
  // PRIMARY COLORS
  // ===========================

  static const Color primary = Color(0xff8B6CFF);
  static const Color secondary = Color(0xffB38EFF);

  // ===========================
  // BACKGROUNDS
  // ===========================

  // Main app background
  static const Color background = Color(0xff17162B);

  // Cards & Containers
  static const Color surface = Color(0xff22213A);
  static const Color card = Color(0xff282645);

  // ===========================
  // TEXT COLORS
  // ===========================

  static const Color textDark = Colors.white;
  static const Color textLight = Color(0xffCFC9F7);

  // ===========================
  // EXTRA COLORS
  // ===========================

  static const Color accent = Color(0xffD7CCFF);

  static const Color border = Color(0xff3B3960);

  static const Color success = Color(0xff61D89C);

  static const Color grey = Color(0xff9D98C7);

  // ===========================
  // MAIN PURPLE GRADIENT
  // ===========================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffB38EFF),
      Color(0xff7A5AF8),
      Color(0xff352E70),
    ],
  );

  // ===========================
  // DARK CARD GRADIENT
  // ===========================

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff2C2952),
      Color(0xff17162B),
    ],
  );

  // ===========================
  // GLASS EFFECT
  // ===========================

  static Color glass = Colors.white.withOpacity(.08);

  // ===========================
  // SHADOW / GLOW
  // ===========================

  static const Color glow = Color(0xffB38EFF);
}