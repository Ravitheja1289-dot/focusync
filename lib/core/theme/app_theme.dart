import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

/// Focusync app theme configuration
///
/// Provides complete ThemeData for dark and light modes with custom styling
/// for all Material components following Focusync design system.
class AppTheme {
  AppTheme._();

  // ============================================================================
  // DARK THEME (Primary)
  // ============================================================================

  static ThemeData get dark => ThemeData(
    // Base configuration
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.textPrimary, // white
      primaryContainer: AppColors.backgroundSecondary, // gray10
      secondary: AppColors.textSecondary, // gray50
      secondaryContainer: AppColors.backgroundTertiary, // gray20
      surface: AppColors.backgroundSecondary, // gray10
      error: AppColors.textPrimary, // white (no red)
      onPrimary: AppColors.textInverted, // black
      onSecondary: AppColors.textPrimary, // white
      onSurface: AppColors.textPrimary, // white
      onError: AppColors.textPrimary, // white
      outline: AppColors.borderDefault, // gray40
      outlineVariant: AppColors.borderSubtle, // gray30
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundPrimary, // black
    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundPrimary, // black
      foregroundColor: AppColors.textPrimary, // white
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.headlineMedium, // updated style
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.backgroundSecondary, // gray10
      elevation: 0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.cardRadius),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),

    // Text theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      // displaySmall removed - use displayLarge or displayMedium instead
      headlineLarge: AppTextStyles.titleLarge,
      headlineMedium: AppTextStyles.titleMedium,
      headlineSmall: AppTextStyles.titleSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surfaceActive, // white
        foregroundColor: AppColors.textInverted, // black
        elevation: 0,
        padding: AppSpacing.buttonPadding,
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        textStyle: AppTextStyles.microLarge,
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary, // white
        padding: AppSpacing.buttonPaddingSmall,
        minimumSize: const Size(0, AppSpacing.buttonHeightSmall),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        textStyle: AppTextStyles.microLarge,
      ),
    ),

    // Outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary, // white
        side: const BorderSide(
          color: AppColors.borderDefault,
          width: 1,
        ), // gray40
        padding: AppSpacing.buttonPadding,
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        textStyle: AppTextStyles.microLarge,
      ),
    ),

    // Floating action button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.surfaceActive, // white
      foregroundColor: AppColors.textInverted, // black
      elevation: 0,
      shape: CircleBorder(),
    ),

    // Icon button
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimary, // white
        minimumSize: const Size(
          AppSpacing.iconButtonSize,
          AppSpacing.iconButtonSize,
        ),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSecondary, // gray10
      border: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(color: AppColors.borderDefault, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(color: AppColors.borderDefault, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(
          color: AppColors.borderStrong,
          width: 2,
        ), // white
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(
          color: AppColors.borderStrong,
          width: 1,
        ), // white (no red)
      ),
      contentPadding: AppSpacing.buttonPadding,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      labelStyle: AppTextStyles.microMedium.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundSecondary, // gray10
      selectedColor: AppColors.backgroundTertiary, // gray20
      disabledColor: AppColors.backgroundSecondary, // gray10
      labelStyle: AppTextStyles.microMedium,
      padding: AppSpacing.chipPadding,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.chipRadius),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.backgroundSecondary, // gray10
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.largeRadius),
      titleTextStyle: AppTextStyles.headlineMedium,
      contentTextStyle: AppTextStyles.bodyMedium,
    ),

    // Bottom sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.slate900,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.slate700,
      thickness: 1,
      space: AppSpacing.md,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFF4A4A4A); // Disabled thumb
        }
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFFFFFFFF); // ON thumb
        }
        return const Color(0xFF6E6E6E); // OFF thumb
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFF1E1E1E); // Disabled track
        }
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF6C6FF7); // ON track (primary accent)
        }
        return const Color(0xFF2A2A2A); // OFF track
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.indigo500;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.gray50),
      side: const BorderSide(color: AppColors.slate700, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip / 2),
      ),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.indigo500;
        }
        return AppColors.slate700;
      }),
    ),

    // Slider
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.indigo500,
      inactiveTrackColor: AppColors.slate700,
      thumbColor: AppColors.gray50,
      overlayColor: Color(0x1F6366F1), // 12% indigo
    ),

    // Progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.indigo500,
      linearTrackColor: AppColors.slate700,
      circularTrackColor: AppColors.slate700,
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.slate800,
      contentTextStyle: AppTextStyles.bodyMedium,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      contentPadding: AppSpacing.listItemPadding,
      titleTextStyle: AppTextStyles.titleSmall,
      subtitleTextStyle: AppTextStyles.bodySmall,
      iconColor: AppColors.gray200,
    ),
  );

  // ============================================================================
  // LIGHT THEME (Secondary)
  // ============================================================================

  static ThemeData get light =>
      ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        colorScheme: const ColorScheme.light(
          primary: AppColors.indigo500,
          primaryContainer: AppColors.indigo900,
          secondary: AppColors.indigo600,
          secondaryContainer: AppColors.gray20,
          surface: AppColors.white,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.black,
          onError: AppColors.white,
          outline: AppColors.gray20,
          outlineVariant: AppColors.gray400,
        ),

        scaffoldBackgroundColor: AppColors.white,

        // Most component themes inherit from dark theme
        // Only color-specific overrides needed
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            height: 1.27,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.cardRadius),
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 48,
            height: 1.17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.black,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 36,
            height: 1.22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.black,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            height: 1.29,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            height: 1.27,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            height: 1.33,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            height: 1.38,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            height: 1.41,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            height: 1.33,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            height: 1.38,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.43,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.black,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            height: 1.33,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.black,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            height: 1.27,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: AppColors.black,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.buttonRadius,
            borderSide: const BorderSide(color: AppColors.gray20, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.buttonRadius,
            borderSide: const BorderSide(color: AppColors.gray20, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.buttonRadius,
            borderSide: const BorderSide(color: AppColors.indigo500, width: 2),
          ),
          contentPadding: AppSpacing.buttonPadding,
        ),
      ).copyWith(
        // Copy remaining component themes from dark
        elevatedButtonTheme: dark.elevatedButtonTheme,
        textButtonTheme: dark.textButtonTheme,
        outlinedButtonTheme: dark.outlinedButtonTheme,
        floatingActionButtonTheme: dark.floatingActionButtonTheme,
        iconButtonTheme: dark.iconButtonTheme,
        chipTheme: dark.chipTheme.copyWith(
          backgroundColor: AppColors.gray20,
          selectedColor: AppColors.indigo900,
        ),
        dialogTheme: dark.dialogTheme.copyWith(
          backgroundColor: AppColors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLarge),
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.gray20,
          thickness: 1,
          space: AppSpacing.md,
        ),
      );
}
