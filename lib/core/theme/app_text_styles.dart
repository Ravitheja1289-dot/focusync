import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Focusync typography system
///
/// Uses Inter for body/UI and SF Pro Rounded for display text.
/// iOS baseline sizing with precise line heights and letter spacing.
class AppTextStyles {
  AppTextStyles._();

  // ============================================================================
  // FONT FAMILIES
  // ============================================================================

  /// Display and heading font (soft, premium feel)
  static const String displayFont = 'SF Pro Rounded';

  /// Body and UI font (neutral, professional)
  static const String bodyFont = 'Inter';

  /// Monospace font for technical elements
  static const String monoFont = 'JetBrains Mono';

  // ============================================================================
  // DISPLAY STYLES (Timer, Hero Elements)
  // ============================================================================

  /// 48px - Session timer, large displays
  static const displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 48,
    height: 1.17, // 56px line height
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.gray50,
  );

  /// 36px - Section headers, large titles
  static const displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 36,
    height: 1.22, // 44px line height
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.gray50,
  );

  /// 28px - Small displays, emphasized text
  static const displaySmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    height: 1.29, // 36px line height
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.gray50,
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
  // UTILITY EXTENSIONS
  // ============================================================================

  /// Helper to convert any TextStyle to uppercase with appropriate spacing
  static TextStyle uppercase(TextStyle base) {
    return base.copyWith(letterSpacing: (base.letterSpacing ?? 0) + 0.8);
  }
}
