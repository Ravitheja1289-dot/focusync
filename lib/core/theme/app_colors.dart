import 'package:flutter/material.dart';

/// Focusync strict grayscale color system
///
/// Design constraints:
/// - Black, white, and neutral grays only
/// - No color hues (no indigo, amber, green, etc.)
/// - Functional naming (describe purpose, not emotion)
/// - Dark-first hierarchy
class AppColors {
  AppColors._();

  // ============================================================================
  // BASE COLORS
  // ============================================================================

  /// Pure black - Maximum contrast backgrounds
  static const black = Color(0xFF000000);

  /// Pure white - Maximum contrast text and active elements
  static const white = Color(0xFFFFFFFF);

  // ============================================================================
  // GRAYSCALE SPECTRUM (10 stops for precise hierarchy)
  // ============================================================================

  /// 10% white - Deep background, almost black
  static const gray10 = Color(0xFF1A1A1A);

  /// 20% white - Elevated surfaces (cards, modals)
  static const gray20 = Color(0xFF333333);

  /// 30% white - Hover states, subtle elevation
  static const gray30 = Color(0xFF4D4D4D);

  /// 40% white - Borders, dividers, inactive elements
  static const gray40 = Color(0xFF666666);

  /// 50% white - Secondary text, mid-contrast elements
  static const gray50 = Color(0xFF808080);

  /// 60% white - Tertiary text, disabled interactive elements
  static const gray60 = Color(0xFF999999);

  /// 70% white - Subtle highlights, muted text
  static const gray70 = Color(0xFFB3B3B3);

  /// 80% white - Light borders, very subtle dividers
  static const gray80 = Color(0xFFCCCCCC);

  /// 90% white - Near-white backgrounds (light mode)
  static const gray90 = Color(0xFFE6E6E6);

  /// 95% white - Subtle light mode surfaces
  static const gray95 = Color(0xFFF2F2F2);

  // ============================================================================
  // BACKGROUND HIERARCHY (Dark Mode Primary)
  // ============================================================================

  /// Primary screen background - Deepest layer
  static const backgroundPrimary = black;

  /// Secondary background - Cards, panels, modals
  static const backgroundSecondary = gray10;

  /// Tertiary background - Nested cards, popovers
  static const backgroundTertiary = gray20;

  /// Hover background - Interactive element hover state
  static const backgroundHover = gray20;

  /// Active background - Selected/active states (inverted contrast)
  static const backgroundActive = white;

  // ============================================================================
  // SURFACE COLORS (Interactive Elements)
  // ============================================================================

  /// Default button/card surface
  static const surfaceDefault = gray10;

  /// Elevated button/card surface
  static const surfaceElevated = gray20;

  /// Interactive surface hover state
  static const surfaceHover = gray30;

  /// Active/pressed surface state (inverted)
  static const surfaceActive = white;

  /// Disabled surface state
  static const surfaceDisabled = gray10;

  // ============================================================================
  // TEXT HIERARCHY (Contrast-Based)
  // ============================================================================

  /// Primary text - Maximum readability (body copy, headings)
  static const textPrimary = white;

  /// Secondary text - Reduced emphasis (labels, metadata)
  static const textSecondary = gray50;

  /// Tertiary text - Minimal emphasis (timestamps, captions)
  static const textTertiary = gray40;

  /// Disabled text - Non-interactive or unavailable
  static const textDisabled = gray60;

  /// Inverted text - Text on active/white backgrounds
  static const textInverted = black;

  // ============================================================================
  // BORDERS & DIVIDERS
  // ============================================================================

  /// Default border - Standard separation (1px recommended)
  static const borderDefault = gray40;

  /// Subtle border - Minimal separation (0.5px or very low opacity)
  static const borderSubtle = gray30;

  /// Strong border - Emphasized boundaries (focus rings, alerts)
  static const borderStrong = white;

  /// Divider - Horizontal/vertical content separators
  static const divider = gray30;

  /// Divider subtle - Nearly invisible separation
  static const dividerSubtle = gray20;

  // ============================================================================
  // INTERACTIVE STATES
  // ============================================================================

  /// Focus ring - Keyboard navigation indicator (2px outline)
  static const focusRing = white;

  /// Overlay background - Modals, bottom sheets (semi-transparent)
  static const overlayBackground = Color(0xCC000000); // 80% black

  /// Scrim - Full-screen dimming layer (semi-transparent)
  static const scrim = Color(0x99000000); // 60% black

  // ============================================================================
  // LIGHT MODE OVERRIDES (Secondary Priority)
  // ============================================================================

  /// Light mode primary background
  static const backgroundPrimaryLight = white;

  /// Light mode secondary background
  static const backgroundSecondaryLight = gray95;

  /// Light mode tertiary background
  static const backgroundTertiaryLight = gray90;

  /// Light mode primary text
  static const textPrimaryLight = black;

  /// Light mode secondary text
  static const textSecondaryLight = gray50;

  /// Light mode tertiary text
  static const textTertiaryLight = gray60;

  /// Light mode borders
  static const borderDefaultLight = gray80;

  /// Light mode dividers
  static const dividerLight = gray80;

  // ============================================================================
  // FUNCTIONAL ALIASES (Semantic Mapping)
  // ============================================================================

  /// Timer ring active state
  static const timerActive = white;

  /// Timer ring idle state
  static const timerIdle = gray30;

  /// Timer ring paused state
  static const timerPaused = gray50;

  /// Progress indicator fill
  static const progressFill = white;

  /// Progress indicator background
  static const progressBackground = gray30;

  /// Chart data visualization
  static const chartData = white;

  /// Chart background
  static const chartBackground = black;

  /// Chart grid lines
  static const chartGrid = gray20;

  // ============================================================================
  // ACCENT COLORS (Minimal, Calm)
  // ============================================================================

  /// Primary accent - Indigo (calm, focused)
  static const indigo500 = Color(0xFF6C6FF7);
  static const indigo400 = Color(0xFF8B8EF9);
  static const indigo300 = Color(0xFFAAABFB);
  static const indigo600 = Color(0xFF5558E3);
  static const indigo900 = Color(0xFF2A2D8F);

  /// Success/positive state - Green
  static const green500 = Color(0xFF10B981);
  static const green400 = Color(0xFF34D399);

  /// Error/destructive state - Red
  static const red500 = Color(0xFFEF4444);
  static const red400 = Color(0xFFF87171);

  /// Warning state - Amber/Orange
  static const warning = Color(0xFFFBBF24);

  /// Info/neutral state - Blue
  static const blue400 = Color(0xFF60A5FA);

  /// Error alias
  static const error = red500;

  /// Card/surface background
  static const cardBackground = gray10;

  // ============================================================================
  // DEPRECATED (Backwards Compatibility - DO NOT USE)
  // ============================================================================

  @Deprecated('Use backgroundPrimary instead')
  static const slate950 = black;

  @Deprecated('Use backgroundSecondary instead')
  static const slate900 = gray10;

  @Deprecated('Use backgroundHover instead')
  static const slate800 = gray20;

  @Deprecated('Use borderDefault instead')
  static const slate700 = gray40;

  // gray50 already defined above - this deprecated alias removed

  @Deprecated('Use textSecondary instead')
  static const gray200 = gray80; // Changed from gray50 to avoid duplicate

  @Deprecated('Use textTertiary instead')
  static const gray400 = gray40;

  @Deprecated('Use borderDefault instead')
  static const gray600 = gray40;
}
