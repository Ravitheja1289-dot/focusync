import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/focus_session.dart';
import '../widgets/celebration_confetti.dart';
import '../providers/session_controller.dart';
import 'break_screen.dart';
import '../../../../core/router/app_routes.dart';

/// Session completion/reward screen
///
/// Design principles:
/// - Celebratory: Acknowledges achievement
/// - Informative: Shows session stats
/// - Motivating: Encourages continued focus habits
/// - Calm: Subtle animations, no overwhelming effects
class SessionCompletionScreen extends ConsumerStatefulWidget {
  const SessionCompletionScreen({super.key, required this.session});

  final FocusSession session;

  @override
  ConsumerState<SessionCompletionScreen> createState() =>
      _SessionCompletionScreenState();
}

class _SessionCompletionScreenState
    extends ConsumerState<SessionCompletionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<double> _scaleAnimation;

  // Pre-calculated values to avoid recomputation during animation

  @override
  void initState() {
    super.initState();

    // Calculate quality metrics once
    // final focusQuality = _calculateFocusQuality();
    // final qualityColor = _getQualityColor();
    // final qualityIcon = _getQualityIcon();
    // final encouragingMessage = _getEncouragingMessage();
    // final detailedFeedback = _getDetailedFeedback();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getEncouragingMessage() {
    final focusQuality = _calculateFocusQuality();

    if (focusQuality >= 0.9) {
      return 'Outstanding focus!';
    } else if (focusQuality >= 0.7) {
      return 'Great work!';
    } else if (focusQuality >= 0.5) {
      return 'Good effort!';
    } else {
      return 'Session complete!';
    }
  }

  String _getDetailedFeedback() {
    final distractionCount = widget.session.distractionCount;
    final minutes = widget.session.totalDuration.inMinutes;

    if (distractionCount == 0) {
      return 'You maintained complete focus for $minutes minutes. Excellent discipline.';
    } else if (distractionCount <= 2) {
      return 'You stayed focused for $minutes minutes with minimal distractions. Keep it up!';
    } else if (distractionCount <= 5) {
      return 'You completed $minutes minutes of focus time. Try to reduce distractions next session.';
    } else {
      return 'You completed the session. Consider shorter durations or deeper focus mode next time.';
    }
  }

  double _calculateFocusQuality() {
    final distractionCount = widget.session.distractionCount;
    final minutes = widget.session.totalDuration.inMinutes;

    // Quality score based on distractions per minute
    final distractionsPerMinute = distractionCount / minutes;

    if (distractionsPerMinute == 0) return 1.0;
    if (distractionsPerMinute < 0.1) return 0.9;
    if (distractionsPerMinute < 0.2) return 0.7;
    if (distractionsPerMinute < 0.4) return 0.5;
    return 0.3;
  }

  Color _getQualityColor() {
    final quality = _calculateFocusQuality();

    if (quality >= 0.9) return AppColors.green400;
    if (quality >= 0.7) return AppColors.indigo400;
    if (quality >= 0.5) return AppColors.amber400;
    return AppColors.orange400;
  }

  IconData _getQualityIcon() {
    final quality = _calculateFocusQuality();

    if (quality >= 0.9) return Icons.workspace_premium;
    if (quality >= 0.7) return Icons.star;
    if (quality >= 0.5) return Icons.check_circle;
    return Icons.task_alt;
  }

  void _startAnotherSession() {
    // Clear the completed session
    ref.read(sessionControllerProvider.notifier).cancelSession();
    Navigator.of(context).pop();
    // Return to home screen where user can start a new session
  }

  void _takeBreak() {
    // Clear the completed session first
    ref.read(sessionControllerProvider.notifier).cancelSession();

    // Start a 5-minute break session
    ref
        .read(sessionControllerProvider.notifier)
        .startBreak(duration: const Duration(minutes: 5));

    // Navigate to break screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const BreakScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _viewHistory() {
    // Clear the completed session
    ref.read(sessionControllerProvider.notifier).cancelSession();
    Navigator.of(context).pop();
    // Navigate to analytics/history screen
    context.go(AppRoutes.history);
  }

  @override
  Widget build(BuildContext context) {
    // final minutes = widget.session.totalDuration.inMinutes;
    // final seconds = widget.session.totalDuration.inSeconds % 60;
    // final durationText = seconds > 0
    //     ? '$minutes min $seconds sec'
    //     : '$minutes min';

    return Scaffold(
      backgroundColor: AppColors.slate950,
      body: Stack(
        children: [
          // Confetti animation
          const Positioned.fill(child: CelebrationConfetti()),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideUpAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSpacing.gapXl,

                        // Success icon with scale animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getQualityColor().withOpacity(0.2),
                              border: Border.all(
                                color: _getQualityColor().withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _getQualityIcon(),
                              size: 48,
                              color: _getQualityColor(),
                            ),
                          ),
                        ),

                        AppSpacing.gapXl,

                        // Encouraging message
                        Text(
                          _getEncouragingMessage(),
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        AppSpacing.gapMd,

                        // Detailed feedback
                        Text(
                          _getDetailedFeedback(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.gray400,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        AppSpacing.gapXl,
                        AppSpacing.gapXl,

                        // Stats cards
                        _buildStatsGrid(),

                        AppSpacing.gapXl,
                        AppSpacing.gapXl,

                        // Action buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _takeBreak,
                                icon: const Icon(Icons.self_improvement),
                                label: const Text('Take a Break'),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(0, 56),
                                ),
                              ),
                            ),

                            AppSpacing.gapMd,

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _startAnotherSession,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Start Another Session'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 56),
                                ),
                              ),
                            ),

                            AppSpacing.gapSm,

                            TextButton.icon(
                              onPressed: _viewHistory,
                              icon: const Icon(Icons.history, size: 18),
                              label: const Text('View History'),
                            ),

                            TextButton(
                              onPressed: () {
                                // Clear the completed session
                                ref
                                    .read(sessionControllerProvider.notifier)
                                    .cancelSession();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back to Home'),
                            ),
                          ],
                        ),

                        AppSpacing.gapXl,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final minutes = widget.session.totalDuration.inMinutes;
    final seconds = widget.session.totalDuration.inSeconds % 60;
    final durationText = seconds > 0
        ? '$minutes:${seconds.toString().padLeft(2, '0')}'
        : '$minutes:00';

    final focusQuality = _calculateFocusQuality();
    final qualityPercent = (focusQuality * 100).toInt();

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.center,
      children: [
        _buildStatCard(
          icon: Icons.timer_outlined,
          label: 'Focus Time',
          value: durationText,
          valueColor: AppColors.indigo400,
        ),
        _buildStatCard(
          icon: Icons.psychology_outlined,
          label: 'Focus Quality',
          value: '$qualityPercent%',
          valueColor: _getQualityColor(),
        ),
        _buildStatCard(
          icon: Icons.phone_android_outlined,
          label: 'Distractions',
          value: '${widget.session.distractionCount}',
          valueColor: widget.session.distractionCount == 0
              ? AppColors.green400
              : widget.session.distractionCount <= 3
              ? AppColors.amber400
              : AppColors.orange400,
        ),
        _buildStatCard(
          icon: Icons.whatshot_outlined,
          label: 'Streak',
          value: '1', // Placeholder - would come from user stats
          valueColor: AppColors.orange400,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - AppSpacing.lg * 3) / 2; // 2 cards per row with gaps

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.slate800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate700, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.gray400),
          AppSpacing.gapSm,
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
              fontFamily: AppTextStyles.displayFont,
            ),
          ),
          AppSpacing.gapXs,
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.gray500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
