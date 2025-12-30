import 'package:flutter/material.dart';

/// Focusync elevation and shadow definitions
///
/// Provides shadow layers for different elevation levels in both dark and light modes.
class AppShadows {
  AppShadows._();

  // ============================================================================
  // DARK MODE SHADOWS (stronger, higher opacity)
  // ============================================================================

  /// Level 0 - No shadow (flush with background)
  static const List<BoxShadow> level0 = [];

  /// Level 1 - Raised elements
  static const List<BoxShadow> level1Dark = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color(0x4D000000), // 30% opacity
    ),
  ];

  /// Level 2 - Cards, standard elevation
  static const List<BoxShadow> level2Dark = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 8,
      color: Color(0x66000000), // 40% opacity
    ),
  ];

  /// Level 3 - Floating elements (FAB)
  static const List<BoxShadow> level3Dark = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 16,
      color: Color(0x80000000), // 50% opacity
    ),
  ];

  /// Level 4 - Modals, bottom sheets
  static const List<BoxShadow> level4Dark = [
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 32,
      color: Color(0x99000000), // 60% opacity
    ),
  ];

  /// Level 5 - Overlays, highest elevation
  static const List<BoxShadow> level5Dark = [
    BoxShadow(
      offset: Offset(0, 16),
      blurRadius: 48,
      color: Color(0xB3000000), // 70% opacity
    ),
  ];

  // ============================================================================
  // LIGHT MODE SHADOWS (softer, lower opacity)
  // ============================================================================

  /// Level 1 - Raised elements (light)
  static const List<BoxShadow> level1Light = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color(0x14000000), // 8% opacity
    ),
  ];

  /// Level 2 - Cards (light)
  static const List<BoxShadow> level2Light = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 8,
      color: Color(0x14000000), // 8% opacity
    ),
  ];

  /// Level 3 - Floating elements (light)
  static const List<BoxShadow> level3Light = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 16,
      color: Color(0x1F000000), // 12% opacity
    ),
  ];

  /// Level 4 - Modals (light)
  static const List<BoxShadow> level4Light = [
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 32,
      color: Color(0x29000000), // 16% opacity
    ),
  ];

  /// Level 5 - Overlays (light)
  static const List<BoxShadow> level5Light = [
    BoxShadow(
      offset: Offset(0, 16),
      blurRadius: 48,
      color: Color(0x33000000), // 20% opacity
    ),
  ];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get appropriate shadow for elevation level based on brightness
  static List<BoxShadow> getLevel(int level, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    switch (level) {
      case 0:
        return level0;
      case 1:
        return isDark ? level1Dark : level1Light;
      case 2:
        return isDark ? level2Dark : level2Light;
      case 3:
        return isDark ? level3Dark : level3Light;
      case 4:
        return isDark ? level4Dark : level4Light;
      case 5:
        return isDark ? level5Dark : level5Light;
      default:
        return isDark ? level2Dark : level2Light;
    }
  }
}

/// Extension for easy shadow access
extension ShadowExtension on BuildContext {
  /// Get shadow for specific level
  List<BoxShadow> shadow(int level) {
    final brightness = Theme.of(this).brightness;
    return AppShadows.getLevel(level, brightness);
  }

  /// Quick access to common shadow levels
  List<BoxShadow> get shadowCard => shadow(2);
  List<BoxShadow> get shadowFloating => shadow(3);
  List<BoxShadow> get shadowModal => shadow(4);
}
