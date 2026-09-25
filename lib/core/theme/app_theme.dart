import 'package:flutter/material.dart';

import 'oma_theme.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => fromOmaTheme(
    OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.light,
      selectedDate: DateTime(2000),
    ),
  );

  static ThemeData get darkTheme => fromOmaTheme(
    OmaThemeResolver.resolve(
      mode: OmaMode.cycle,
      brightness: Brightness.dark,
      selectedDate: DateTime(2000),
    ),
  );

  static ThemeData fromOmaTheme(OmaTheme oma) {
    final brightness = oma.background.computeLuminance() < 0.5
        ? Brightness.dark
        : Brightness.light;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: oma.primary,
      onPrimary: oma.onPrimary,
      primaryContainer: oma.primarySoft,
      onPrimaryContainer: oma.primaryStrong,
      secondary: oma.accent,
      onSecondary: oma.onPrimary,
      secondaryContainer: oma.accentSoft,
      onSecondaryContainer: oma.foreground,
      error: oma.error,
      onError: oma.onPrimary,
      surface: oma.surface,
      onSurface: oma.foreground,
      outline: oma.border,
      outlineVariant: oma.divider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      primaryColor: oma.primary,
      scaffoldBackgroundColor: oma.background,
      fontFamily: 'Karla',
      splashFactory: InkSparkle.splashFactory,
      extensions: [oma],
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: oma.foreground,
          fontFamily: 'CormorantGaramond',
          fontSize: 30,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
        headlineMedium: TextStyle(
          color: oma.foreground,
          fontFamily: 'CormorantGaramond',
          fontSize: OmaTypeScale.heading,
          height: 1.2,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.35,
        ),
        titleLarge: TextStyle(
          color: oma.foreground,
          fontFamily: 'CormorantGaramond',
          fontSize: OmaTypeScale.title,
          height: 1.25,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: oma.foreground,
          fontSize: OmaTypeScale.bodyLarge,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: oma.foreground,
          fontSize: OmaTypeScale.bodyLarge,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: oma.foreground,
          fontSize: OmaTypeScale.body,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: oma.muted,
          fontSize: OmaTypeScale.caption,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          color: oma.primaryStrong,
          fontSize: OmaTypeScale.body,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: oma.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: oma.foreground,
          fontFamily: 'CormorantGaramond',
          fontSize: OmaTypeScale.title,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: oma.primaryStrong),
      ),
      cardTheme: CardThemeData(
        color: oma.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OmaRadius.xl),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oma.primary,
          foregroundColor: oma.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: OmaSpacing.xxl,
            vertical: OmaSpacing.lg,
          ),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: oma.primaryStrong,
          side: BorderSide(color: oma.primary, width: 1.2),
          padding: const EdgeInsets.symmetric(
            horizontal: OmaSpacing.xxl,
            vertical: OmaSpacing.lg,
          ),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: oma.primaryStrong,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: oma.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: OmaSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OmaRadius.lg),
          borderSide: BorderSide(color: oma.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OmaRadius.lg),
          borderSide: BorderSide(color: oma.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OmaRadius.lg),
          borderSide: BorderSide(color: oma.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OmaRadius.lg),
          borderSide: BorderSide(color: oma.error, width: 1.4),
        ),
        hintStyle: TextStyle(color: oma.muted, fontSize: OmaTypeScale.body),
        labelStyle: TextStyle(color: oma.muted, fontSize: OmaTypeScale.body),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: oma.primary,
        selectionColor: oma.primary.withValues(alpha: 0.24),
        selectionHandleColor: oma.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: oma.background,
        selectedItemColor: oma.primary,
        unselectedItemColor: oma.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: oma.background,
        elevation: 0,
        indicatorColor: oma.primarySoft,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? oma.primary
                : oma.muted,
          ),
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: oma.error,
        textColor: oma.onPrimary,
        smallSize: OmaSpacing.sm,
        largeSize: OmaSpacing.xl,
        textStyle: OmaText.label(color: oma.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: OmaSpacing.xs),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: oma.surface,
        disabledColor: oma.surface,
        selectedColor: oma.primarySoft,
        secondarySelectedColor: oma.primarySoft,
        labelStyle: OmaText.label(color: oma.foreground),
        secondaryLabelStyle: OmaText.label(color: oma.primaryStrong),
        checkmarkColor: oma.primary,
        deleteIconColor: oma.muted,
        iconTheme: IconThemeData(color: oma.primaryStrong),
        shape: const StadiumBorder(),
        side: BorderSide(color: oma.border),
        padding: const EdgeInsets.symmetric(
          horizontal: OmaSpacing.sm,
          vertical: OmaSpacing.xs,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: oma.primary,
        inactiveTrackColor: oma.primary.withValues(alpha: 0.18),
        thumbColor: oma.primary,
        overlayColor: oma.primary.withValues(alpha: 0.1),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? oma.primary
              : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      dividerTheme: DividerThemeData(
        color: oma.divider,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: oma.surface,
        modalBackgroundColor: oma.surface,
        surfaceTintColor: Colors.transparent,
        elevation: OmaSpacing.sm,
        modalElevation: OmaSpacing.sm,
        shadowColor: oma.shadow,
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        dragHandleColor: oma.border,
        dragHandleSize: const Size(OmaSpacing.huge, OmaSpacing.xs),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: oma.border),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(OmaRadius.xl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: oma.surface,
        surfaceTintColor: Colors.transparent,
        elevation: OmaSpacing.sm,
        shadowColor: oma.shadow,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: oma.border),
          borderRadius: BorderRadius.circular(OmaRadius.xl),
        ),
      ),
    );
  }
}
