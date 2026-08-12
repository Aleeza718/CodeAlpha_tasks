import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';

/// Picks a clean, human-friendly Y-axis scale for a given data max —
/// e.g. a max of ~240 becomes steps of 100 up to 300; a max of ~700
/// becomes steps of 200 up to 800. Never hardcoded: recomputed from
/// whatever the real weekly data actually is.
({double step, double top}) _niceAxisScale(double rawMax, {int targetTicks = 4}) {
  final max = rawMax <= 0 ? 100.0 : rawMax;
  final roughStep = max / targetTicks;
  final magnitude = math.pow(10, (math.log(roughStep) / math.ln10).floor()).toDouble();
  final normalized = roughStep / magnitude;
  final niceNormalized = normalized <= 1
      ? 1.0
      : normalized <= 2
          ? 2.0
          : normalized <= 5
              ? 5.0
              : 10.0;
  final step = niceNormalized * magnitude;
  final top = step * (max / step).ceil();
  return (step: step, top: top);
}

/// Animated weekly bar chart with gradient fill.
class WeeklyBarChart extends StatefulWidget {
  const WeeklyBarChart({
    super.key,
    required this.data,
    this.barColor = AppColors.orangeStart,
    this.height = 140,
    this.title,
    this.dayLabels,
  });

  /// Accepts num so callers can pass List<int> or List<double> safely;
  /// values are normalized to double once, at the chart boundary.
  final List<num> data;
  final Color barColor;
  final double height;
  final String? title;

  /// X-axis day labels. Defaults to [AppConstants.weekDays] (rolling
  /// last-7-days) when omitted, so existing callers are unaffected.
  final List<String>? dayLabels;

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data.map((e) => e.toDouble()).toList();
    final labels = widget.dayLabels ?? AppConstants.weekDays;
    final rawMax = data.isEmpty
        ? 0.0
        : data.reduce((a, b) => a > b ? a : b);
    final axis = _niceAxisScale(rawMax);
    final safeMaxY = axis.top;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(widget.title!, style: AppTextStyles.heading3()),
            const SizedBox(height: 10),
          ],
          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: safeMaxY,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => AppColors.secondaryCard,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.toInt().toString(),
                            AppTextStyles.caption(color: AppColors.textWhite),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.round();
                            if (index < 0 ||
                                index >= labels.length ||
                                (value - index).abs() > 0.01) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[index],
                                style: AppTextStyles.caption(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          reservedSize: 24,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: axis.step,
                          reservedSize: 34,
                          getTitlesWidget: (value, meta) {
                            if (value < 0) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                value.toInt().toString(),
                                style: AppTextStyles.caption(),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: axis.step,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.border.withValues(alpha: 0.5),
                        strokeWidth: 0.5,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(data.length, (index) {
                      final animatedY = data[index] * _animation.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: animatedY,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                widget.barColor.withValues(alpha: 0.4),
                                widget.barColor,
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Smooth curved line chart with gradient fill.
class SmoothLineChart extends StatefulWidget {
  const SmoothLineChart({
    super.key,
    required this.data,
    this.lineColor = AppColors.blue,
    this.height = 150,
    this.title,
    this.dayLabels,
  });

  /// Accepts num so callers can pass List<int> or List<double> safely;
  /// values are normalized to double once, at the chart boundary.
  final List<num> data;
  final Color lineColor;
  final double height;
  final String? title;

  /// X-axis day labels. Defaults to [AppConstants.weekDays] (rolling
  /// last-7-days) when omitted, so existing callers are unaffected.
  final List<String>? dayLabels;

  @override
  State<SmoothLineChart> createState() => _SmoothLineChartState();
}

class _SmoothLineChartState extends State<SmoothLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always render the card frame (with a flat zero line when there's
    // no data yet) rather than collapsing to nothing.
    final rawData = widget.data.isEmpty ? const [0.0, 0, 0, 0, 0, 0, 0] : widget.data;
    final labels = widget.dayLabels ?? AppConstants.weekDays;
    final data = rawData.map((e) => e.toDouble()).toList();
    final maxY = data.reduce((a, b) => a > b ? a : b) * 1.2;
    final safeMaxY = maxY < 10 ? 100.0 : maxY;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(widget.title!, style: AppTextStyles.heading3()),
            const SizedBox(height: 10),
          ],
          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final spots = List.generate(data.length, (i) {
                  return FlSpot(i.toDouble(), data[i] * _controller.value);
                });

                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (data.length - 1).toDouble(),
                    minY: 0,
                    maxY: safeMaxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: safeMaxY / 4,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.border.withValues(alpha: 0.5),
                        strokeWidth: 0.5,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.round();
                            if (index < 0 ||
                                index >= labels.length ||
                                (value - index).abs() > 0.01) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[index],
                                style: AppTextStyles.caption(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          reservedSize: 24,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: widget.lineColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: widget.lineColor,
                              strokeWidth: 2,
                              strokeColor: AppColors.card,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              widget.lineColor.withValues(alpha: 0.3),
                              widget.lineColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}