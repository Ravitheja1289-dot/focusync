import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/focus_charts.dart';

/// Focus analytics and history screen
///
/// Design principles:
/// - Meaningful metrics only (no vanity stats)
/// - Actionable insights
/// - Simple, scannable layout
/// - Focus on quality over quantity
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from analytics provider
    final todayMinutes = 45;
    final weekTotal = 180;
    final currentStreak = 3;
    final bestStreak = 7;
    final weeklyData = [30, 45, 60, 40, 50, 35, 45]; // Mon-Sun
    final qualityScores = [0.9, 0.85, 0.95, 0.8, 0.88, 0.92, 0.87];
    final avgQuality =
        qualityScores.reduce((a, b) => a + b) / qualityScores.length;

    return Scaffold(
      backgroundColor: AppColors.slate950,
      appBar: AppBar(
        title: const Text('Focus Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Summary
              _buildSectionHeader('Today'),
              AppSpacing.gapMd,
              _buildTodayCard(todayMinutes),

              AppSpacing.gapXl,
              AppSpacing.gapLg,

              // This Week
              _buildSectionHeader('This Week'),
              AppSpacing.gapMd,
              _buildWeekCard(weekTotal, weeklyData),

              AppSpacing.gapXl,
              AppSpacing.gapLg,

              // Focus Quality
              _buildSectionHeader('Focus Quality'),
              AppSpacing.gapMd,
              _buildQualityCard(avgQuality, qualityScores),

              AppSpacing.gapXl,
              AppSpacing.gapLg,

              // Streaks
              _buildSectionHeader('Consistency'),
              AppSpacing.gapMd,
              _buildStreakCard(currentStreak, bestStreak),

              AppSpacing.gapXl,
              AppSpacing.gapLg,

              // Insights
              _buildSectionHeader('Insights'),
              AppSpacing.gapMd,
              _buildInsightsCard(weeklyData, avgQuality),

              AppSpacing.gapXl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.gray50,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTodayCard(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final displayText = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today_outlined, size: 20, color: AppColors.gray400),
              AppSpacing.gapSm,
              Text(
                'Focus Time',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Text(
            displayText,
            style: TextStyle(
              fontFamily: AppTextStyles.displayFont,
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.indigo400,
              height: 1.1,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            minutes == 0
                ? 'Start your first session today'
                : minutes < 30
                ? 'Off to a good start'
                : minutes < 60
                ? 'Building momentum'
                : 'Great focus day!',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCard(int totalMinutes, List<int> weeklyData) {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    final avgPerDay = (totalMinutes / 7).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    hours > 0 ? '${hours}h ${mins}m' : '${mins}m',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.white,
                      fontFamily: AppTextStyles.displayFont,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Daily Avg',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    '${avgPerDay}m',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.gray300,
                      fontFamily: AppTextStyles.displayFont,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapLg,
          WeeklyFocusChart(data: weeklyData),
        ],
      ),
    );
  }

  Widget _buildQualityCard(double avgQuality, List<double> qualityScores) {
    final percentage = (avgQuality * 100).toInt();
    final qualityLabel = avgQuality >= 0.9
        ? 'Excellent'
        : avgQuality >= 0.7
        ? 'Good'
        : avgQuality >= 0.5
        ? 'Fair'
        : 'Needs Work';

    final qualityColor = avgQuality >= 0.9
        ? AppColors.green400
        : avgQuality >= 0.7
        ? AppColors.indigo400
        : avgQuality >= 0.5
        ? AppColors.amber400
        : AppColors.orange400;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average Quality',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontFamily: AppTextStyles.displayFont,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: qualityColor,
                          height: 1.1,
                        ),
                      ),
                      AppSpacing.gapSm,
                      Text(
                        qualityLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: qualityColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapMd,
          Text(
            'Last 7 Sessions',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.gray500),
          ),
          AppSpacing.gapSm,
          FocusQualitySparkline(qualityScores: qualityScores),
        ],
      ),
    );
  }

  Widget _buildStreakCard(int currentStreak, int bestStreak) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      size: 20,
                      color: currentStreak > 0
                          ? AppColors.orange400
                          : AppColors.gray500,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      'Current Streak',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapSm,
                Text(
                  '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontFamily: AppTextStyles.displayFont,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: currentStreak > 0
                        ? AppColors.orange400
                        : AppColors.gray500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 60, color: AppColors.slate700),
          AppSpacing.gapLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 20,
                      color: AppColors.amber400,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      'Best Streak',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapSm,
                Text(
                  '$bestStreak ${bestStreak == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontFamily: AppTextStyles.displayFont,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.amber400,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(List<int> weeklyData, double avgQuality) {
    // Calculate insights
    final maxDay = weeklyData.indexOf(
      weeklyData.reduce((a, b) => a > b ? a : b),
    );
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final bestDay = dayNames[maxDay];

    // final totalMinutes = weeklyData.reduce((a, b) => a + b);
    final activeDays = weeklyData.where((m) => m > 0).length;

    final insights = <_Insight>[];

    // Best day insight
    if (weeklyData[maxDay] > 0) {
      insights.add(
        _Insight(
          icon: Icons.star_outline,
          text: '$bestDay is your most productive day',
          color: AppColors.indigo400,
        ),
      );
    }

    // Consistency insight
    if (activeDays >= 5) {
      insights.add(
        _Insight(
          icon: Icons.check_circle_outline,
          text: 'Great consistency: $activeDays days active',
          color: AppColors.green400,
        ),
      );
    } else if (activeDays >= 3) {
      insights.add(
        _Insight(
          icon: Icons.trending_up,
          text: 'Building consistency: $activeDays days active',
          color: AppColors.amber400,
        ),
      );
    }

    // Quality insight
    if (avgQuality >= 0.85) {
      insights.add(
        _Insight(
          icon: Icons.psychology_outlined,
          text: 'Maintaining high focus quality',
          color: AppColors.green400,
        ),
      );
    } else if (avgQuality < 0.6) {
      insights.add(
        _Insight(
          icon: Icons.lightbulb_outline,
          text: 'Try shorter sessions to improve quality',
          color: AppColors.orange400,
        ),
      );
    }

    // Empty state
    if (insights.isEmpty) {
      insights.add(
        _Insight(
          icon: Icons.insights_outlined,
          text: 'Complete more sessions to see insights',
          color: AppColors.gray400,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: insights
            .map(
              (insight) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(insight.icon, size: 20, color: insight.color),
                    AppSpacing.gapMd,
                    Expanded(
                      child: Text(
                        insight.text,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Insight {
  final IconData icon;
  final String text;
  final Color color;

  _Insight({required this.icon, required this.text, required this.color});
}
