/// Route path constants for Focusync navigation
class AppRoutes {
  AppRoutes._();

  // ============================================================================
  // MAIN ROUTES (Bottom Navigation)
  // ============================================================================

  /// Home screen - Session start
  static const String home = '/';

  /// Analytics & focus history
  static const String history = '/history';

  /// App settings
  static const String settings = '/settings';

  /// Account screen
  static const String account = '/account';

  // ============================================================================
  // AUTH ROUTES
  // ============================================================================

  /// Lock screen
  static const String lock = '/lock';

  /// Splash screen
  static const String splash = '/splash';

  // ============================================================================
  // SESSION ROUTES (Full-Screen, Immersive)
  // ============================================================================

  /// Active focus session (full-screen, no nav)
  static const String session = '/session/:id';

  /// Session completion celebration
  static const String sessionComplete = '/session/:id/complete';

  // ============================================================================
  // ROUTE BUILDERS (Type-safe route construction)
  // ============================================================================

  /// Build session route with ID
  static String buildSessionRoute(String sessionId) {
    return '/session/$sessionId';
  }

  /// Build session complete route with ID
  static String buildSessionCompleteRoute(String sessionId) {
    return '/session/$sessionId/complete';
  }
}
