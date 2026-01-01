import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Focusync minimal typography system
///
/// Single font family: Inter (neutral, calm, professional)
/// Weight variation creates hierarchy, not font changes
/// Line heights optimized for reading comfort and visual calm
/// No decorative fonts - every style serves a functional purpose
class AppTextStyles {
  AppTextStyles._();

  // ============================================================================
  // FONT FAMILY (Single Family for Visual Consistency)
  // ============================================================================

  /// Primary font for all text
  /// Why Inter: Neutral, open apertures, excellent readability at all sizes
  /// No display font needed - weight and size create sufficient hierarchy
  static const String primaryFont = 'Inter';

  // ============================================================================
  // LEVEL 1: DISPLAY (Timer, Hero Numbers)
  // ============================================================================
  // Purpose: Single focal point - the active timer or primary metric
  // Why it exists: User needs to read time at a glance from distance
  // Usage: Timer countdown (25:00), large statistics
  // Characteristics: Thin weight for elegance, tight tracking for compactness

  /// 96px - Primary timer display (ultra large)
  /// Used for: Active focus session countdown
  static const displayHero = TextStyle(
    fontFamily: primaryFont,
    fontSize: 96,
    height: 1.0, // 96px line height (tight, no leading needed)
    fontWeight: FontWeight.w200, // Thin - elegant and calm
    letterSpacing: -2.0, // Tight tracking for cohesion
    color: AppColors.textPrimary,
  );

  /// 64px - Secondary large display
  /// Used for: Session completion time, big stats
  static const displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 64,
    height: 1.0, // 64px line height
    fontWeight: FontWeight.w200, // Thin
    letterSpacing: -1.5,
    color: AppColors.textPrimary,
  );

  /// 48px - Tertiary display
  /// Used for: Analytics hero numbers (180 min, 95% quality)
  static const displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 48,
    height: 1.08, // 52px line height (slight breathing room)
    fontWeight: FontWeight.w300, // Light
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
  );

  // ============================================================================
  // TITLE STYLES (Screen Titles, Card Headers)
  // ============================================================================

  /// 22px - Screen titles
  static const titleLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 22,
    height: 1.27, // 28px line height
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.gray50,
  );

  /// 18px - Card titles, section headers
  static const titleMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 18,
    height: 1.33, // 24px line height
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.gray50,
  );

  /// 16px - List item titles, small headers
  static const titleSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    height: 1.38, // 22px line height
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.gray50,
  );

  // ============================================================================
  // BODY STYLES (Paragraphs, Descriptions)
  // ============================================================================

  /// 17px - Primary body text (iOS standard)
  static const bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 17,
    height: 1.41, // 24px line height
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.gray50,
  );

  /// 15px - Secondary body text, descriptions
  static const bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 15,
    height: 1.33, // 20px line height
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.gray200,
  );

  /// 13px - Small body text, captions
  static const bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 13,
    height: 1.38, // 18px line height
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.gray400,
  );

  // ============================================================================
  // LABEL STYLES (Buttons, Input Labels, Tags)
  // ============================================================================

  /// 14px - Primary buttons, large labels
  static const labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    height: 1.43, // 20px line height
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.gray50,
  );

  /// 12px - Secondary buttons, chips, input labels
  static const labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    height: 1.33, // 16px line height
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.gray200,
  );

  /// 11px - Small labels, uppercase tags
  static const labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    height: 1.27, // 14px line height
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    color: AppColors.gray400,
  );

  // ============================================================================
  // MONOSPACE STYLES (Time Inputs, Technical)
  // ============================================================================

  /// 17px - Time inputs, duration displays
  static const monoLarge = TextStyle(
    fontFamily: monoFont,
    fontSize: 17,
    height: 1.41,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.gray50,
  );

  /// 14px - Small technical text
  static const monoMedium = TextStyle(
    fontFamily: monoFont,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.gray200,
  );

  // ============================================================================
  // SEMANTIC VARIANTS (Quick color overrides)
  // ============================================================================

  /// Error text styling
  static TextStyle get error => bodyMedium.copyWith(color: AppColors.error);

  /// Success text styling
  static TextStyle get success => bodyMedium.copyWith(color: AppColors.success);

  /// Warning text styling
  static TextStyle get warning => bodyMedium.copyWith(color: AppColors.warning);

  /// Info text styling
  static TextStyle get info => bodyMedium.copyWith(color: AppColors.info);

  /// Primary brand text (indigo)
  static TextStyle get primary =>
      bodyMedium.copyWith(color: AppColors.indigo500);

  // ============================================================================
  // HEADLINE ALIASES (for backwards compatibility)
  // ============================================================================

  /// 48px - Alias for displayLarge
  static const headlineLarge = displayLarge;

  /// 36px - Alias for displayMedium
  static const headlineMedium = displayMedium;

  /// 28px - Alias for displaySmall
  static const headlineSmall = displaySmall;

  // ============================================================================
  // UTILITY EXTENSIONS
  // ============================================================================

  /// Helper to convert any TextStyle to uppercase with appropriate spacing
  static TextStyle uppercase(TextStyle base) {
    return base.copyWith(letterSpacing: (base.letterSpacing ?? 0) + 0.8);
  }
}
