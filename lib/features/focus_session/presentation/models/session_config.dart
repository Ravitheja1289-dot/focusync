import 'package:flutter/material.dart';

/// Session configuration model
class SessionConfig {
  const SessionConfig({
    required this.focusDuration,
    this.breakDuration = const Duration(minutes: 5),
    this.focusMode = FocusMode.deep,
    this.blockedApps = const [],
    this.enableBreak = true,
  });

  /// Duration of focus session
  final Duration focusDuration;

  /// Duration of break (if enabled)
  final Duration breakDuration;

  /// Selected focus mode
  final FocusMode focusMode;

  /// Apps/websites to block
  final List<String> blockedApps;

  /// Whether to include a break after session
  final bool enableBreak;

  SessionConfig copyWith({
    Duration? focusDuration,
    Duration? breakDuration,
    FocusMode? focusMode,
    List<String>? blockedApps,
    bool? enableBreak,
  }) {
    return SessionConfig(
      focusDuration: focusDuration ?? this.focusDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      focusMode: focusMode ?? this.focusMode,
      blockedApps: blockedApps ?? this.blockedApps,
      enableBreak: enableBreak ?? this.enableBreak,
    );
  }

  /// Default configuration (25 min focus)
  static const defaultConfig = SessionConfig(
    focusDuration: Duration(minutes: 25),
  );

  /// Quick focus (15 min)
  static const quickConfig = SessionConfig(
    focusDuration: Duration(minutes: 15),
  );

  /// Extended focus (45 min)
  static const extendedConfig = SessionConfig(
    focusDuration: Duration(minutes: 45),
  );

  /// Deep work (60 min)
  static const deepWorkConfig = SessionConfig(
    focusDuration: Duration(minutes: 60),
    breakDuration: Duration(minutes: 10),
  );
}

/// Focus mode presets
enum FocusMode {
  /// Light focus - gentle reminders
  light,

  /// Deep focus - strong blocking
  deep,

  /// Ultra focus - maximum blocking
  ultra,
}

extension FocusModeExtension on FocusMode {
  String get label {
    switch (this) {
      case FocusMode.light:
        return 'Light';
      case FocusMode.deep:
        return 'Deep';
      case FocusMode.ultra:
        return 'Ultra';
    }
  }

  String get description {
    switch (this) {
      case FocusMode.light:
        return 'Gentle reminders';
      case FocusMode.deep:
        return 'Block distractions';
      case FocusMode.ultra:
        return 'Maximum blocking';
    }
  }

  IconData get icon {
    switch (this) {
      case FocusMode.light:
        return Icons.lightbulb_outline;
      case FocusMode.deep:
        return Icons.shield_outlined;
      case FocusMode.ultra:
        return Icons.lock_outline;
    }
  }
}
