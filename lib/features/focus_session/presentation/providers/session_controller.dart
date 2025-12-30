import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/focus_session.dart';

/// Provider for the session controller
final sessionControllerProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
      return SessionController();
    });

/// Session state sealed class for type-safe state management
sealed class SessionState {
  const SessionState();
}

/// No active session
class SessionIdle extends SessionState {
  const SessionIdle();
}

/// Session is running
class SessionActive extends SessionState {
  const SessionActive(this.session);

  final FocusSession session;
}

/// Session controller with lifecycle awareness
class SessionController extends StateNotifier<SessionState>
    with WidgetsBindingObserver {
  SessionController() : super(const SessionIdle()) {
    WidgetsBinding.instance.addObserver(this);
  }

  Timer? _timer;
  DateTime? _lastTickTime;
  final _uuid = const Uuid();

  /// Start a new focus session
  void startSession({
    required Duration duration,
    SessionMode mode = SessionMode.deep,
    Duration? breakDuration,
  }) {
    // Cancel any existing session
    if (state is SessionActive) {
      _stopTimer();
    }

    final session = FocusSession(
      id: _uuid.v4(),
      totalDuration: duration,
      remainingDuration: duration,
      status: SessionStatus.running,
      startTime: DateTime.now(),
      mode: mode,
    );

    state = SessionActive(session);
    _startTimer();
  }

  /// Start a break session (after completing focus session)
  void startBreak({required Duration duration}) {
    // Cancel any existing session
    if (state is SessionActive) {
      _stopTimer();
    }

    final session = FocusSession(
      id: _uuid.v4(),
      totalDuration: duration,
      remainingDuration: duration,
      status: SessionStatus.running,
      startTime: DateTime.now(),
      mode: SessionMode.light, // Breaks are always light mode
    );

    state = SessionActive(session);
    _startTimer();
  }

  /// Pause the current session
  void pauseSession() {
    if (state is! SessionActive) return;

    final currentSession = (state as SessionActive).session;
    if (currentSession.status != SessionStatus.running) return;

    _stopTimer();

    final pausedSession = currentSession.copyWith(
      status: SessionStatus.paused,
      pausedAt: DateTime.now(),
    );

    state = SessionActive(pausedSession);
  }

  /// Resume a paused session
  void resumeSession() {
    if (state is! SessionActive) return;

    final currentSession = (state as SessionActive).session;
    if (currentSession.status != SessionStatus.paused) return;

    // Reset last tick time to prevent time jump
    _lastTickTime = DateTime.now();

    final resumedSession = currentSession.copyWith(
      status: SessionStatus.running,
      pausedAt: null,
    );

    state = SessionActive(resumedSession);
    _startTimer();
  }

  /// Cancel the current session
  void cancelSession() {
    if (state is! SessionActive) return;

    _stopTimer();
    state = const SessionIdle();
  }

  /// Complete the current session
  void completeSession() {
    if (state is! SessionActive) return;

    _stopTimer();

    final currentSession = (state as SessionActive).session;
    final completedSession = currentSession.copyWith(
      status: SessionStatus.completed,
      completedAt: DateTime.now(),
      remainingDuration: Duration.zero,
    );

    state = SessionActive(completedSession);
    // Note: Completion screen will handle clearing the session state
  }

  /// Start the timer (1-second ticks)
  void _startTimer() {
    _lastTickTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  /// Stop the timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _lastTickTime = null;
  }

  /// Handle each timer tick
  void _onTick() {
    if (state is! SessionActive) return;

    final currentSession = (state as SessionActive).session;
    if (currentSession.status != SessionStatus.running) return;

    // Calculate actual elapsed time since last tick
    final now = DateTime.now();
    final elapsed = _lastTickTime != null
        ? now.difference(_lastTickTime!)
        : const Duration(seconds: 1);
    _lastTickTime = now;

    // Update remaining duration
    final newRemaining = currentSession.remainingDuration - elapsed;

    if (newRemaining.inSeconds <= 0) {
      // Session complete
      completeSession();
      return;
    }

    // Update session with new remaining time
    final updatedSession = currentSession.copyWith(
      remainingDuration: newRemaining,
    );

    state = SessionActive(updatedSession);
  }

  /// Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (state is! SessionActive) return;

    final currentSession = (state as SessionActive).session;

    switch (lifecycleState) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background - record distraction if session is running
        if (currentSession.status == SessionStatus.running) {
          _recordDistraction();
          _stopTimer();
        }
        break;

      case AppLifecycleState.resumed:
        // App returning to foreground - recalculate elapsed time
        if (currentSession.status == SessionStatus.running) {
          _recalculateTimeFromBackground(currentSession);
          _startTimer();
        }
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App closing or hidden - maintain state
        break;
    }
  }

  /// Recalculate remaining time after returning from background
  void _recalculateTimeFromBackground(FocusSession session) {
    final now = DateTime.now();
    final timeSinceStart = now.difference(session.startTime);

    // Calculate how much time should have elapsed
    Duration totalElapsed = timeSinceStart;

    // If session was paused, subtract pause duration
    if (session.pausedAt != null) {
      totalElapsed = session.pausedAt!.difference(session.startTime);
    }

    // Calculate new remaining time
    final newRemaining = session.totalDuration - totalElapsed;

    if (newRemaining.inSeconds <= 0) {
      // Session should have completed while in background
      completeSession();
      return;
    }

    // Update session with accurate remaining time
    final updatedSession = session.copyWith(remainingDuration: newRemaining);

    state = SessionActive(updatedSession);
  }

  /// Record a distraction (app backgrounding during active session)
  void _recordDistraction() {
    if (state is! SessionActive) return;

    final currentSession = (state as SessionActive).session;
    final updatedSession = currentSession.copyWith(
      distractionCount: currentSession.distractionCount + 1,
      lastDistractionTime: DateTime.now(),
    );

    state = SessionActive(updatedSession);
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Helper provider to get current session (if any)
final currentSessionProvider = Provider<FocusSession?>((ref) {
  final state = ref.watch(sessionControllerProvider);
  return state is SessionActive ? state.session : null;
});

/// Helper provider to check if session is running
final isSessionRunningProvider = Provider<bool>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.status == SessionStatus.running;
});

/// Helper provider to check if session is paused
final isSessionPausedProvider = Provider<bool>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.status == SessionStatus.paused;
});
