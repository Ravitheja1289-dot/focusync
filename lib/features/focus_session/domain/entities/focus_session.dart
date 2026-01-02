import 'package:equatable/equatable.dart';

/// Domain entity representing a focus session
class FocusSession extends Equatable {
  const FocusSession({
    required this.id,
    required this.totalDuration,
    required this.remainingDuration,
    required this.status,
    required this.startTime,
    this.pausedAt,
    this.completedAt,
    this.mode = SessionMode.deep,
    this.distractionCount = 0,
    this.lastDistractionTime,
  });

  /// Unique session identifier
  final String id;

  /// Total session duration
  final Duration totalDuration;

  /// Remaining time in session
  final Duration remainingDuration;

  /// Current session status
  final SessionStatus status;

  /// When the session started
  final DateTime startTime;

  /// When the session was paused (if paused)
  final DateTime? pausedAt;

  /// When the session was completed (if completed)
  final DateTime? completedAt;

  /// Session mode/intensity
  final SessionMode mode;

  /// Number of times user backgrounded the app during session
  final int distractionCount;

  /// Timestamp of last distraction (app backgrounding)
  final DateTime? lastDistractionTime;

  /// Calculate elapsed time
  Duration get elapsedDuration => totalDuration - remainingDuration;

  /// Calculate progress (1.0 to 0.0) - starts full and decreases
  double get progress {
    if (totalDuration.inSeconds == 0) return 0.0;
    return remainingDuration.inSeconds / totalDuration.inSeconds;
  }

  /// Check if session is active (running or paused)
  bool get isActive =>
      status == SessionStatus.running || status == SessionStatus.paused;

  /// Check if session is complete
  bool get isComplete => status == SessionStatus.completed;

  /// Create a copy with updated fields
  FocusSession copyWith({
    String? id,
    Duration? totalDuration,
    Duration? remainingDuration,
    SessionStatus? status,
    DateTime? startTime,
    DateTime? pausedAt,
    DateTime? completedAt,
    SessionMode? mode,
    int? distractionCount,
    DateTime? lastDistractionTime,
  }) {
    return FocusSession(
      id: id ?? this.id,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      pausedAt: pausedAt ?? this.pausedAt,
      completedAt: completedAt ?? this.completedAt,
      mode: mode ?? this.mode,
      distractionCount: distractionCount ?? this.distractionCount,
      lastDistractionTime: lastDistractionTime ?? this.lastDistractionTime,
    );
  }

  @override
  List<Object?> get props => [
    id,
    totalDuration,
    remainingDuration,
    status,
    startTime,
    pausedAt,
    completedAt,
    mode,
    distractionCount,
    lastDistractionTime,
  ];
}

/// Session status enum
enum SessionStatus {
  /// Session is actively running
  running,

  /// Session is paused
  paused,

  /// Session completed successfully
  completed,

  /// Session was cancelled
  cancelled,
}

/// Session mode (matches UI FocusMode but in domain layer)
enum SessionMode {
  /// Light focus mode
  light,

  /// Deep focus mode
  deep,

  /// Ultra focus mode
  ultra,
}
