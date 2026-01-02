import 'package:flutter/material.dart';

/// Focusync motion and animation constants
///
/// Defines easing curves, durations, and motion principles for animations.
class AppMotion {
  AppMotion._();

  // ============================================================================
  // EASING CURVES (Frozen Minimal Design)
  // ============================================================================

  /// Linear - no easing, purely functional (state transitions)
  static const Curve linear = Curves.linear;

  /// Calm - minimal easing for subtle feedback only
  /// Used for: color fades, opacity changes
  static const Cubic calm = Cubic(0.25, 0.1, 0.25, 1.0);

  // ============================================================================
  // DURATION SCALE (Frozen Minimal Design)
  // ============================================================================

  /// 0ms - Instant (no motion, immediate state change)
  /// Use for: state changes that don't need visual communication
  static const Duration instant = Duration.zero;

  /// 100ms - Subtle (minimal feedback)
  /// Use for: opacity fades, color transitions
  static const Duration subtle = Duration(milliseconds: 100);

  /// 150ms - Fast (quick state communication)
  /// Use for: timer ring updates, pause icon appearance
  static const Duration fast = Duration(milliseconds: 150);

  /// 200ms - Normal (screen transitions only)
  /// Use for: navigation between screens
  static const Duration normal = Duration(milliseconds: 200);

  // ============================================================================
  // MOTION POLICY (Frozen Minimal Design)
  // ============================================================================

  /// ✅ ALLOWED: Motion that communicates state changes
  /// - Timer progress ring updates (linear, 150ms)
  /// - Session state transitions (pause → running, color fade 100ms)
  /// - Screen navigation (fade 200ms)
  /// - Opacity changes for appear/disappear (100ms)
  ///
  /// ❌ FORBIDDEN: Motion for delight or decoration
  /// - Bouncy/elastic easing (easeOutBack, easeInOutBack)
  /// - Scale animations (growing/shrinking)
  /// - Staggered animations
  /// - Particle effects
  /// - Ripple effects
  /// - Breathing/pulsing animations (use static visual instead)
  /// - Slide transitions with physics
  /// - Any animation > 200ms
  /// - Multiple simultaneous animations
  ///
  /// Breathing animation cycle (informational only, not animated)
  static const Duration breathingCycle = Duration(seconds: 8);

  // ============================================================================
  // ANIMATION CONFIGURATIONS
  // ============================================================================

  /// Get duration respecting user's reduce motion setting
  static Duration getDuration(BuildContext context, Duration defaultDuration) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return reduceMotion ? Duration.zero : defaultDuration;
  }

  /// Get curve respecting user's reduce motion setting
  /// Default is linear (no easing) per frozen minimal design
  static Curve getCurve(BuildContext context, {Curve defaultCurve = linear}) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return reduceMotion ? Curves.linear : defaultCurve;
  }
}

/// Extension for easily creating common animations
extension AnimationExtension on BuildContext {
  /// Get animation duration respecting accessibility settings
  Duration duration(Duration defaultDuration) {
    return AppMotion.getDuration(this, defaultDuration);
  }

  /// Get animation curve respecting accessibility settings
  /// Default is linear (no easing) per frozen minimal design
  Curve curve([Curve defaultCurve = AppMotion.linear]) {
    return AppMotion.getCurve(this, defaultCurve: defaultCurve);
  }

  /// Check if animations should be disabled
  bool get shouldReduceMotion => MediaQuery.of(this).disableAnimations;
}
