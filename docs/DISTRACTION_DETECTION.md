# Distraction Detection Implementation

## Overview

Focusync implements **distraction detection** by monitoring when users leave the app during an active focus session. This feature tracks app backgrounding events and displays contextual warnings to encourage sustained focus.

## What's Implemented

### 1. **Distraction Tracking** ✅
- Counts how many times the app is backgrounded during a focus session
- Records timestamp of last distraction
- Persists distraction count in session state
- Integrated with existing `WidgetsBindingObserver` lifecycle management

### 2. **Visual Feedback** ✅
- **Warning Overlay**: Appears when user returns after backgrounding
  - Auto-dismisses after 4 seconds
  - Progressive messaging based on distraction count
  - Color-coded severity (amber → orange → red)
  - Smooth fade-in/slide animation
  
- **Distraction Counter**: Persistent indicator in top bar showing total distractions

### 3. **Progressive Warnings** ✅
- **1st distraction**: "Stay focused. You've got this." (amber, info icon)
- **2nd distraction**: "Second distraction detected." (amber, info icon)
- **3-5 distractions**: "Multiple distractions detected." (orange, warning icon)
- **6+ distractions**: "Struggling to focus? Take a break." (red, error icon)

## How It Works

### Detection Logic
```dart
// In SessionController.didChangeAppLifecycleState()
case AppLifecycleState.paused:
case AppLifecycleState.inactive:
  if (currentSession.status == SessionStatus.running) {
    _recordDistraction(); // Increment counter + timestamp
    _stopTimer();         // Pause timer during background
  }
```

### Lifecycle States
- **`paused`**: App completely in background (Android/iOS)
- **`inactive`**: App losing focus temporarily (iOS app switcher, system overlays)
- **`resumed`**: App returns to foreground → show warning if new distraction

### Data Flow
1. User switches away from Focusync during active session
2. `WidgetsBindingObserver` detects `AppLifecycleState.paused`
3. `SessionController._recordDistraction()` increments count
4. Session state updates with new `distractionCount` and `lastDistractionTime`
5. User returns → `AppLifecycleState.resumed` triggered
6. `ActiveFocusScreen` detects count change → shows warning overlay
7. Overlay auto-dismisses after 4 seconds (or manual dismiss)

## Platform Limitations

### ❌ **Cannot Prevent App Switching**
**All Platforms**: Flutter apps run in a sandboxed environment and **cannot** block users from:
- Opening other apps
- Switching to home screen
- Receiving phone calls/notifications
- Using system gestures (app switcher, control center)

**Why**: Operating systems enforce strict app isolation for security and UX. Only system-level services or apps with special privileges (accessibility services, MDM) can restrict app switching.

### ❌ **Cannot Block Specific Apps**
**iOS**: No API to detect or block other apps. App Store guidelines prohibit interference with system functionality.

**Android**: Would require:
- `UsageStatsManager` permission (user must manually grant in Settings)
- `AccessibilityService` (often flagged by Google Play)
- Device Admin privileges (enterprise use cases only)
- Even then, blocking is unreliable and easily bypassed

**Verdict**: Not feasible for consumer app store distribution.

### ❌ **Limited Background Execution**
**iOS**: Apps are suspended 3-5 seconds after backgrounding. Timer accuracy is not guaranteed.

**Android**: Background execution limits (Doze mode, battery optimization) may pause timers.

**Workaround**: We use **`DateTime`-based calculations** instead of relying on timer ticks. When the app resumes, `_recalculateTimeFromBackground()` computes exact elapsed time.

### ⚠️ **Web/Desktop Limitations**
**Web**: Can only detect window blur/focus. Cannot detect:
- Which apps/tabs are opened
- Whether user is in another browser window
- System-level distractions

**Desktop (Windows/macOS/Linux)**: Similar to web—can detect window focus loss but cannot identify or block specific applications.

### ⚠️ **Detection Edge Cases**
These scenarios **may or may not** trigger distraction warnings:

| Scenario | iOS | Android | Web/Desktop |
|----------|-----|---------|-------------|
| Phone call incoming | ✅ Yes | ✅ Yes | ❌ No |
| System notification panel | ✅ Yes | ✅ Yes | ❌ No |
| App switcher view | ⚠️ Sometimes | ⚠️ Sometimes | ❌ No |
| Control center (iOS) | ⚠️ Sometimes | N/A | ❌ No |
| Lock screen | ✅ Yes | ✅ Yes | ⚠️ Depends |
| Split-screen mode | ❌ No | ❌ No | ❌ No |
| Picture-in-picture | ❌ No | ❌ No | ❌ No |

**Split-screen**: App remains visible and `resumed`, so no distraction is recorded. This is **intentional**—we only track full backgrounding.

## User Experience Considerations

### Why We Don't Block
1. **App Store Policies**: Both Apple and Google prohibit apps that restrict device functionality
2. **User Autonomy**: Emergencies happen—users must retain control of their device
3. **Ethical Design**: Guilt-free motivation > forced compliance
4. **Technical Reality**: Blocking is impossible without system-level access

### Our Approach: Awareness, Not Punishment
- **Gentle reminders** instead of aggressive blocking
- **Progressive warnings** that escalate with repeated distractions
- **Actionable feedback**: "Struggling to focus? Take a break."
- **Transparency**: Users see their distraction count and can reflect on patterns

### Future Enhancements
1. **Do Not Disturb Integration** (iOS 15+, Android 6+)
   - Request DND mode during focus sessions (user must approve)
   - Still doesn't block apps, but silences notifications
   
2. **Distraction Analytics**
   - Show patterns (time of day with most distractions)
   - Identify "peak focus" hours
   - Session completion correlation with distraction count

3. **Customizable Warnings**
   - Let users disable warnings if they find them annoying
   - Adjust sensitivity (ignore brief backgrounding < 3 seconds)

4. **Screen Time Integration** (iOS 12+, Android 9+)
   - Read system-level screen time stats
   - Cross-reference with Focusync sessions
   - Requires user permission + complex API usage

## Code Structure

### Files Modified
1. **`focus_session.dart`**: Added `distractionCount` and `lastDistractionTime` fields
2. **`session_controller.dart`**: Added `_recordDistraction()` method, updated lifecycle observer
3. **`active_focus_screen.dart`**: Added warning state management, distraction counter display

### Files Created
1. **`distraction_warning_overlay.dart`**: Reusable warning component with animations

### Testing Recommendations
1. **Manual Testing**:
   - Start a focus session
   - Press home button (iOS) or back button (Android)
   - Return to app → verify warning appears
   - Repeat 6+ times → verify message escalates

2. **Edge Cases**:
   - Background app during paused session → no distraction recorded ✅
   - Complete session with 0 distractions → no counter shown ✅
   - Restart app during session → distraction count preserved (requires persistence) ⚠️

3. **Performance**:
   - Warning overlay should animate smoothly (60 FPS)
   - No jank when returning from background
   - State updates should not trigger unnecessary rebuilds

## Conclusion

**What we CAN do**:
- ✅ Detect app backgrounding with high accuracy
- ✅ Track distraction frequency and timing
- ✅ Provide real-time feedback with contextual warnings
- ✅ Create psychological accountability through visibility

**What we CANNOT do**:
- ❌ Prevent users from leaving the app
- ❌ Block specific apps or system functions
- ❌ Force users to stay focused
- ❌ Guarantee 100% distraction detection in all scenarios

**Bottom line**: Distraction detection is a **motivational tool**, not enforcement. It leverages psychology (awareness, accountability) rather than technology (blocking, restrictions) to promote sustained focus. This aligns with ethical design principles and platform constraints.
