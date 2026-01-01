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

    final remainingSeconds = session.remainingDuration.inSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

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
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.gray400,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  AppSpacing.gapMd,

                  // Remaining time
                  Text(
                    timeText,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.gray200,
                      fontFamily: AppTextStyles.displayFont,
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
                      foregroundColor: AppColors.gray500,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: Text(
                      'Skip break',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ),

                  AppSpacing.gapLg,
                ],
              ),
            ),

            // Top bar (minimal)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.slate800.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'BREAK TIME',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.gray400,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          Icon(Icons.info_outline, size: 48, color: AppColors.indigo400),

          AppSpacing.gapMd,

          Text(
            'Skip your break?',
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
          ),

          AppSpacing.gapSm,

          Text(
            'Regular breaks help maintain focus and prevent burnout. Consider staying for the full break.',
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
                    backgroundColor: AppColors.gray700,
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
