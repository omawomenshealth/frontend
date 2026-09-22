import 'package:flutter/material.dart';

import '../widgets/oma_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const scheme = ColorScheme.light(
      primary: OmaColors.primary,
      onPrimary: OmaColors.textOnPrimary,
      primaryContainer: OmaColors.primaryLight,
      onPrimaryContainer: OmaColors.primaryDark,
      secondary: OmaColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: OmaColors.secondaryLight,
      onSecondaryContainer: OmaColors.secondaryDark,
      surface: OmaColors.surface,
      onSurface: OmaColors.textPrimary,
      error: OmaColors.error,
      outline: OmaColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      primaryColor: OmaColors.primary,
      scaffoldBackgroundColor: OmaColors.scaffoldBackground,
      fontFamily: 'Karla',
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: OmaColors.textPrimary,
          fontFamily: 'CormorantGaramond',
          fontSize: 30,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
        headlineMedium: TextStyle(
          color: OmaColors.textPrimary,
          fontFamily: 'CormorantGaramond',
          fontSize: 24,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.35,
        ),
        titleLarge: TextStyle(
          color: OmaColors.textPrimary,
          fontFamily: 'CormorantGaramond',
          fontSize: 20,
          height: 1.25,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: OmaColors.textPrimary,
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: OmaColors.textSecondary,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: OmaColors.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: OmaColors.textHint,
          fontSize: 12,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          color: OmaColors.primaryDark,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: OmaColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: OmaColors.textPrimary,
          fontFamily: 'CormorantGaramond',
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: OmaColors.primaryDark),
      ),
      cardTheme: CardThemeData(
        color: OmaColors.cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OmaColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OmaColors.primaryDark,
          side: const BorderSide(color: OmaColors.primary, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: OmaColors.primaryDark,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OmaColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: OmaColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: OmaColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: OmaColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: OmaColors.error, width: 1.4),
        ),
        hintStyle: const TextStyle(color: OmaColors.textHint, fontSize: 14),
        labelStyle: const TextStyle(
          color: OmaColors.textSecondary,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: OmaColors.background,
        selectedItemColor: OmaColors.primary,
        unselectedItemColor: OmaColors.primaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: OmaColors.background,
        elevation: 0,
        indicatorColor: OmaColors.primaryLight,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? OmaColors.primary
                : OmaColors.primaryDark,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: OmaColors.surface,
        selectedColor: OmaColors.primaryLight,
        labelStyle: const TextStyle(color: OmaColors.textPrimary, fontSize: 13),
        shape: const StadiumBorder(),
        side: const BorderSide(color: OmaColors.outline),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: OmaColors.primary,
        inactiveTrackColor: OmaColors.primary.withValues(alpha: 0.18),
        thumbColor: OmaColors.primary,
        overlayColor: OmaColors.primary.withValues(alpha: 0.1),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? OmaColors.primary
              : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      dividerTheme: const DividerThemeData(
        color: OmaColors.outline,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: OmaColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: OmaColors.surface,
        showDragHandle: true,
        dragHandleColor: OmaColors.outline,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: OmaColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
