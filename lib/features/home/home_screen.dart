import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/circular_focus_timer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../focus_session/presentation/widgets/session_setup_bottom_sheet.dart';
import '../focus_session/presentation/models/session_config.dart';
import '../focus_session/presentation/providers/session_controller.dart';
import '../focus_session/presentation/screens/active_focus_screen.dart';
import '../focus_session/domain/entities/focus_session.dart';

/// Home screen with integrated session management
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedDuration = 25; // Default 25 minutes

  @override
  Widget build(BuildContext context) {
    // Use select to only rebuild when session changes, not internal state
    final session = ref.watch(
      sessionControllerProvider.select(
        (state) => state is SessionActive ? state.session : null,
      ),
    );

    final isIdle = session == null;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content - centered timer
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Quality preview (only when idle and sessions exist)
                  if (isIdle) _buildQualityPreview(),

                  if (isIdle)
                    const SizedBox(height: 64)
                  else
                    const SizedBox(height: 32),

                  // Timer Display (dominant element)
                  _buildTimer(context, ref, session),

                  const SizedBox(height: 32),

                  // Duration options (only when idle)
                  if (isIdle) _buildDurationOptions(),

                  const Spacer(flex: 3),
                ],
              ),
            ),

            // Profile icon (top-right, only when idle)
            if (isIdle)
              Positioned(top: 16, right: 16, child: _buildProfileIcon(context)),

            // Distraction warning (centered below timer, only during active session)
            if (session != null && session.distractionCount > 0)
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: _buildDistractionWarning(session),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityPreview() {
    // TODO: Calculate actual quality from completed sessions today
    final completedSessionsToday = 0; // Placeholder
    final averageQuality = 92; // Placeholder

    if (completedSessionsToday == 0) {
      return const SizedBox.shrink();
    }

    return Text(
      '$averageQuality%',
      style: AppTextStyles.bodySmall.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Open profile/settings
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.person_outline, size: 28, color: AppColors.white),
      ),
    );
  }

  Widget _buildSettingsDots(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Open settings overlay
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          '···',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildDistractionWarning(FocusSession session) {
    // No border - text alone communicates state (frozen minimal design)
    return Center(
      child: Text(
        '[${session.distractionCount}]',
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          color: AppColors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDurationOptions() {
    const durations = [10, 15, 25, 60];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: durations.map((duration) {
        final isSelected = duration == _selectedDuration;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedDuration = duration;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white
                    : AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                duration.toString(),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  color: isSelected ? AppColors.black : AppColors.gray50,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationLabel(BuildContext context, WidgetRef ref) {
    // TODO: Get actual default duration from settings
    final defaultDuration = 25;

    return GestureDetector(
      onTap: () => _showDurationPicker(context, ref),
      child: Text(
        '$defaultDuration', // No 'min' suffix - context is obvious
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          color: AppColors.white,
        ),
      ),
    );
  }

  void _showDurationPicker(BuildContext context, WidgetRef ref) {
    // TODO: Show inline duration picker
    // For now, show setup sheet
    _showSetupSheet(context, ref);
  }

  Widget _buildTimer(
    BuildContext context,
    WidgetRef ref,
    FocusSession? session,
  ) {
    if (session == null) {
      // Idle state - show full circle (ready to start)
      final timeText = '${_selectedDuration.toString().padLeft(2, '0')}:00';

      return GestureDetector(
        onTap: () {
          // Start session with selected duration
          ref
              .read(sessionControllerProvider.notifier)
              .startSession(duration: Duration(minutes: _selectedDuration));
        },
        child: CircularFocusTimer(
          progress: 1.0, // Full circle in idle state
          state: TimerState.idle,
          size: 320,
          strokeWidth: 3,
          animationDuration: const Duration(milliseconds: 150),
          child: Text(
            timeText,
            style: AppTextStyles.displayHero.copyWith(
              fontSize: 96,
              fontWeight: FontWeight.w200,
              color: AppColors.white, // Bright white
              fontFeatures: const [
                FontFeature.tabularFigures(), // Prevent layout shift
              ],
            ),
          ),
        ),
      );
    }

    // Active session - show timer with progress
    final timerState = _getTimerState(session.status);
    final timeText = _formatDuration(session.remainingDuration);

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
        size: 320,
        strokeWidth: session.status == SessionStatus.paused
            ? 3
            : 3, // 3px for both running and paused
        animationDuration: const Duration(
          milliseconds: 150,
        ), // Minimal animation
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeText,
              style: AppTextStyles.displayHero.copyWith(
                fontSize: 96,
                fontWeight: FontWeight.w200,
                color: AppColors.white, // Pure white always
                fontFeatures: const [
                  FontFeature.tabularFigures(), // Prevent layout jump
                ],
              ),
            ),
            if (session.status == SessionStatus.paused) ...[
              const SizedBox(height: 16),
              // Pause icon (two vertical bars in white for consistency)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 4, height: 16, color: AppColors.white),
                  const SizedBox(width: 4),
                  Container(width: 4, height: 16, color: AppColors.white),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper methods
  TimerState _getTimerState(SessionStatus status) {
    switch (status) {
      case SessionStatus.running:
        return TimerState.focus;
      case SessionStatus.paused:
        return TimerState.paused;
      case SessionStatus.completed:
      case SessionStatus.cancelled:
        return TimerState.idle;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
