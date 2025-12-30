# Contributing to Focusync

First off, thank you for considering contributing to Focusync! It's people like you who make Focusync a great tool for mindful productivity.

## Code of Conduct

This project and everyone participating in it is governed by our commitment to creating a welcoming and respectful environment. By participating, you are expected to uphold these values:

- **Be respectful** - Treat everyone with respect
- **Be constructive** - Focus on what's best for the community
- **Be understanding** - Accept that people have different perspectives
- **Be patient** - Good things take time

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**Good bug reports include:**
- A clear title and description
- Steps to reproduce the behavior
- Expected behavior vs actual behavior
- Screenshots if applicable
- Device and OS information
- Focusync version

**Example:**

```markdown
**Title:** Timer doesn't pause when pressing pause button

**Description:** When I tap the pause button during a focus session, the timer continues counting down.

**Steps to Reproduce:**
1. Start a focus session
2. Wait 30 seconds
3. Tap the pause button
4. Observe timer continues

**Expected:** Timer should pause
**Actual:** Timer keeps running

**Device:** iPhone 13, iOS 16.5
**Version:** Focusync 1.0.0
```

### Suggesting Features

We love feature suggestions! But keep in mind Focusync's philosophy:
- **Calm over gamified** - No badges, points, or artificial pressure
- **Privacy-first** - No cloud requirements or data collection
- **Meaningful metrics** - No vanity stats
- **Simple and focused** - Not every feature fits

**Good feature suggestions include:**
- Clear description of the feature
- Why it would be useful (use case)
- How it fits with Focusync's philosophy
- Mockups or examples if applicable

### Pull Requests

**Before starting major work:**
1. Open an issue to discuss the feature/fix
2. Wait for maintainer feedback
3. Get consensus before investing significant time

**Pull Request Process:**

1. **Fork & Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Follow Code Style**
   - Run `flutter format .`
   - Run `flutter analyze`
   - Fix all warnings and errors

3. **Write Good Commits**
   ```
   Add breathing animation to break screen

   - Implement 4-4-6-2 breathing pattern
   - Add progress dots indicating cycle position
   - Smooth scale and opacity animations

   Closes #123
   ```

4. **Update Documentation**
   - Update README.md if needed
   - Add inline code comments for complex logic
   - Update CHANGELOG.md

5. **Test Thoroughly**
   - Test on multiple devices if possible
   - Test both light and dark modes (when available)
   - Ensure no performance regressions

6. **Create PR**
   - Write clear description
   - Reference related issues
   - Add screenshots/videos if UI changes

## Development Setup

### Prerequisites
- Flutter 3.x
- Dart 3.10.4+
- Git
- Your favorite IDE (VS Code recommended)

### Setup Steps

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/focusync.git
cd focusync

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/focusync.git

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Project Structure

```
lib/
├── core/                  # Shared code
│   ├── theme/            # Design system
│   ├── router/           # Navigation
│   └── widgets/          # Reusable widgets
├── features/             # Feature modules
│   ├── focus_session/    # Session management
│   ├── analytics/        # Focus analytics
│   ├── settings/         # App settings
│   └── home/            # Home screen
└── main.dart            # App entry point
```

### Code Style Guide

#### Dart Style
- Use [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Run `flutter format .` before committing
- Fix all `flutter analyze` warnings

#### Widget Guidelines
```dart
// ✅ Good: Const constructor when possible
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}

// ✅ Good: Extract complex widgets
Widget build(BuildContext context) {
  return Column(
    children: [
      _HeaderSection(),
      _ContentSection(),
      _FooterSection(),
    ],
  );
}

// ❌ Bad: Giant build methods
Widget build(BuildContext context) {
  return Column(
    children: [
      // 200 lines of nested widgets...
    ],
  );
}
```

#### State Management
```dart
// ✅ Good: Use Riverpod providers
final sessionProvider = StateNotifierProvider<SessionController, SessionState>(
  (ref) => SessionController(),
);

// ✅ Good: Select only what you need
final session = ref.watch(
  sessionProvider.select((s) => s.session),
);

// ❌ Bad: Watch entire provider unnecessarily
final state = ref.watch(sessionProvider);
```

#### Performance
```dart
// ✅ Good: Dispose controllers
@override
void dispose() {
  _controller.dispose();
  _timer?.cancel();
  super.dispose();
}

// ✅ Good: Use const for static widgets
return const SizedBox.shrink();

// ✅ Good: Prevent unnecessary rebuilds
@override
bool shouldRepaint(MyPainter old) {
  return old.value != value;
}
```

#### Documentation
```dart
/// Circular timer widget with smooth progress animation
/// 
/// Features:
/// - 60fps smooth animation
/// - State-based color changes
/// - Configurable size and stroke width
class CircularFocusTimer extends StatefulWidget {
  /// Creates a circular focus timer
  const CircularFocusTimer({
    super.key,
    required this.progress,
    required this.state,
  });

  /// Progress value from 0.0 to 1.0
  final double progress;
  
  /// Current timer state (affects color)
  final TimerState state;
}
```

## Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/session_controller_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests
```dart
void main() {
  group('SessionController', () {
    test('starts session correctly', () {
      final controller = SessionController();
      
      controller.startSession(duration: Duration(minutes: 25));
      
      expect(controller.state, isA<SessionActive>());
    });
    
    test('calculates focus quality correctly', () {
      final session = FocusSession(
        distractionCount: 2,
        totalDuration: Duration(minutes: 25),
      );
      
      final quality = calculateFocusQuality(session);
      
      expect(quality, greaterThan(0.9));
    });
  });
}
```

## Design Guidelines

### Color Palette
- **Primary:** Indigo 500 (#6366F1)
- **Background:** Slate 950 (#020617)
- **Text:** White/Gray scale
- **Accents:** Use sparingly for emphasis

### Typography
- **Headings:** Bold, clear hierarchy
- **Body:** Regular weight, good readability
- **Sizes:** 11px (caption) to 32px (h1)

### Motion
- **Duration:** 200-800ms
- **Curves:** easeOut, easeInOut, easeOutCubic
- **Principle:** Calm, not jarring

### Spacing
- **xs:** 4px
- **sm:** 8px
- **md:** 16px
- **lg:** 24px
- **xl:** 32px

## Release Process

### Version Numbers
We use [Semantic Versioning](https://semver.org/):
- **Major (1.0.0):** Breaking changes
- **Minor (1.1.0):** New features, backwards compatible
- **Patch (1.0.1):** Bug fixes

### Release Checklist
- [ ] All tests pass
- [ ] No analyzer warnings
- [ ] CHANGELOG.md updated
- [ ] Version bumped in pubspec.yaml
- [ ] README.md updated if needed
- [ ] Tested on iOS and Android
- [ ] Performance profiled (no regressions)
- [ ] Create git tag
- [ ] Build release artifacts
- [ ] Update GitHub release notes

## Community

### Getting Help
- **GitHub Discussions:** For questions and ideas
- **GitHub Issues:** For bugs and feature requests
- **Code Review:** PR comments for code feedback

### Recognition
Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Thanked profusely! 🙏

## Philosophy Alignment

When contributing, please keep Focusync's core principles in mind:

✅ **Do:**
- Make features calm and distraction-free
- Respect user privacy (local-first)
- Provide meaningful insights
- Keep UI simple and focused
- Add smooth, professional animations
- Write clear documentation

❌ **Don't:**
- Add gamification (badges, points, levels)
- Add social features (leaderboards, sharing)
- Add vanity metrics (lifetime totals)
- Add anxiety-inducing notifications
- Add aggressive monetization
- Add tracking or analytics

## Questions?

If you're unsure about anything:
1. Check existing issues and discussions
2. Ask in a GitHub Discussion
3. Open a draft PR for early feedback

We're friendly and happy to help!

---

**Thank you for making Focusync better! 🙏**

Every contribution, no matter how small, helps people work with more intention and less stress.
