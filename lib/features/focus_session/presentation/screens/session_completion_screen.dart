import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/focus_session.dart';
import '../widgets/celebration_confetti.dart';
import '../providers/session_controller.dart';

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
  // _scaleAnimation removed - unused

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
      duration: const Duration(milliseconds: 100), // Subtle fade only
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // No easing
    );

    // Remove slide and scale animations - forbidden in frozen minimal design
    _slideUpAnimation = Tween<Offset>(
      begin: Offset.zero, // No slide
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    // Frozen design system: no semantic colors
    // Use white for good quality, gray for lower quality
    if (quality >= 0.7) return AppColors.textPrimary;
    return AppColors.white;
  }

  void _startAnotherSession() {
    // Clear the completed session
    ref.read(sessionControllerProvider.notifier).cancelSession();
    context.go(AppRoutes.home);
    // Return to home screen where user can start a new session
  }

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 64),

                        // No decorative icon - forbidden in frozen minimal design

                        // Quality percentage only
                        Text(
                          '${(_calculateFocusQuality() * 100).toInt()}%',
                          style: AppTextStyles.displayHero.copyWith(
                            fontSize: 120,
                            fontWeight: FontWeight.w200,
                            color: _getQualityColor(),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // No encouraging message - percentage alone is sufficient

                        // No detailed feedback - percentage alone is sufficient

                        // No stats grid - minimal data only
                        const SizedBox(height: 64),

                        // Minimal actions - text buttons only
                        Column(
                          children: [
                            TextButton(
                              onPressed: _startAnotherSession,
                              child: const Text('Continue'), // No icon
                            ),

                            const SizedBox(height: 8),

                            TextButton(
                              onPressed: () {
                                ref
                                    .read(sessionControllerProvider.notifier)
                                    .cancelSession();
                                context.go(AppRoutes.home);
                              },
                              child: const Text('Done'),
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

  // _buildStatsGrid and _buildStatCard removed - no longer used in minimal design
}
