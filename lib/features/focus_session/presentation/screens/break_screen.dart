import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/breathing_animation.dart';
import '../providers/session_controller.dart';

/// Break screen with calming breathing animation
///
/// Design principles:
/// - Restorative: Gentle animation, no demands
/// - Calm: Muted colors, slow motion
/// - Optional: User can skip if they want
class BreakScreen extends ConsumerStatefulWidget {
  const BreakScreen({super.key});

  @override
  ConsumerState<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends ConsumerState<BreakScreen> {
  @override
  void initState() {
    super.initState();
    // Subtle system UI (not fully immersive like focus screen)
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  void dispose() {
    // Restore full system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _skipBreak() {
    ref.read(sessionControllerProvider.notifier).cancelSession();
    Navigator.of(context).pop();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showSkipConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SkipBreakBottomSheet(onConfirm: _skipBreak),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);

    if (session == null) {
      // Break ended, navigate back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
      return const SizedBox.shrink();
    }

    final timeText = _formatDuration(session.remainingDuration);

    return Scaffold(
      backgroundColor: AppColors.slate900,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Break title
                  Text(
                    'Take a break',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.gray40,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  AppSpacing.gapMd,

                  // Remaining time
                  Text(
                    timeText,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.gray80,
                      fontFamily: 'Inter',
                    ),
                  ),

                  AppSpacing.gapXl,
                  AppSpacing.gapXl,

                  // Breathing Animation
                  const BreathingAnimation(size: 280),

                  const Spacer(flex: 2),

                  // Skip button (subtle, bottom)
                  TextButton(
                    onPressed: _showSkipConfirmation,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.gray50,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: Text(
                      'Skip break',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray50,
                      ),
                    ),
                  ),

                  AppSpacing.gapLg,
                ],
              ),
            ),

            // Top bar removed - time display alone is sufficient
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet to confirm skipping the break
class _SkipBreakBottomSheet extends StatelessWidget {
  const _SkipBreakBottomSheet({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // No decorative icon
          Text(
            'Skip break?',
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
          ),

          const SizedBox(height: 8),

          Text(
            'Breaks help maintain focus.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray400),
          ),

          AppSpacing.gapLg,

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                  ),
                  child: const Text('Continue Break'),
                ),
              ),

              AppSpacing.gapMd,

              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close sheet
                    onConfirm();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    backgroundColor: AppColors.gray70,
                  ),
                  child: const Text('Skip Break'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
