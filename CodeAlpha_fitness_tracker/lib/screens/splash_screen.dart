import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Premium Fitness Pro entry screen based on the supplied Figma reference.
///
/// The screen deliberately keeps all sizing relative to the available
/// viewport so it scales cleanly across Android phone sizes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    // The MainShell uses the normal Android system UI again.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B11),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final float = math.sin(t * math.pi * 2) * 4.0;
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final compact = height < 700;
              final iconSize = math.min(width * 0.17, 78.0);
              final centerY = height * (compact ? 0.405 : 0.40);

              return Stack(
                fit: StackFit.expand,
                children: [
                  const _GridBackground(),
                  CustomPaint(
                    painter: _RadarRingsPainter(
                      centerY: centerY,
                      accent: const Color(0xFF9E431F),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                      offset: Offset(0, centerY - iconSize * 0.53 + float),
                      child: _LogoIcon(size: iconSize),
                    ),
                  ),
                  Positioned(
                    top: centerY + iconSize * 0.63 + float,
                    left: 0,
                    right: 0,
                    child: const _BrandText(),
                  ),
                  Positioned(
                    top: height * 0.705,
                    left: 0,
                    right: 0,
                    child: _LoadingDots(progress: t),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _GridBackground extends StatelessWidget {
  const _GridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF111722).withValues(alpha: 0.62)
      ..strokeWidth = 0.6;

    final step = math.max(22.0, size.width * 0.062);
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RadarRingsPainter extends CustomPainter {
  const _RadarRingsPainter({required this.centerY, required this.accent});

  final double centerY;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, centerY);
    final base = math.min(size.width, size.height);
    final radii = <double>[base * 0.16, base * 0.255, base * 0.39];
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = accent.withValues(alpha: 0.30);

    for (final radius in radii) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarRingsPainter oldDelegate) =>
      oldDelegate.centerY != centerY;
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        color: const Color(0xFF202229).withValues(alpha: 0.94),
        border: Border.all(
          color: const Color(0xFFB3A59A).withValues(alpha: 0.42),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99FF6D35),
            blurRadius: 26,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color(0x55FF9A62),
            blurRadius: 9,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CustomPaint(painter: _PulseBarPainter()),
    );
  }
}

class _PulseBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final y = size.height * 0.53;
    final left = size.width * 0.19;
    final right = size.width * 0.81;
    final orange = const Color(0xFFFF7541);

    path.moveTo(left, y);
    path.lineTo(size.width * 0.34, y);
    path.lineTo(size.width * 0.40, size.height * 0.37);
    path.lineTo(size.width * 0.46, size.height * 0.66);
    path.lineTo(size.width * 0.52, y);
    path.lineTo(size.width * 0.59, y);

    final pulsePaint = Paint()
      ..color = orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, size.width * 0.025)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, pulsePaint);

    final barPaint = Paint()
      ..color = orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, size.width * 0.035)
      ..strokeCap = StrokeCap.round;

    final x1 = size.width * 0.66;
    final x2 = size.width * 0.73;
    final x3 = size.width * 0.78;
    canvas.drawLine(Offset(x1, size.height * 0.39), Offset(x1, size.height * 0.67), barPaint);
    canvas.drawLine(Offset(x2, size.height * 0.34), Offset(x2, size.height * 0.72), barPaint);
    canvas.drawLine(Offset(x3, size.height * 0.42), Offset(x3, size.height * 0.64), barPaint);
    canvas.drawLine(
      Offset(size.width * 0.61, y),
      Offset(size.width * 0.79, y),
      barPaint,
    );

    // Small glow around the mark keeps the logo close to the reference.
    final glow = Paint()
      ..color = orange.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(size.width * 0.55, y), size.width * 0.20, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandText extends StatelessWidget {
  const _BrandText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'Fitness Pro',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
            height: 1.0,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'TRACK • IMPROVE • ACHIEVE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFF8A52),
            fontSize: 7.4,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.55,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final phase = (progress - index * 0.05) % 1.0;
        final pulse = (math.sin(phase * math.pi * 2) + 1) / 2;
        final size = 4.5 + pulse * 2.0;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF7441).withValues(alpha: 0.55 + pulse * 0.45),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7441).withValues(alpha: 0.18 + pulse * 0.32),
                  blurRadius: 7,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}