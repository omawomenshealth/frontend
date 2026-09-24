import 'package:flutter/material.dart';

import 'tokens/oma_shadows.dart';

@immutable
class OmaTheme extends ThemeExtension<OmaTheme> {
  const OmaTheme({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.logoSurface,
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
    required this.callout,
    required this.calloutForeground,
    required this.shadow,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color logoSurface;
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
  final Color callout;
  final Color calloutForeground;
  final Color shadow;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  List<BoxShadow> get subtleShadow => OmaShadows.subtle(shadow);
  List<BoxShadow> get softShadow => OmaShadows.soft(shadow);
  List<BoxShadow> get elevatedShadow => OmaShadows.elevated(shadow);
  List<BoxShadow> get topSheetShadow => OmaShadows.topSheet(shadow);

  @override
  OmaTheme copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? logoSurface,
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
    Color? callout,
    Color? calloutForeground,
    Color? shadow,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return OmaTheme(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      logoSurface: logoSurface ?? this.logoSurface,
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
      callout: callout ?? this.callout,
      calloutForeground: calloutForeground ?? this.calloutForeground,
      shadow: shadow ?? this.shadow,
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
      logoSurface: Color.lerp(logoSurface, other.logoSurface, t)!,
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
      callout: Color.lerp(callout, other.callout, t)!,
      calloutForeground: Color.lerp(
        calloutForeground,
        other.calloutForeground,
        t,
      )!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
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
      logoSurface: colors.surface,
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
      callout: colors.secondaryContainer,
      calloutForeground: colors.onSecondaryContainer,
      shadow: colors.shadow,
      error: colors.error,
      success: colors.tertiary,
      warning: colors.tertiary,
      info: colors.secondary,
    );
  }
}
