# Flutter Performance Quick Reference

## 🎯 Quick Wins (Copy-Paste Ready)

### 1. Add Haptic Feedback
```dart
import 'package:flutter/services.dart';

// Light tap (buttons, toggles)
HapticFeedback.lightImpact();

// Medium (warnings, errors)
HapticFeedback.mediumImpact();

// Heavy (success, completion)
HapticFeedback.heavyImpact();
```

### 2. Loading Button
```dart
ElevatedButton(
  onPressed: _isLoading ? null : _onTap,
  child: _isLoading 
    ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : const Text('Start'),
)
```

### 3. Empty State Widget
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.info_outline, size: 64, color: AppColors.gray600),
      const SizedBox(height: 16),
      Text('No data yet', style: AppTypography.h3),
      const SizedBox(height: 8),
      Text('Get started below', style: AppTypography.body),
    ],
  ),
)
```

### 4. Granular Provider Watch
```dart
// ❌ Bad: Rebuilds on any state change
final session = ref.watch(sessionProvider).session;

// ✅ Good: Only rebuilds when session changes
final session = ref.watch(
  sessionProvider.select((s) => s.session),
);
```

### 5. Prevent Animation Restart
```dart
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  
  if (oldWidget.data != widget.data && !_controller.isAnimating) {
    _controller.reset();
    _controller.forward();
  }
}
```

### 6. Efficient CustomPainter
```dart
@override
bool shouldRepaint(MyPainter old) {
  // Only repaint if values actually changed
  return old.value != value || old.color != color;
}
```

### 7. Const Everything
```dart
// ❌ Bad
return SizedBox.shrink();
return Text('Hello');
return Icon(Icons.star);

// ✅ Good
return const SizedBox.shrink();
return const Text('Hello');
return const Icon(Icons.star);
```

### 8. Extract Build Methods
```dart
// ❌ Bad: Large build method
Widget build(BuildContext context) {
  return Column(
    children: [
      Container(/* 50 lines */),
      Container(/* 50 lines */),
      Container(/* 50 lines */),
    ],
  );
}

// ✅ Good: Extracted widgets
Widget build(BuildContext context) {
  return Column(
    children: [
      _HeaderSection(),
      _ContentSection(),
      _FooterSection(),
    ],
  );
}

Widget _HeaderSection() => Container(/* ... */);
```

### 9. Keys for Lists
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return MyWidget(
      key: ValueKey(items[index].id), // Add this!
      data: items[index],
    );
  },
)
```

### 10. Side Effects with Riverpod
```dart
// ❌ Bad: Navigation in build
Widget build(BuildContext context) {
  final state = ref.watch(provider);
  if (state.isComplete) {
    Navigator.pop(context); // Anti-pattern!
  }
}

// ✅ Good: Use ref.listen
Widget build(BuildContext context) {
  ref.listen(provider, (prev, next) {
    if (next.isComplete) {
      Navigator.pop(context);
    }
  });
}
```

---

## 🐛 Common Issues & Fixes

### Issue: "Widget rebuilds too often"
**Fix:** Use `select` or extract to separate widget
```dart
// Extract to StatefulWidget with local state
class _SettingsToggle extends StatefulWidget { ... }
```

### Issue: "Animation stutters"
**Fix:** Pre-calculate values outside paint/build
```dart
// In initState or at class level
final _cachedValues = List.generate(7, (i) => i * 0.08);
```

### Issue: "setState causes lag"
**Fix:** Minimize rebuild scope
```dart
// Only rebuild the changing part
return Column(
  children: [
    const StaticHeader(),  // Won't rebuild
    DynamicContent(data),  // Will rebuild
  ],
);
```

### Issue: "Navigation doesn't work"
**Fix:** Use consistent pattern
```dart
// Use context.go() for shell routes
context.go(AppRoutes.home);

// Use Navigator.push for dialogs/modals
Navigator.push(context, route);
```

### Issue: "Memory leak with animation"
**Fix:** Always dispose controllers
```dart
@override
void dispose() {
  _controller.dispose();
  _timer?.cancel();
  super.dispose();
}
```

---

## ✅ Pre-Commit Checklist

Before committing new widgets:
- [ ] All static widgets marked `const`
- [ ] AnimationControllers disposed in `dispose()`
- [ ] No `setState` in build method
- [ ] Provider watches use `select` when possible
- [ ] CustomPainters have efficient `shouldRepaint`
- [ ] Large build methods extracted to separate widgets
- [ ] Keys added to lists with dynamic data
- [ ] Side effects use `ref.listen` not build method

---

## 📐 Architecture Patterns

### State Management Hierarchy
```
1. Local State (setState)
   ↓
2. Inherited Widget (Theme, MediaQuery)
   ↓
3. Provider/Riverpod (App state)
   ↓
4. Database (Persistence)
```

**Rule:** Use lowest level that works for your use case.

### Widget Extraction Rules
- Extract if widget > 50 lines
- Extract if used multiple times
- Extract if widget has own state
- Extract if widget has expensive calculations

### Animation Best Practices
- Use single controller for coordinated animations
- Dispose all controllers
- Check `isAnimating` before replaying
- Pre-calculate interpolation values
- Use `AnimatedBuilder` for partial rebuilds

---

## 🔥 Performance Red Flags

### Immediate Action Required:
- ❌ `setState()` in build method
- ❌ Animation controller not disposed
- ❌ Navigation in build without postFrameCallback
- ❌ Provider watch without select on large state

### Should Fix Soon:
- ⚠️ Build method > 100 lines
- ⚠️ Missing `const` on static widgets
- ⚠️ CustomPainter `shouldRepaint` returns true
- ⚠️ Lists without keys

### Nice to Have:
- 💡 Extract reusable widgets
- 💡 Add loading states
- 💡 Add empty states
- 💡 Add error boundaries

---

## 📊 Performance Tools

### Enable Performance Overlay
```bash
flutter run --profile
```

### Check for Rebuilds
```dart
@override
Widget build(BuildContext context) {
  print('Building MyWidget'); // Add temporarily
  return ...;
}
```

### Timeline Tracing
```dart
import 'dart:developer';

Timeline.startSync('ExpensiveOperation');
// ... expensive code ...
Timeline.finishSync();
```

### Memory Profiling
```bash
flutter run --profile
# Then open DevTools
```

---

## 🎓 Learning Resources

- [Flutter Performance Docs](https://flutter.dev/docs/perf)
- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/reading)
- [Flutter Performance Profiling](https://flutter.dev/docs/perf/rendering/ui-performance)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

## 💡 Quick Debugging Tips

### Find Performance Issues:
1. Run in profile mode: `flutter run --profile`
2. Open DevTools performance tab
3. Look for red bars (dropped frames)
4. Check timeline for expensive operations
5. Add print statements to track rebuilds

### Optimize Hot Spots:
1. Identify widget that rebuilds too often
2. Check if it needs full rebuild or just part
3. Extract changing part to separate widget
4. Add keys if it's in a list
5. Use provider select if watching state

### Verify Improvements:
1. Before: Record timeline
2. Apply optimization
3. After: Record timeline again
4. Compare frame times
5. Confirm no functionality regression
