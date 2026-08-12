import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Daily streak highlight card for the Home screen.
///
/// Every number here comes from real activity history via
/// AppProvider (current streak, all-time best streak, and which of
/// the last 7 days had a logged activity) — nothing is fabricated,
/// and the "RECORD" badge only appears when the current streak is
/// genuinely at (or tying) the all-time best.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streakDays,
    required this.bestStreakDays,
    required this.last7Days,
  });

  final int streakDays;
  final int bestStreakDays;

  /// Oldest to newest, ending today.
  final List<bool> last7Days;

  String get _subtitle {
    if (streakDays == 0) return 'Start today to build your streak';
    if (streakDays >= bestStreakDays) return 'Personal best! Keep it going';
    return 'Best streak: $bestStreakDays days';
  }

  bool get _isRecord => streakDays > 0 && streakDays >= bestStreakDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeStart.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('\u{1F525}', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      'Daily Streak',
                      style: AppTextStyles.bodyMedium(color: AppColors.textWhite)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '$streakDays Days',
                  style: AppTextStyles.heading1(color: AppColors.textWhite),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle,
                  style: AppTextStyles.caption(color: AppColors.textWhite)
                      .copyWith(color: AppColors.textWhite.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: last7Days.map((active) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.textWhite.withValues(
                            alpha: active ? 0.95 : 0.3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (_isRecord) ...[
            const SizedBox(width: 12),
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: AppColors.textWhite,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'RECORD',
                  style: AppTextStyles.caption(color: AppColors.textWhite)
                      .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}