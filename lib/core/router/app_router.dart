import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_page_transitions.dart';
import '../theme/app_colors.dart';
import '../../features/home/home_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/auth/presentation/screens/lock_screen.dart';
import '../../features/splash/splash_screen.dart';

// TODO: Import actual screens when they're created
// For now, using placeholder screens

/// Focusync app router configuration
///
/// Handles all navigation with custom transitions and deep linking support.
class AppRouter {
  AppRouter._();

  /// Global router instance
  static final GoRouter router = GoRouter(
    initialLocation: '/lock',
    debugLogDiagnostics: true,

    routes: [
      // ========================================================================
      // LOCK SCREEN (Initial Entry)
      // ========================================================================
      GoRoute(
        path: '/lock',
        pageBuilder: (context, state) => AppPageTransitions.fade(
          child: const LockScreen(),
          context: context,
        ),
      ),

      // ========================================================================
      // SPLASH SCREEN
      // ========================================================================
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => AppPageTransitions.fade(
          child: const SplashScreen(),
          context: context,
        ),
      ),

      // ========================================================================
      // MAIN SHELL (Bottom Navigation)
      // ========================================================================
      ShellRoute(
        builder: (context, state, child) {
          return _MainScaffold(child: child);
        },
        routes: [
          // Home screen
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),

          // History screen
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const AnalyticsScreen(),
          ),

          // Settings screen
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),

          // Account screen
          GoRoute(
            path: AppRoutes.account,
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),

      // ========================================================================
      // SESSION ROUTES (Full-Screen, No Bottom Nav)
      // ========================================================================

      // Active session screen
      GoRoute(
        path: '/session/:id',
        pageBuilder: (context, state) {
          final sessionId = state.pathParameters['id'] ?? '';
          return AppPageTransitions.slideUp(
            child: _PlaceholderScreen(
              title: 'Session $sessionId',
              icon: Icons.timer,
              fullScreen: true,
            ),
            context: context,
          );
        },
      ),

      // Session complete screen
      GoRoute(
        path: '/session/:id/complete',
        pageBuilder: (context, state) {
          final sessionId = state.pathParameters['id'] ?? '';
          return AppPageTransitions.scaleFade(
            child: _PlaceholderScreen(
              title: 'Complete $sessionId',
              icon: Icons.check_circle,
              fullScreen: true,
            ),
            context: context,
          );
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => const _ErrorScreen(),
  );
}

// =============================================================================
// PLACEHOLDER WIDGETS (TO BE REPLACED)
// =============================================================================

/// Temporary main scaffold with bottom navigation
class _MainScaffold extends StatelessWidget {
  const _MainScaffold({required this.child});

  final Widget child;

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.history);
        break;
      case 2:
        context.go(AppRoutes.settings);
        break;
      case 3:
        context.go(AppRoutes.account);
        break;
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.home) return 0;
    if (location == AppRoutes.history) return 1;
    if (location == AppRoutes.settings) return 2;
    if (location == AppRoutes.account) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

/// Placeholder screen for development
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    this.fullScreen = false,
  });

  final String title;
  final IconData icon;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fullScreen ? null : AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (fullScreen) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Back to Home'),
              ),
            ],
            if (title == 'Home') ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/session/test-123'),
                child: const Text('Start Session (Demo)'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error screen for navigation failures
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
