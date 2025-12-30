import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_page_transitions.dart';
import '../../features/home/home_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

// TODO: Import actual screens when they're created
// For now, using placeholder screens

/// Focusync app router configuration
///
/// Handles all navigation with custom transitions and deep linking support.
class AppRouter {
  AppRouter._();

  /// Global router instance
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,

    routes: [
      // ========================================================================
      // MAIN SHELL (Bottom Navigation)
      // ========================================================================
      ShellRoute(
        builder: (context, state, child) {
          // TODO: Replace with actual MainScaffold with bottom nav
          return _MainScaffold(child: child);
        },
        routes: [
          // Home screen
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => AppPageTransitions.fade(
              child: const HomeScreen(),
              context: context,
            ),
          ),

          // History screen
          GoRoute(
            path: AppRoutes.history,
            pageBuilder: (context, state) => AppPageTransitions.fade(
              child: const AnalyticsScreen(),
              context: context,
            ),
          ),

          // Settings screen
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => AppPageTransitions.fade(
              child: const SettingsScreen(),
              context: context,
            ),
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
class _MainScaffold extends StatefulWidget {
  const _MainScaffold({required this.child});

  final Widget child;

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

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
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine selected index from location without setState
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = location == AppRoutes.home
        ? 0
        : location == AppRoutes.history
        ? 1
        : location == AppRoutes.settings
        ? 2
        : 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _onItemTapped,
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
