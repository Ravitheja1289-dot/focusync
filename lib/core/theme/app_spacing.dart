import 'package:flutter/material.dart';

/// Focusync spacing and sizing constants
///
/// Uses 4px base unit for consistent spacing throughout the app.
class AppSpacing {
  AppSpacing._();

  // ============================================================================
  // SPACING SCALE (4px base unit)
  // ============================================================================

  /// 4px - Icon padding, tight spacing
  static const double xs = 4.0;

  /// 8px - Chip padding, list item gaps
  static const double sm = 8.0;

  /// 16px - Card padding, default gap (most common)
  static const double md = 16.0;

  /// 24px - Section spacing
  static const double lg = 24.0;

  /// 32px - Screen padding top/bottom
  static const double xl = 32.0;

  /// 48px - Major section breaks
  static const double xxl = 48.0;

  /// 64px - Screen-to-screen transitions
  static const double xxxl = 64.0;

  // ============================================================================
  // EDGE INSETS PRESETS
  // ============================================================================

  /// Horizontal padding for screens (16px sides)
  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(horizontal: md);

  /// Vertical padding for screens (32px top/bottom)
  static const EdgeInsets screenPaddingV = EdgeInsets.symmetric(vertical: xl);

  /// All-around screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xl,
  );

  /// Card padding (20px all sides for mobile)
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);

  /// Card padding for tablets (24px)
  static const EdgeInsets cardPaddingTablet = EdgeInsets.all(lg);

  /// Button padding (horizontal: 24px, vertical: 16px)
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Small button padding
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Chip/Tag padding
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: sm,
  );

  /// List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: 12.0,
  );

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  /// 16px - Cards, major containers
  static const double radiusCard = 16.0;

  /// 12px - Buttons, medium elements
  static const double radiusButton = 12.0;

  /// 8px - Chips, tags, small elements
  static const double radiusChip = 8.0;

  /// 24px - Large rounded elements
  static const double radiusLarge = 24.0;

  /// Full circle
  static const double radiusCircle = 9999.0;

  // ============================================================================
  // BORDER RADIUS PRESETS
  // ============================================================================

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(radiusCard),
  );

  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(radiusButton),
  );

  static const BorderRadius chipRadius = BorderRadius.all(
    Radius.circular(radiusChip),
  );

  static const BorderRadius largeRadius = BorderRadius.all(
    Radius.circular(radiusLarge),
  );

  // ============================================================================
  // TOUCH TARGETS
  // ============================================================================

  /// Minimum touch target (iOS: 44px, Android: 48px)
  static const double minTouchTarget = 48.0;

  /// Primary button height (generous, premium feel)
  static const double buttonHeight = 56.0;

  /// Secondary button height
  static const double buttonHeightSmall = 44.0;

  /// Icon button size
  static const double iconButtonSize = 48.0;

  /// Chip/tag height
  static const double chipHeight = 32.0;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  /// Small icons (list items, chips)
  static const double iconSizeSmall = 16.0;

  /// Medium icons (buttons, most UI)
  static const double iconSizeMedium = 24.0;

  /// Large icons (hero elements)
  static const double iconSizeLarge = 32.0;

  /// Extra large icons (onboarding, empty states)
  static const double iconSizeXLarge = 48.0;

  // ============================================================================
  // LAYOUT CONSTRAINTS
  // ============================================================================

  /// Maximum content width for desktop/tablets
  static const double maxContentWidth = 1200.0;

  /// Minimum side margin for mobile
  static const double minSideMargin = 16.0;

  /// Preferred side margin for tablets
  static const double preferredSideMargin = 24.0;

  /// Desktop side margin
  static const double desktopSideMargin = 32.0;

  // ============================================================================
  // GAP HELPERS (for Row/Column spacing)
  // ============================================================================

  /// 4px vertical gap
  static const SizedBox gapXs = SizedBox(height: xs);

  /// 8px vertical gap
  static const SizedBox gapSm = SizedBox(height: sm);

  /// 16px vertical gap
  static const SizedBox gapMd = SizedBox(height: md);

  /// 24px vertical gap
  static const SizedBox gapLg = SizedBox(height: lg);

  /// 32px vertical gap
  static const SizedBox gapXl = SizedBox(height: xl);

  /// 48px vertical gap
  static const SizedBox gapXxl = SizedBox(height: xxl);

  // ============================================================================
  // HORIZONTAL GAP HELPERS
  // ============================================================================

  /// 4px horizontal gap
  static const SizedBox gapXsH = SizedBox(width: xs);

  /// 8px horizontal gap
  static const SizedBox gapSmH = SizedBox(width: sm);

  /// 16px horizontal gap
  static const SizedBox gapMdH = SizedBox(width: md);

  /// 24px horizontal gap
  static const SizedBox gapLgH = SizedBox(width: lg);

  /// 32px horizontal gap
  static const SizedBox gapXlH = SizedBox(width: xl);
}

/// Extension methods for responsive spacing
extension SpacingExtension on BuildContext {
  /// Get screen-appropriate side margins
  double get sideMargin {
    final width = MediaQuery.of(this).size.width;
    if (width > 900) return AppSpacing.desktopSideMargin;
    if (width > 600) return AppSpacing.preferredSideMargin;
    return AppSpacing.minSideMargin;
  }

  /// Get screen-appropriate card padding
  EdgeInsets get cardPadding {
    final width = MediaQuery.of(this).size.width;
    return width > 600 ? AppSpacing.cardPaddingTablet : AppSpacing.cardPadding;
  }

  /// Check if screen is tablet or larger
  bool get isTablet => MediaQuery.of(this).size.width > 600;

  /// Check if screen is desktop
  bool get isDesktop => MediaQuery.of(this).size.width > 900;
}
