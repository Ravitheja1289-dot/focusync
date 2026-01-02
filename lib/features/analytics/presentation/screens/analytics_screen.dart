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
    final monthTotal = 720;
    final todaySessionsCompleted = 3;
    final weekSessionsCompleted = 12;
    final monthSessionsCompleted = 48;
    final avgSessionLength = 25; // minutes
    final currentStreak = 3;
    final bestStreak = 7;
    final activeDaysThisMonth = 20;
    final completionRate = 0.85; // 85%
    final interruptionTrend = -12; // -12% vs last week
    final bestFocusTime = '6–9 AM';
    final weeklyData = [30, 45, 60, 40, 50, 35, 45]; // Mon-Sun
    final qualityScores = [0.9, 0.85, 0.95, 0.8, 0.88, 0.92, 0.87];
    final avgQuality =
        qualityScores.reduce((a, b) => a + b) / qualityScores.length;
    final heatmapData = _generateMockHeatmapData();
    final hourlyDistribution = _generateMockHourlyData();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Focus Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION 1 — Focus Performance (Core)
              _buildSectionHeader('Focus Performance'),
              AppSpacing.gapMd,

              // 1. Total Focus Time
              _buildFocusTimeCard(todayMinutes, weekTotal, monthTotal),
              AppSpacing.gapMd,

              // 2. Sessions Completed
              _buildSessionsCard(
                todaySessionsCompleted,
                weekSessionsCompleted,
                monthSessionsCompleted,
              ),
              AppSpacing.gapMd,

              // 3. Average Session Length
              _buildAvgSessionCard(avgSessionLength),

              AppSpacing.gapXl,

              // SECTION 2 — Consistency & Discipline
              _buildSectionHeader('Consistency & Discipline'),
              AppSpacing.gapMd,

              // 4. Streaks
              _buildStreakCard(currentStreak, bestStreak),
              AppSpacing.gapMd,

              // 5. Active Days
              _buildActiveDaysCard(activeDaysThisMonth),
              AppSpacing.gapMd,

              // 6. Calendar Heatmap
              _buildHeatmapCard(heatmapData),

              AppSpacing.gapXl,

              // SECTION 3 — Quality of Focus (Advanced)
              _buildSectionHeader('Quality of Focus'),
              AppSpacing.gapMd,

              _buildQualityCard(avgQuality, qualityScores),
              AppSpacing.gapMd,

              // 7. Completion Rate
              _buildCompletionRateCard(completionRate),
              AppSpacing.gapMd,

              // 8. Interruption Count
              _buildInterruptionCard(interruptionTrend),

              AppSpacing.gapXl,

              // SECTION 4 — Patterns & Trends
              _buildSectionHeader('Patterns & Trends'),
              AppSpacing.gapMd,

              // 9. Best Focus Time
              _buildBestTimeCard(bestFocusTime, hourlyDistribution),
              AppSpacing.gapMd,

              // 10. Weekly Trend
              _buildWeeklyTrendCard(weeklyData),

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
        color: AppColors.white,
        fontWeight: FontWeight.w600,
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

    final qualityColor = AppColors.white;

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
                      color: AppColors.white,
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
                          fontFamily: 'Inter',
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
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
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
        // No border
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // No icon - text label alone
                Text(
                  'Current Streak',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
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
                // No icon
                Text(
                  'Best Streak',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  '$bestStreak ${bestStreak == 1 ? 'day' : 'days'}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
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

  // SECTION 1 — Focus Performance Methods

  Widget _buildFocusTimeCard(int todayMin, int weekMin, int monthMin) {
    final todayHours = todayMin ~/ 60;
    final todayMins = todayMin % 60;
    final weekHours = weekMin ~/ 60;
    final weekMins = weekMin % 60;
    final monthHours = monthMin ~/ 60;

    final weekChange = 12; // +12% vs last week (TODO: calculate)

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray40, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Focus Time',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeMetric(
                'Today',
                todayHours > 0
                    ? '${todayHours}h ${todayMins}m'
                    : '${todayMins}m',
              ),
              _buildTimeMetric(
                'This Week',
                weekHours > 0 ? '${weekHours}h ${weekMins}m' : '${weekMins}m',
              ),
              _buildTimeMetric('This Month', '${monthHours}h'),
            ],
          ),
          AppSpacing.gapMd,
          Text(
            '+$weekChange% vs last week',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.white.withOpacity(0.6),
          ),
        ),
        AppSpacing.gapXs,
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildSessionsCard(int today, int week, int month) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sessions Completed',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSessionMetric('Today', today),
              _buildSessionMetric('This Week', week),
              _buildSessionMetric('This Month', month),
            ],
          ),
          AppSpacing.gapMd,
          Text(
            'High sessions + moderate time = good habit formation',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionMetric(String label, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.white.withOpacity(0.6),
          ),
        ),
        AppSpacing.gapXs,
        Text(
          '$count',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildAvgSessionCard(int avgMinutes) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Session Length',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          Text(
            '${avgMinutes}m',
            style: AppTextStyles.displayMedium.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapSm,
          Text(
            'Indicates stamina and cognitive endurance',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 2 — Consistency Methods

  Widget _buildActiveDaysCard(int activeDays) {
    final totalDays = 30;
    final percentage = (activeDays / totalDays * 100).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Days',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$activeDays',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                ' / $totalDays days',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          LinearProgressIndicator(
            value: activeDays / totalDays,
            backgroundColor: AppColors.gray20,
            valueColor: AlwaysStoppedAnimation(AppColors.white),
            minHeight: 4,
          ),
          AppSpacing.gapMd,
          Text(
            '$percentage% adherence • $activeDays active days/month > 5 intense days',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapCard(List<List<int>> heatmapData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar Heatmap',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          _buildHeatmap(heatmapData),
          AppSpacing.gapSm,
          Text(
            'Darker = more focus time',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmap(List<List<int>> data) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(data.length, (weekIndex) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (dayIndex) {
              final intensity = data[weekIndex][dayIndex];
              final color = _getHeatmapColor(intensity);
              return Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Color _getHeatmapColor(int minutes) {
    if (minutes == 0) return AppColors.gray20;
    if (minutes < 30) return AppColors.gray40;
    if (minutes < 60) return AppColors.gray60;
    if (minutes < 90) return AppColors.gray80;
    return AppColors.white;
  }

  // SECTION 3 — Quality Methods

  Widget _buildCompletionRateCard(double rate) {
    final percentage = (rate * 100).round();
    final insight = rate < 0.6
        ? 'Low completion → session length too aggressive'
        : rate > 0.9
        ? 'Excellent completion rate'
        : 'Good completion rate';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completion Rate',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          Text(
            '$percentage%',
            style: AppTextStyles.displayMedium.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          LinearProgressIndicator(
            value: rate,
            backgroundColor: AppColors.gray20,
            valueColor: AlwaysStoppedAnimation(AppColors.white),
            minHeight: 4,
          ),
          AppSpacing.gapMd,
          Text(
            insight,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterruptionCard(int trendPercentage) {
    final isImproving = trendPercentage < 0;
    final trendText = isImproving ? '$trendPercentage%' : '+$trendPercentage%';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interruptions',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          Text(
            '$trendText vs last week',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.white,
            ),
          ),
          AppSpacing.gapMd,
          Text(
            isImproving
                ? 'Improving environmental resistance'
                : 'Measures environmental resistance',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION 4 — Patterns Methods

  Widget _buildBestTimeCard(String timeRange, List<int> hourlyData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Focus Time',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapMd,
          Text(
            'You focus best between $timeRange',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapLg,
          _buildHourlyChart(hourlyData),
        ],
      ),
    );
  }

  Widget _buildHourlyChart(List<int> data) {
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(24, (hour) {
          final value = data[hour];
          final heightPercent = maxValue > 0 ? value / maxValue : 0.0;

          return Container(
            width: 8,
            height: 60 * heightPercent,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3 + (0.7 * heightPercent)),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeeklyTrendCard(List<int> weeklyData) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxValue = weeklyData.reduce((a, b) => a > b ? a : b);
    final minDay = weeklyData.indexOf(
      weeklyData.reduce((a, b) => a < b ? a : b),
    );

    String insight = '';
    if (minDay == 0) {
      insight = 'Mondays weak → planning issue';
    } else if (minDay == 4)
      insight = 'Fridays weak → fatigue issue';
    else
      insight = 'Detects work-life rhythm';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Trend',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
          ),
          AppSpacing.gapLg,
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final value = weeklyData[index];
                final heightPercent = maxValue > 0 ? value / maxValue : 0.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${value}m',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                    AppSpacing.gapXs,
                    Container(
                      width: 32,
                      height: 80 * heightPercent,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AppSpacing.gapXs,
                    Text(
                      dayNames[index],
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          AppSpacing.gapMd,
          Text(
            insight,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Mock data generators
  List<List<int>> _generateMockHeatmapData() {
    return List.generate(
      12,
      (week) => List.generate(7, (day) => (week * day * 5) % 120),
    );
  }

  List<int> _generateMockHourlyData() {
    final peak = [6, 7, 8, 9, 10]; // Peak hours
    return List.generate(24, (hour) {
      if (peak.contains(hour)) return 80 + (hour % 3) * 10;
      if (hour < 6 || hour > 22) return 0;
      if (hour > 12 && hour < 14) return 30; // Lunch dip
      return 40 + (hour % 5) * 8;
    });
  }
}
