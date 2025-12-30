import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_shadows.dart';

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
      primary: AppColors.indigo500,
      primaryContainer: AppColors.indigo900,
      secondary: AppColors.indigo400,
      secondaryContainer: AppColors.slate800,
      surface: AppColors.slate900,
      error: AppColors.error,
      onPrimary: AppColors.gray50,
      onSecondary: AppColors.gray50,
      onSurface: AppColors.gray50,
      onError: AppColors.gray50,
      outline: AppColors.slate700,
      outlineVariant: AppColors.gray600,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.slate950,

    // App bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.slate950,
      foregroundColor: AppColors.gray50,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.titleLarge,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.slate900,
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
      displaySmall: AppTextStyles.displaySmall,
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
        backgroundColor: AppColors.indigo500,
        foregroundColor: AppColors.gray50,
        elevation: 0,
        padding: AppSpacing.buttonPadding,
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.indigo400,
        padding: AppSpacing.buttonPaddingSmall,
        minimumSize: const Size(0, AppSpacing.buttonHeightSmall),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // Outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.gray50,
        side: const BorderSide(color: AppColors.slate700, width: 1),
        padding: AppSpacing.buttonPadding,
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.buttonRadius),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // Floating action button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.indigo500,
      foregroundColor: AppColors.gray50,
      elevation: 0,
      shape: CircleBorder(),
    ),

    // Icon button
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.gray50,
        minimumSize: const Size(
          AppSpacing.iconButtonSize,
          AppSpacing.iconButtonSize,
        ),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.slate800,
      border: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(color: AppColors.slate700, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(color: AppColors.slate700, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(color: AppColors.indigo500, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.buttonRadius,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: AppSpacing.buttonPadding,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray400),
      labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.gray200),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.slate800,
      selectedColor: AppColors.indigo900,
      disabledColor: AppColors.slate700,
      labelStyle: AppTextStyles.labelMedium,
      padding: AppSpacing.chipPadding,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.chipRadius),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.slate900,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.largeRadius),
      titleTextStyle: AppTextStyles.titleLarge,
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
        if (states.contains(WidgetState.selected)) {
          return AppColors.gray50;
        }
        return AppColors.gray400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.indigo500;
        }
        return AppColors.slate700;
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
          secondaryContainer: AppColors.stone200,
          surface: AppColors.white,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.stone900,
          onError: AppColors.white,
          outline: AppColors.stone200,
          outlineVariant: AppColors.gray400,
        ),

        scaffoldBackgroundColor: AppColors.stone50,

        // Most component themes inherit from dark theme
        // Only color-specific overrides needed
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.stone50,
          foregroundColor: AppColors.stone900,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 22,
            height: 1.27,
            fontWeight: FontWeight.w600,
            color: AppColors.stone900,
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
            fontFamily: AppTextStyles.displayFont,
            fontSize: 48,
            height: 1.17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.stone900,
          ),
          displayMedium: TextStyle(
            fontFamily: AppTextStyles.displayFont,
            fontSize: 36,
            height: 1.22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.stone900,
          ),
          displaySmall: TextStyle(
            fontFamily: AppTextStyles.displayFont,
            fontSize: 28,
            height: 1.29,
            fontWeight: FontWeight.w600,
            color: AppColors.stone900,
          ),
          titleLarge: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 22,
            height: 1.27,
            fontWeight: FontWeight.w600,
            color: AppColors.stone900,
          ),
          titleMedium: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 18,
            height: 1.33,
            fontWeight: FontWeight.w600,
            color: AppColors.stone900,
          ),
          titleSmall: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 16,
            height: 1.38,
            fontWeight: FontWeight.w600,
            color: AppColors.stone900,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 17,
            height: 1.41,
            fontWeight: FontWeight.w400,
            color: AppColors.stone900,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 15,
            height: 1.33,
            fontWeight: FontWeight.w400,
            color: AppColors.stone900,
          ),
          bodySmall: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 13,
            height: 1.38,
            fontWeight: FontWeight.w400,
            color: AppColors.gray600,
          ),
          labelLarge: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 14,
            height: 1.43,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.stone900,
          ),
          labelMedium: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 12,
            height: 1.33,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.stone900,
          ),
          labelSmall: TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 11,
            height: 1.27,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: AppColors.gray600,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.buttonRadius,
            borderSide: const BorderSide(color: AppColors.stone200, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.buttonRadius,
            borderSide: const BorderSide(color: AppColors.stone200, width: 1),
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
          backgroundColor: AppColors.stone200,
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
          color: AppColors.stone200,
          thickness: 1,
          space: AppSpacing.md,
        ),
      );
}
