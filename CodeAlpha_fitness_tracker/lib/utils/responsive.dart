import 'package:flutter/material.dart';

/// Small helpers so screens adapt across common phone widths
/// (360 / 375 / 393 / 412 dp) without hardcoding pixel values.
abstract final class Responsive {
  static double _width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static EdgeInsets screenPadding(BuildContext context) {
    final width = _width(context);
    final horizontal = width < 360 ? 12.0 : (width >= 600 ? 24.0 : 16.0);
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  static int gridCrossAxisCount(BuildContext context) {
    final width = _width(context);
    if (width >= 600) return 5;
    if (width >= 400) return 4;
    return 3;
  }
}
