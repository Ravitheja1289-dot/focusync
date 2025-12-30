import 'package:flutter/material.dart';

/// Focusync motion and animation constants
///
/// Defines easing curves, durations, and motion principles for animations.
class AppMotion {
  AppMotion._();

  // ============================================================================
  // EASING CURVES
  // ============================================================================

  /// Standard curve (default for most animations)
  static const Cubic standard = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Decelerate curve (for entry animations)
  static const Cubic decelerate = Cubic(0.0, 0.0, 0.2, 1.0);

  /// Accelerate curve (for exit animations)
  static const Cubic accelerate = Cubic(0.4, 0.0, 1.0, 1.0);

  /// Sharp curve (for instant feel)
  static const Cubic sharp = Cubic(0.4, 0.0, 0.6, 1.0);

  /// Calm curve (Focusync custom - gentle, slow)
  static const Cubic calm = Cubic(0.25, 0.1, 0.25, 1.0);

  // ============================================================================
  // DURATION SCALE
  // ============================================================================

  /// 50ms - Instant interactions (checkbox, radio)
  static const Duration instant = Duration(milliseconds: 50);

  /// 150ms - Fast interactions (button press, chip select)
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms - Normal transitions (default)
  static const Duration normal = Duration(milliseconds: 250);

  /// 400ms - Slow transitions (screen changes, modals)
  static const Duration slow = Duration(milliseconds: 400);

  /// 600ms - Luxurious animations (celebrations, onboarding)
  static const Duration luxurious = Duration(milliseconds: 600);

  // ============================================================================
  // COMMON ANIMATION PATTERNS
  // ============================================================================

  /// Button press animation (scale down slightly)
  static const double buttonPressScale = 0.98;

  /// Modal scale animation (start slightly smaller)
  static const double modalInitialScale = 0.9;

  /// Ripple expand duration
  static const Duration rippleDuration = Duration(milliseconds: 200);

  /// Breathing animation cycle (4s inhale + 4s exhale)
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
  static Curve getCurve(BuildContext context, {Curve defaultCurve = calm}) {
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
  Curve curve([Curve defaultCurve = AppMotion.calm]) {
    return AppMotion.getCurve(this, defaultCurve: defaultCurve);
  }

  /// Check if animations should be disabled
  bool get shouldReduceMotion => MediaQuery.of(this).disableAnimations;
}
