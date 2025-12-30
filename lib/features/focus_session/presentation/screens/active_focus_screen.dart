import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/circular_focus_timer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_motion.dart';
import '../../focus_session/presentation/providers/session_controller.dart';
import '../../focus_session/domain/entities/focus_session.dart';
import '../widgets/distraction_warning_overlay.dart';
import 'break_screen.dart';
import 'session_completion_screen.dart';
import '../models/session_config.dart';

/// Fullscreen active focus session screen
///
/// Design principles:
/// - Immersive: No chrome, no distractions
/// - Calm: Minimal motion, muted colors
/// - Safe: No accidental exits
/// - Serious: Treats focus time as valuable
class ActiveFocusScreen extends ConsumerStatefulWidget {
  const ActiveFocusScreen({super.key});

  @override
  ConsumerState<ActiveFocusScreen> createState() => _ActiveFocusScreenState();
}

class _ActiveFocusScreenState extends ConsumerState<ActiveFocusScreen> {
  bool _showPauseOverlay = false;
  bool _showWarning = false;
  int _lastWarningCount = 0;
  SessionStatus? _lastSessionStatus;

  @override
  void initState() {
    super.initState();
    // Set fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onTimerTap() {
    final session = ref.read(currentSessionProvider);
    if (session == null) return;

    if (session.status == SessionStatus.running) {
      // Pause
      ref.read(sessionControllerProvider.notifier).pauseSession();
    } else if (session.status == SessionStatus.paused) {
      // Resume
      ref.read(sessionControllerProvider.notifier).resumeSession();
    }
  }

  void _showEndConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _EndSessionBottomSheet(
        onConfirm: () {
          ref.read(sessionControllerProvider.notifier).cancelSession();
          Navigator.of(context).pop(); // Close bottom sheet
          Navigator.of(context).pop(); // Exit focus screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);

    if (session == null) {
      // Session ended, navigate back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
      return const SizedBox.shrink();
    }

    // Check if session just completed - transition to completion screen
    if (session.status == SessionStatus.completed &&
        _lastSessionStatus != SessionStatus.completed) {
      _lastSessionStatus = SessionStatus.completed;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Navigate to completion screen with session data
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SessionCompletionScreen(session: session),
              fullscreenDialog: true,
            ),
          );
        }
      });
    } else {
      _lastSessionStatus = session.status;
    }

    // Check for new distractions and show warning
    if (session.distractionCount > _lastWarningCount && !_showWarning) {
      _lastWarningCount = session.distractionCount;
      _showWarning = true;
      // Reset warning state after showing
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {});
        }
      });
    }

    final isPaused = session.status == SessionStatus.paused;
    final remainingSeconds = session.remainingDuration.inSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.slate950,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Swipe down to show options
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 300) {
            _showEndConfirmation();
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Main Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Timer with Progress Ring
                    GestureDetector(
                      onTap: _onTimerTap,
                      child: CircularFocusTimer(
                        progress: session.progress,
                        state: isPaused ? TimerState.paused : TimerState.focus,
                        size: 320,
                        strokeWidth: 6,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Time Display (primary)
                            Text(
                              timeText,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.displayFont,
                                fontSize: 72,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.0,
                                color: AppColors.gray50,
                              ),
                            ),

                            AppSpacing.gapSm,

                            // Session Info (secondary)
                            Text(
                              '${session.totalDuration.inMinutes} min focus',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.gray400,
                              ),
                            ),

                            if (isPaused) ...[
                              AppSpacing.gapMd,
                              const Icon(
                                Icons.pause_circle_outline,
                                size: 48,
                                color: AppColors.indigo400,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Subtle Hint
                    if (!isPaused)
                      Text(
                        'Tap to pause',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),

                    if (isPaused)
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(sessionControllerProvider.notifier)
                                  .resumeSession();
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Resume'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(160, 56),
                            ),
                          ),
                          AppSpacing.gapSm,
                          TextButton(
                            onPressed: _showEndConfirmation,
                            child: const Text('End Session'),
                          ),
                        ],
                      ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),

              // Top Bar (minimal)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Session mode indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.slate800.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getModeLabel(session.mode),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.gray400,
                          ),
                        ),
                      ),

                      // Distraction count indicator (if any)
                      if (session.distractionCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber400.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.amber400.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: AppColors.amber400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${session.distractionCount}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.amber400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Options button (hidden when running)
                      if (isPaused)
                        IconButton(
                          onPressed: _showEndConfirmation,
                          icon: const Icon(Icons.more_vert, size: 20),
                          color: AppColors.gray400,
                        ),
                    ],
                  ),
                ),
              ),

              // Distraction Warning Overlay
              if (_showWarning)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: DistractionWarningOverlay(
                    distractionCount: session.distractionCount,
                    onDismiss: () {
                      setState(() {
                        _showWarning = false;
                      });
                    },
                  ),
                ),

              // Swipe hint at bottom
              if (!isPaused)
                Positioned(
                  bottom: AppSpacing.lg,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.slate700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getModeLabel(SessionMode mode) {
    switch (mode) {
      case SessionMode.light:
        return 'LIGHT FOCUS';
      case SessionMode.deep:
        return 'DEEP FOCUS';
      case SessionMode.ultra:
        return 'ULTRA FOCUS';
    }
  }
}

/// Bottom sheet for ending session confirmation
class _EndSessionBottomSheet extends StatelessWidget {
  const _EndSessionBottomSheet({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.slate700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              AppSpacing.gapLg,

              // Warning
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 28,
                  ),
                  AppSpacing.gapMdH,
                  Expanded(
                    child: Text(
                      'End session early?',
                      style: AppTextStyles.titleLarge,
                    ),
                  ),
                ],
              ),

              AppSpacing.gapMd,

              // Explanation
              Text(
                'Your focus session is still in progress. Ending now will cancel the remaining time.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray200,
                ),
              ),

              AppSpacing.gapXl,

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Keep Going'),
                    ),
                  ),
                  AppSpacing.gapMdH,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: const Text('End Session'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
