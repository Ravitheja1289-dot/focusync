# Focusync AI Coding Guidelines

## Project Overview
Focusync is a minimalist Flutter focus timer app built on psychological principles. Philosophy: **calm UX, honest tracking, privacy-first**. No gamification, no cloud sync, no analytics tracking.

## Architecture

### Feature Structure (Clean Architecture)
```
lib/features/<feature>/
  ├── domain/entities/      # Business logic (Equatable models)
  ├── presentation/
  │   ├── screens/         # Full-page widgets
  │   ├── widgets/         # Feature-specific components
  │   └── providers/       # Riverpod state management
```

**Key features:** `focus_session/`, `analytics/`, `settings/`, `home/`

### Core Systems
- **Routing:** GoRouter with custom page transitions ([app_router.dart](lib/core/router/app_router.dart))
- **State:** Riverpod with `StateNotifierProvider` pattern ([session_controller.dart](lib/features/focus_session/presentation/providers/session_controller.dart))
- **Theme:** Dark-first design system with calm colors ([app_theme.dart](lib/core/theme/app_theme.dart))

## State Management Patterns

### Riverpod Usage
```dart
// Define provider
final sessionControllerProvider = 
    StateNotifierProvider<SessionController, SessionState>((ref) => SessionController());

// Watch selectively (avoid unnecessary rebuilds)
final session = ref.watch(
  sessionControllerProvider.select((state) => 
    state is SessionActive ? state.session : null
  )
);

// Read for actions (no rebuild)
ref.read(sessionControllerProvider.notifier).startSession(duration: Duration(minutes: 25));
```

**Critical:** Always use `.select()` when watching only part of state. See [home_screen.dart](lib/features/home/home_screen.dart) lines 22-25.

### Session Lifecycle
[SessionController](lib/features/focus_session/presentation/providers/session_controller.dart) uses sealed classes for type-safe states:
- `SessionIdle` → `SessionActive(running)` → `SessionActive(paused)` → `SessionActive(completed)` → `SessionIdle`
- Implements `WidgetsBindingObserver` for lifecycle awareness (distraction detection on app backgrounding)

## Performance Requirements

**This project has documented performance standards** - see [PERFORMANCE_AUDIT.md](PERFORMANCE_AUDIT.md) and [PERFORMANCE_FIXES.md](PERFORMANCE_FIXES.md).

### Non-Negotiable Rules
1. **Use `const` constructors everywhere possible** - Eliminates 10-30% rebuild overhead
2. **Pre-calculate in `initState`** - Never compute in `build()` or animation frames
3. **Provider selectors** - Always `.select()` to watch specific fields, not entire state
4. **Animation optimization:** 
   - Pre-calculate stagger delays/transformations
   - Check `didUpdateWidget` before restarting animations
   - Cache static paint elements in `CustomPainter`

### Bad Pattern Examples (Do NOT Copy)
```dart
// ❌ Computation in build during animation
Widget build(BuildContext context) {
  final quality = calculateQuality(session); // Recalculates every frame!
}

// ❌ Watching entire state
ref.watch(sessionControllerProvider); // Rebuilds on any state change

// ❌ Non-const static widgets
return SizedBox.shrink(); // Should be: const SizedBox.shrink()
```

## Design System

### Theme Access
```dart
// Colors
AppColors.slate900, AppColors.indigo500, AppColors.accentBlue

// Typography
AppTextStyles.displayLarge, AppTextStyles.titleMedium

// Spacing
AppSpacing.md, AppSpacing.cardRadius, AppSpacing.screenPadding
```

**Design philosophy:** Calm, minimal, no bright colors. Dark theme is primary (see [README.md](README.md#-what-is-focusync)).

## Development Workflow

### Running
```bash
flutter run                    # Debug mode
flutter run --release          # Performance testing
flutter analyze                # Check for warnings
flutter format .               # Format code
```

### Testing
No test infrastructure yet. When adding tests, prioritize:
1. Session state transitions
2. Distraction detection logic
3. Focus quality calculations

## Common Tasks

### Adding a New Screen
1. Create in `lib/features/<feature>/presentation/screens/`
2. Add route in [app_router.dart](lib/core/router/app_router.dart)
3. Use `AppPageTransitions.fade()` or `.slideUp()` for fullscreen
4. Wrap with `ProviderScope` if isolated state needed

### Adding Settings
Settings use local state (TODO: migrate to Riverpod). See [settings_screen.dart](lib/features/settings/presentation/screens/settings_screen.dart).
**Note:** `settings_screen_optimized.dart` exists as performance reference.

### Session Timer Logic
Timer uses 1-second ticks with drift correction ([session_controller.dart](lib/features/focus_session/presentation/providers/session_controller.dart) lines 145-180). Always use `_lastTickTime` to calculate actual elapsed time, not tick count.

## Privacy & Data

- **No backend** - Everything local
- **No analytics** - No telemetry of any kind
- **TODO items** for data persistence (Isar mentioned in README but not implemented)

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- See [CONTRIBUTING.md](CONTRIBUTING.md) lines 200-280 for widget/state patterns
- Extract complex widgets into private methods (`_buildHeader()`) or separate widgets
- TODO comments mark incomplete features - check before referencing as complete

## Key Files Reference
- Session state machine: [session_controller.dart](lib/features/focus_session/presentation/providers/session_controller.dart)
- Session entity: [focus_session.dart](lib/features/focus_session/domain/entities/focus_session.dart)
- Custom timer widget: [circular_focus_timer.dart](lib/core/widgets/circular_focus_timer.dart)
- Navigation config: [app_router.dart](lib/core/router/app_router.dart)

## Questions to Ask Before Coding
1. Can this widget be `const`?
2. Am I watching the entire provider or using `.select()`?
3. Are there calculations that should be in `initState`?
4. Does this fit the "calm, minimal" design philosophy?
5. Am I adding telemetry/analytics? (Answer must be NO)
