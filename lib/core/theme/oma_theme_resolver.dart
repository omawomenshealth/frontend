import 'package:flutter/material.dart';

import '../utils/period_calculator.dart';
import 'oma_mode.dart';
import 'oma_theme_extension.dart';
import 'schemes/cycle_schemes.dart';
import 'schemes/oma_color_scheme.dart';
import 'schemes/pregnancy_scheme.dart';
import 'tokens/oma_palette.dart';

abstract final class OmaThemeResolver {
  static OmaTheme resolve({
    required OmaMode mode,
    required Brightness brightness,
    required DateTime selectedDate,
    PeriodCalculator? periodCalculator,
  }) {
    final scheme = switch (mode) {
      OmaMode.pregnancy => OmaPregnancyScheme.colors,
      OmaMode.cycle => OmaCycleSchemes.forPhase(
        periodCalculator?.phaseAt(selectedDate) ?? CyclePhase.follicular,
      ),
    };

    return _compose(scheme: scheme, brightness: brightness);
  }

  static OmaTheme _compose({
    required OmaColorScheme scheme,
    required Brightness brightness,
  }) {
    if (brightness == Brightness.dark) {
      const background = Color(0xFF181613);
      const backgroundAlt = Color(0xFF211E1A);
      const surface = Color(0xFF27231F);
      const surfaceMuted = Color(0xFF302B26);
      const foreground = Color(0xFFF5EEE5);
      const muted = Color(0xFFB8ADA1);
      const baseBorder = Color(0xFF4B433B);

      return OmaTheme(
        background: background,
        backgroundAlt: backgroundAlt,
        surface: surface,
        surfaceMuted: surfaceMuted,
        foreground: foreground,
        muted: muted,
        border: Color.lerp(baseBorder, scheme.primary, 0.22)!,
        primary: Color.lerp(scheme.primary, Colors.white, 0.16)!,
        primarySoft: Color.lerp(surface, scheme.primary, 0.22)!,
        primaryStrong: Color.lerp(scheme.primaryStrong, Colors.white, 0.18)!,
        onPrimary: const Color(0xFF1B1714),
        accent: Color.lerp(scheme.accent, Colors.white, 0.22)!,
        accentSoft: Color.lerp(surfaceMuted, scheme.accent, 0.18)!,
        callout: const Color(0xFF34272D),
        calloutForeground: const Color(0xFFE2BCCA),
        shadow: Colors.black,
        error: const Color(0xFFE08A7E),
        success: const Color(0xFF91C29C),
        warning: const Color(0xFFE3C17A),
        info: const Color(0xFF8FC2DD),
      );
    }

    return OmaTheme(
      background: OmaPalette.background,
      backgroundAlt: OmaPalette.backgroundAlt,
      surface: OmaPalette.card,
      surfaceMuted: OmaPalette.surfaceMuted,
      foreground: OmaPalette.foreground,
      muted: OmaPalette.muted,
      border: scheme.border,
      primary: scheme.primary,
      primarySoft: scheme.primarySoft,
      primaryStrong: scheme.primaryStrong,
      onPrimary: OmaPalette.primaryForeground,
      accent: scheme.accent,
      accentSoft: scheme.accentSoft,
      callout: OmaPalette.callout,
      calloutForeground: OmaPalette.calloutForeground,
      shadow: const Color(0xFF503F2E),
      error: OmaPalette.error,
      success: OmaPalette.success,
      warning: OmaPalette.warning,
      info: OmaPalette.info,
    );
  }
}
