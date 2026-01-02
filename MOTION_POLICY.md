# Focusync Motion Policy
**Frozen Minimal Design System**

## Core Principle
**Motion must communicate state changes, not create delight.**

Every animation must answer: "What state change am I communicating?"
If the answer is "none" or "just looks nice" → **FORBIDDEN**.

---

## ✅ ALLOWED MOTION

### 1. Timer Progress Ring (150ms, linear)
**Purpose:** Communicates countdown progress  
**Implementation:** `CircularFocusTimer` widget  
**Details:**
- 1-second tick updates with 150ms linear transition
- Prevents jarring jumps between seconds
- Pure state visualization

```dart
CircularFocusTimer(
  progress: session.progress, // 0.0 to 1.0
  animationDuration: Duration(milliseconds: 150),
  // Linear curve - no easing
)
```

### 2. Session State Color Transitions (100ms, linear)
**Purpose:** Communicates pause/resume state changes  
**Implementation:** Timer ring color changes  
**Details:**
- White → Gray60 when paused
- Gray60 → White when resumed
- Instant visual feedback without theatrics

**States:**
- Running: White ring (`#FFFFFF`)
- Paused: Gray60 ring (`#999999`)
- Idle: White outline, no fill

### 3. Screen Navigation (200ms, linear fade)
**Purpose:** Communicates screen context change  
**Implementation:** `AppPageTransitions.fade()`  
**Details:**
- Simple opacity fade
- No slide/scale/bounce
- 200ms is fast enough to not feel sluggish

```dart
AppPageTransitions.fade(
  child: SettingsScreen(),
  context: context,
  duration: AppMotion.normal, // 200ms
)
```

### 4. Element Appearance/Disappearance (100ms, linear fade)
**Purpose:** Communicates element visibility state  
**Use cases:**
- Distraction warning appears
- Quality preview shows/hides
- Settings dots fade in

**Implementation:**
```dart
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: AppMotion.subtle, // 100ms
  curve: AppMotion.linear,
  child: widget,
)
```

---

## ❌ FORBIDDEN MOTION

### 1. Easing Curves (Bouncy/Elastic)
**Why forbidden:** Creates theatrical delight, not state communication  
**Examples:**
- ❌ `Curves.easeOutBack` (bouncy overshoot)
- ❌ `Curves.elasticOut` (spring physics)
- ❌ `Curves.bounceOut` (rubber ball effect)
- ❌ Any curve with acceleration/deceleration

**Exception:** `AppMotion.calm` allowed ONLY for opacity fades where linear feels too robotic. Use sparingly.

### 2. Scale Animations
**Why forbidden:** Draws attention to motion itself, not state  
**Examples:**
- ❌ Button press scale (0.98)
- ❌ Modal popup scale (0.9 → 1.0)
- ❌ Celebration scale pulse
- ❌ Icon growth on hover

### 3. Slide Transitions
**Why forbidden:** Physical metaphor creates unnecessary drama  
**Examples:**
- ❌ Slide up from bottom
- ❌ Slide left/right for navigation
- ❌ Slide down to dismiss
- ❌ Drawer slide-in

**Use instead:** Fade transitions (instant context switch)

### 4. Staggered Animations
**Why forbidden:** Choreographed sequences are decorative  
**Examples:**
- ❌ List items appearing one-by-one
- ❌ Multiple elements cascading in
- ❌ Wave/ripple effects

### 5. Particle/Physics Effects
**Why forbidden:** Pure decoration with no state communication  
**Examples:**
- ❌ Confetti on completion
- ❌ Ripple expand from tap
- ❌ Floating particles
- ❌ Parallax scrolling

### 6. Breathing/Pulsing Animations
**Why forbidden:** Repeated motion without state change  
**Examples:**
- ❌ Pulsing glow on timer
- ❌ Breathing scale animation
- ❌ Heartbeat effect
- ❌ Shimmer loading states

**Exception:** Breathing guide can use static visual cues (e.g., progress bar) instead of repeating animation.

### 7. Long Duration Animations (> 200ms)
**Why forbidden:** Slows down interaction, feels sluggish  
**Examples:**
- ❌ 400ms+ screen transitions
- ❌ 600ms "luxurious" fades
- ❌ 800ms completion celebration
- ❌ 1000ms+ splash animations

**Maximum duration:** 200ms for screen navigation, 150ms for widget updates

### 8. Multiple Simultaneous Animations
**Why forbidden:** Competing motion creates visual chaos  
**Example:**
- ❌ Slide + Scale + Fade combined
- ❌ Color + Size + Position changing together

**Use instead:** Single animation per interaction (fade OR color, not both)

---

## Implementation Reference

### Duration Constants
```dart
AppMotion.instant  // 0ms - No animation
AppMotion.subtle   // 100ms - Opacity/color fades
AppMotion.fast     // 150ms - Timer updates
AppMotion.normal   // 200ms - Screen navigation
```

### Curve Constants
```dart
AppMotion.linear   // Default - no easing
AppMotion.calm     // Only for subtle fades (use sparingly)
```

### Accessibility
All animations automatically disabled when user enables "Reduce Motion":
```dart
context.shouldReduceMotion // Returns true if reduce motion enabled
AppMotion.getDuration(context, duration) // Returns Duration.zero if reduce motion
```

---

## Enforcement Checklist

Before adding ANY animation, verify:
1. ✓ Does it communicate a state change?
2. ✓ Duration ≤ 200ms?
3. ✓ Using linear curve (or calm for opacity only)?
4. ✓ Not combining multiple animation types?
5. ✓ Not repeating without state changes?
6. ✓ Respects reduce motion setting?

If any answer is NO → **Do not implement the animation.**

---

## Examples from Codebase

### ✅ Correct Implementation
```dart
// Timer progress update (state: time remaining)
CircularFocusTimer(
  progress: session.progress,
  state: TimerState.focus,
  animationDuration: Duration(milliseconds: 150), // Fast
  strokeWidth: 1,
)

// Screen navigation (state: current screen)
AppPageTransitions.fade(
  child: AnalyticsScreen(),
  context: context, // 200ms linear fade
)
```

### ❌ Incorrect Implementation (Removed)
```dart
// BEFORE: Theatrical completion animation
AnimationController(
  duration: Duration(milliseconds: 800), // TOO LONG
)
ScaleAnimation(from: 0.9, to: 1.0) // FORBIDDEN: Scale
SlideAnimation(curve: Curves.easeOutBack) // FORBIDDEN: Bouncy easing

// AFTER: Simple fade
AnimationController(
  duration: Duration(milliseconds: 100), // Subtle
)
FadeAnimation(curve: Curves.linear) // State only
```

---

## Modified Files

- ✅ `app_motion.dart` - Updated durations, removed theatrical curves
- ✅ `circular_focus_timer.dart` - Changed to linear curves
- ✅ `session_completion_screen.dart` - Removed scale/slide animations
- ✅ `app_page_transitions.dart` - Simplified to fade only
- ⚠️ `breathing_animation.dart` - Consider removing (violates no-repeat policy)
- ⚠️ `splash_screen.dart` - Excessive duration (1200ms), theatrical easing

---

**Last Updated:** Implementation of frozen minimal design system  
**Strictness Level:** Maximum - no exceptions without design review
