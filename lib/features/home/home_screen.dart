import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/circular_focus_timer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';
import '../focus_session/presentation/widgets/session_setup_bottom_sheet.dart';
import '../focus_session/presentation/models/session_config.dart';
import '../focus_session/presentation/providers/session_controller.dart';
import '../focus_session/presentation/screens/active_focus_screen.dart';
import '../focus_session/domain/entities/focus_session.dart';

/// Home screen with integrated session management
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use select to only rebuild when session changes, not internal state
    final session = ref.watch(
      sessionControllerProvider.select(
        (state) => state is SessionActive ? state.session : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focusync'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to settings
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Session Stats
                if (session != null && session.distractionCount > 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.amber.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.amber,
                        ),
                        AppSpacing.gapSm,
                        Text(
                          '${session.distractionCount} distraction${session.distractionCount > 1 ? 's' : ''} detected',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.amber,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapLg,
                ] else if (session == null) ...[
                  // Today's Stats (placeholder)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Today: 0h 0m',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapLg,
                ],

                // Timer Display
                _buildTimer(context, ref, session),

                AppSpacing.gapXl,

                // Duration Selector or Session Controls
                if (session == null)
                  _buildDurationSelector(context, ref)
                else
                  _buildSessionControls(context, ref, session),

                AppSpacing.gapXl,

                // Ambient Sound (placeholder)
                if (session == null) _buildAmbientSound(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(
    BuildContext context,
    WidgetRef ref,
    FocusSession? session,
  ) {
    if (session == null) {
      // Idle state - show START button
      return GestureDetector(
        onTap: () => _showSetupSheet(context, ref),
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.indigo500,
            boxShadow: context.shadowFloating,
          ),
          child: Center(
            child: Text(
              'START\nFOCUS',
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),
      );
    }

    // Active session - show timer
    final timerState = _getTimerState(session.status);
    final remainingSeconds = session.remainingDuration.inSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () {
        // If running, navigate to active focus screen
        if (session.status == SessionStatus.running) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ActiveFocusScreen(),
              fullscreenDialog: true,
            ),
          );
        } else if (session.status == SessionStatus.paused) {
          // If paused, resume directly
          ref.read(sessionControllerProvider.notifier).resumeSession();
        }
      },
      child: CircularFocusTimer(
        progress: session.progress,
        state: timerState,
        size: 280,
        strokeWidth: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(timeText, style: AppTextStyles.displayLarge),
            AppSpacing.gapSm,
            Text(
              '${session.totalDuration.inMinutes} min',
              style: AppTextStyles.bodySmall,
            ),
            if (session.status == SessionStatus.paused) ...[
              AppSpacing.gapSm,
              Icon(Icons.play_arrow, size: 32, color: AppColors.indigo400),
            ],
          ],
        ),
      ),
    );
  }

  TimerState _getTimerState(SessionStatus status) {
    switch (status) {
      case SessionStatus.running:
        return TimerState.focus;
      case SessionStatus.paused:
        return TimerState.paused;
      case SessionStatus.completed:
        return TimerState.idle;
      case SessionStatus.cancelled:
        return TimerState.idle;
    }
  }

  Widget _buildDurationSelector(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Quick Start',
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.gray400),
        ),
        AppSpacing.gapSm,
        Wrap(
          spacing: AppSpacing.sm,
          children: [15, 25, 45, 60].map((minutes) {
            return OutlinedButton(
              onPressed: () {
                ref
                    .read(sessionControllerProvider.notifier)
                    .startSession(duration: Duration(minutes: minutes));
              },
              child: Text('$minutes min'),
            );
          }).toList(),
        ),
        AppSpacing.gapMd,
        TextButton.icon(
          onPressed: () => _showSetupSheet(context, ref),
          icon: const Icon(Icons.settings, size: 20),
          label: const Text('Customize'),
        ),
      ],
    );
  }

  Widget _buildSessionControls(
    BuildContext context,
    WidgetRef ref,
    FocusSession session,
  ) {
    if (session.status == SessionStatus.paused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              ref.read(sessionControllerProvider.notifier).resumeSession();
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Resume'),
          ),
          AppSpacing.gapMdH,
          OutlinedButton.icon(
            onPressed: () {
              ref.read(sessionControllerProvider.notifier).cancelSession();
            },
            icon: const Icon(Icons.stop),
            label: const Text('End'),
          ),
        ],
      );
    }

    if (session.status == SessionStatus.completed) {
      return Column(
        children: [
          const Icon(Icons.check_circle, size: 48, color: AppColors.success),
          AppSpacing.gapSm,
          Text(
            'Session Complete!',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.success),
          ),
        ],
      );
    }

    // Running - show end button
    return TextButton.icon(
      onPressed: () {
        ref.read(sessionControllerProvider.notifier).cancelSession();
      },
      icon: const Icon(Icons.close, size: 20),
      label: const Text('End Session'),
    );
  }

  Widget _buildAmbientSound(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: AppSpacing.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_note, size: 16, color: AppColors.gray400),
          AppSpacing.gapSmH,
          Text(
            'Rain (off)',
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.gray400),
          ),
        ],
      ),
    );
  }

  void _showSetupSheet(BuildContext context, WidgetRef ref) {
    SessionSetupBottomSheet.show(
      context,
      onStart: (config) {
        ref
            .read(sessionControllerProvider.notifier)
            .startSession(
              duration: config.focusDuration,
              mode: _convertMode(config.focusMode),
            );
      },
    );
  }

  SessionMode _convertMode(FocusMode uiMode) {
    switch (uiMode) {
      case FocusMode.light:
        return SessionMode.light;
      case FocusMode.deep:
        return SessionMode.deep;
      case FocusMode.ultra:
        return SessionMode.ultra;
    }
  }
}
