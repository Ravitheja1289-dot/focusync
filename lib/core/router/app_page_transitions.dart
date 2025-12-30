import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

/// Custom page transitions for Focusync navigation
///
/// All transitions respect the calm motion principles and accessibility settings.
class AppPageTransitions {
  AppPageTransitions._();

  // ============================================================================
  // FADE TRANSITION (Bottom Nav, Settings)
  // ============================================================================

  /// Simple fade transition for minimal movement
  static CustomTransitionPage<T> fade<T>({
    required Widget child,
    required BuildContext context,
    Duration? duration,
  }) {
    return CustomTransitionPage<T>(
      child: child,
      transitionDuration: duration ?? AppMotion.fast,
      reverseTransitionDuration: duration ?? AppMotion.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: AppMotion.calm).animate(animation),
          child: child,
        );
      },
    );
  }

  // ============================================================================
  // SLIDE UP (Session Start)
  // ============================================================================

  /// Slide up from bottom with fade - for elevating into focus
  static CustomTransitionPage<T> slideUp<T>({
    required Widget child,
    required BuildContext context,
  }) {
    return CustomTransitionPage<T>(
      child: child,
      transitionDuration: AppMotion.slow,
      reverseTransitionDuration: AppMotion.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final shouldReduce = MediaQuery.of(context).disableAnimations;

        if (shouldReduce) {
          return child;
        }

        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0.0, 1.0), // Start from bottom
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: AppMotion.decelerate),
            );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: AppMotion.calm));

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }

  // ============================================================================
  // SLIDE DOWN (Dismiss/Back)
  // ============================================================================

  /// Slide down with fade - for returning from session
  static CustomTransitionPage<T> slideDown<T>({
    required Widget child,
    required BuildContext context,
  }) {
    return CustomTransitionPage<T>(
      child: child,
      transitionDuration: AppMotion.normal,
      reverseTransitionDuration: AppMotion.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final shouldReduce = MediaQuery.of(context).disableAnimations;

        if (shouldReduce) {
          return child;
        }

        // For reverse transition (going back)
        if (secondaryAnimation.status == AnimationStatus.forward ||
            secondaryAnimation.status == AnimationStatus.completed) {
          final offsetAnimation =
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0.0, 1.0), // Exit to bottom
              ).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: AppMotion.accelerate,
                ),
              );

          final fadeAnimation = Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(secondaryAnimation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        }

        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // ============================================================================
  // SCALE FADE (Celebration, Completion)
  // ============================================================================

  /// Scale up with fade - for celebration moments
  static CustomTransitionPage<T> scaleFade<T>({
    required Widget child,
    required BuildContext context,
  }) {
    return CustomTransitionPage<T>(
      child: child,
      transitionDuration: AppMotion.luxurious,
      reverseTransitionDuration: AppMotion.normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final shouldReduce = MediaQuery.of(context).disableAnimations;

        if (shouldReduce) {
          return child;
        }

        final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: AppMotion.decelerate),
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: AppMotion.calm));

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }

  // ============================================================================
  // NO TRANSITION (Instant)
  // ============================================================================

  /// No animation - instant navigation
  static Page<T> instant<T>({required Widget child, LocalKey? key}) {
    return MaterialPage<T>(key: key, child: child);
  }
}

/// Helper extension for CustomTransitionPage
class CustomTransitionPage<T> extends Page<T> {
  const CustomTransitionPage({
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.reverseTransitionDuration = const Duration(milliseconds: 250),
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final RouteTransitionsBuilder transitionsBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }
}
