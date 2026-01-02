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
  // LEVEL 2: HEADLINE (Page Titles, Section Headers)
  // ============================================================================
  // Purpose: Structural navigation - tells user where they are
  // Why it exists: Provides spatial orientation and content organization
  // Usage: Screen titles, major section headers
  // Characteristics: Semi-bold weight for clarity, normal tracking for readability

  /// 32px - Page title (primary headline)
  /// Used for: Screen headers (Analytics, Settings), modal titles
  static const headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    height: 1.25, // 40px line height (comfortable breathing room)
    fontWeight: FontWeight.w600, // Semi-bold - establishes hierarchy
    letterSpacing: -0.5, // Slight tightening for elegance
    color: AppColors.textPrimary,
  );

  /// 24px - Section header (secondary headline)
  /// Used for: Major sections (Today, This Week, Insights)
  static const headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    height: 1.33, // 32px line height
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// 18px - Subsection header (tertiary headline)
  /// Used for: Card titles, grouped content headers
  static const headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    height: 1.44, // 26px line height
    fontWeight: FontWeight.w500, // Medium - softer than primary headlines
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // ============================================================================
  // LEVEL 3: BODY (Primary Reading Content)
  // ============================================================================
  // Purpose: Main communication layer - explanations, descriptions, instructions
  // Why it exists: Delivers information with optimal readability
  // Usage: Paragraphs, list items, card content, dialog text
  // Characteristics: Regular weight, generous line height (1.5-1.6) for calm reading

  /// 16px - Primary body text
  /// Used for: Main content, paragraphs, descriptions, button text
  /// Line height: 1.5 (24px) - optimal for reading comfort and calm scanning
  static const bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    height: 1.5, // 24px - generous for calm reading
    fontWeight: FontWeight.w400, // Regular - neutral weight
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// 14px - Secondary body text
  /// Used for: Supporting descriptions, list item details, secondary content
  static const bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    height: 1.57, // 22px - proportionally more leading for smaller size
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// 12px - Tertiary body text
  /// Used for: Captions, fine print, supplementary information
  static const bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    height: 1.5, // 18px
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.2, // Slight opening for legibility at small size
    color: AppColors.textPrimary,
  );

  // ============================================================================
  // LEVEL 4: MICROTEXT (Metadata, Labels, UI Elements)
  // ============================================================================
  // Purpose: Supporting information - timestamps, labels, UI guidance
  // Why it exists: Provides context without competing with primary content
  // Usage: Timestamps, field labels, status text, button labels, badges
  // Characteristics: Slightly heavier weight (medium) for clarity, wider tracking

  /// 14px - Button labels, form labels
  /// Used for: Interactive element text (buttons, tabs), input field labels
  static const microLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    height: 1.43, // 20px
    fontWeight: FontWeight.w500, // Medium - slightly heavier for UI clarity
    letterSpacing: 0.3, // Slight opening for scannability
    color: AppColors.textPrimary,
  );

  /// 12px - Metadata, timestamps
  /// Used for: Timestamps ("2 hours ago"), stat labels ("Focus Quality")
  static const microMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    height: 1.33, // 16px
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0.4,
    color: AppColors.textPrimary,
  );

  /// 10px - Tiny labels, badges
  /// Used for: Ultra-compact UI elements, badges, notification counts
  static const microSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    height: 1.4, // 14px
    fontWeight: FontWeight.w500, // Medium - maintains legibility
    letterSpacing: 0.5, // More tracking needed at tiny sizes
    color: AppColors.textPrimary,
  );

  // ============================================================================
  // SPECIAL PURPOSE: MONOSPACE (Timer Inputs Only)
  // ============================================================================
  // Purpose: Fixed-width numbers for time entry and technical precision
  // Why it exists: Prevents layout jump when digits change (25:00 → 24:59)
  // Usage: ONLY for timer input fields - NOT for display timer
  // Note: Could be eliminated by using tabular figures in Inter

  /// 16px - Time input fields (HH:MM format)
  /// Used for: Manual time entry in session setup
  static const monoInput = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    fontFeatures: [FontFeature.tabularFigures()], // Use Inter's tabular nums
    color: AppColors.textPrimary,
  );

  // ============================================================================
  // DEPRECATED (Backwards Compatibility)
  // ============================================================================
  // These styles maintain compatibility with existing code
  // Prefer using new hierarchy: displayHero, headlineLarge, bodyLarge, microLarge

  @Deprecated('Use headlineLarge instead')
  static const titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  @Deprecated('Use headlineMedium instead')
  static const titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  @Deprecated('Use headlineSmall instead')
  static const titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    height: 1.38,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  @Deprecated('Use microLarge instead')
  static const labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  @Deprecated('Use microMedium instead')
  static const labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  @Deprecated('Use microSmall instead')
  static const labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    height: 1.27,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    color: AppColors.textTertiary,
  );
}
