import 'package:flutter/material.dart';

@immutable
class OmaTheme extends ThemeExtension<OmaTheme> {
  const OmaTheme({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceMuted,
    required this.foreground,
    required this.muted,
    required this.border,
    required this.primary,
    required this.primarySoft,
    required this.primaryStrong,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceMuted;
  final Color foreground;
  final Color muted;
  final Color border;
  final Color primary;
  final Color primarySoft;
  final Color primaryStrong;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  @override
  OmaTheme copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? surfaceMuted,
    Color? foreground,
    Color? muted,
    Color? border,
    Color? primary,
    Color? primarySoft,
    Color? primaryStrong,
    Color? onPrimary,
    Color? accent,
    Color? accentSoft,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return OmaTheme(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      foreground: foreground ?? this.foreground,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryStrong: primaryStrong ?? this.primaryStrong,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  OmaTheme lerp(covariant OmaTheme? other, double t) {
    if (other == null) return this;
    return OmaTheme(
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primaryStrong: Color.lerp(primaryStrong, other.primaryStrong, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension OmaThemeContext on BuildContext {
  OmaTheme get omaTheme {
    final theme = Theme.of(this);
    final extension = theme.extension<OmaTheme>();
    if (extension != null) return extension;

    final colors = theme.colorScheme;
    return OmaTheme(
      background: theme.scaffoldBackgroundColor,
      backgroundAlt: colors.surfaceContainerLowest,
      surface: colors.surface,
      surfaceMuted: colors.surfaceContainerHigh,
      foreground: colors.onSurface,
      muted: colors.onSurfaceVariant,
      border: colors.outline,
      primary: colors.primary,
      primarySoft: colors.primaryContainer,
      primaryStrong: colors.onPrimaryContainer,
      onPrimary: colors.onPrimary,
      accent: colors.secondary,
      accentSoft: colors.secondaryContainer,
      error: colors.error,
      success: colors.tertiary,
      warning: colors.tertiary,
      info: colors.secondary,
    );
  }
}
