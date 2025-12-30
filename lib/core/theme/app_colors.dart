import 'package:flutter/material.dart';

/// Focusync color palette - Dark-first, calming design
class AppColors {
  AppColors._();

  // ============================================================================
  // DEEP SLATE (Background)
  // ============================================================================

  /// Main background color
  static const slate950 = Color(0xFF0A0E14);

  /// Cards and elevated surfaces
  static const slate900 = Color(0xFF151921);

  /// Hover states
  static const slate800 = Color(0xFF1E242E);

  /// Borders and dividers
  static const slate700 = Color(0xFF2A3241);

  // ============================================================================
  // CALM INDIGO (Brand/Focus)
  // ============================================================================

  /// Primary actions and active states
  static const indigo500 = Color(0xFF6366F1);

  /// Hover state for primary actions
  static const indigo400 = Color(0xFF818CF8);

  /// Pressed state for primary actions
  static const indigo600 = Color(0xFF4F46E5);

  /// Subtle backgrounds for focus elements
  static const indigo900 = Color(0xFF312E81);

  // ============================================================================
  // SOFT NEUTRALS (Text & UI)
  // ============================================================================

  /// Primary text on dark backgrounds
  static const gray50 = Color(0xFFF9FAFB);

  /// Secondary text
  static const gray200 = Color(0xFFE5E7EB);

  /// Tertiary text and disabled states
  static const gray400 = Color(0xFF9CA3AF);

  /// Subtle borders
  static const gray600 = Color(0xFF4B5563);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Session completed, success states
  static const success = Color(0xFF10B981);

  /// Errors, blocker failures
  static const error = Color(0x00ef4444);

  /// Break reminders, warnings
  static const warning = Color(0xFFF59E0B);

  /// Tips, guidance, informational
  static const info = Color(0xFF3B82F6);

  // ============================================================================
  // LIGHT MODE (Secondary Priority)
  // ============================================================================

  /// Light mode background
  static const stone50 = Color(0xFFFAFAF9);

  /// Light mode surface
  static const white = Color(0xFFFFFFFF);

  /// Light mode borders
  static const stone200 = Color(0xFFE7E5E4);

  /// Light mode text
  static const stone900 = Color(0xFF1C1917);

  // ============================================================================
  // SEMANTIC OVERLAYS (70% opacity for reduced intensity)
  // ============================================================================

  /// Success with reduced intensity
  static const successOverlay = Color(0xB310B981);

  /// Error with reduced intensity
  static const errorOverlay = Color(0xB3EF4444);

  /// Warning with reduced intensity
  static const warningOverlay = Color(0xB3F59E0B);

  /// Info with reduced intensity
  static const infoOverlay = Color(0xB33B82F6);

  // ============================================================================
  // GLASSMORPHISM
  // ============================================================================

  /// Glassmorphism overlay background (80% opacity)
  static const glassBackground = Color(0xCC151921);
}
