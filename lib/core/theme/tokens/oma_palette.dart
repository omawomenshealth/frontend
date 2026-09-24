import 'package:flutter/material.dart';

/// Raw, stable color tokens. Widgets should prefer `context.omaTheme` for
/// application-level semantic colors and use this palette only for genuinely
/// feature-specific or decorative meaning.
abstract final class OmaPalette {
  static const onMedia = Color(0xFFFFFFFF);
  static const onMediaMuted = Color(0xB3FFFFFF);
  static const mediaScrimLight = Color(0x18000000);
  static const mediaScrimMedium = Color(0x40000000);
  static const mediaScrimStrong = Color(0xB3000000);
  static const mediaTextShadow = Color(0x33000000);

  static const documentSurface = Color(0xFFFFFFFF);
  static const documentDivider = Color(0xFFEEEEEE);
  static const documentBorder = Color(0xFFE5E5E5);
  static const documentHeader = Color(0xFFF9F9F9);

  static const background = Color(0xFFFBF6EF);
  static const backgroundAlt = Color(0xFFF5EDE2);
  static const card = Color(0xFFFFFDF9);
  static const logoSurface = Color(0xFFFFFDF9);
  static const logoSurfaceDark = Color(0xFF25251F);
  static const surfaceMuted = Color(0xFFFAF7F3);
  static const foreground = Color(0xFF3B342C);
  static const muted = Color(0xFF8C8175);
  static const textHint = Color(0xFF9A918B);
  static const border = Color(0xFFE7DCCB);

  static const primary = Color(0xFF7F9070);
  static const primaryLight = Color(0xFFF0F2E7);
  static const primaryDark = Color(0xFF313B23);
  static const primaryForeground = Color(0xFFFFFDF9);
  static const plum = Color(0xFF7A5468);
  static const plumForeground = Color(0xFFFFF6F1);
  static const callout = Color(0xFFEEE5E1);
  static const calloutForeground = Color(0xFF7A4F63);

  static const periodPrimary = Color(0xFFC0606E);
  static const periodLight = Color(0xFFF7E5E7);
  static const periodFlow = Color(0xFFA05050);
  static const periodFlowTones = <Color>[
    Color(0xFFE8BAC0),
    Color(0xFFD9959E),
    Color(0xFFD97179),
    Color(0xFF9E3F4D),
  ];
  static const ovulation = Color(0xFF8A72B0);
  static const ovulationLight = Color(0xFFF0EAF5);
  static const ovulationDark = Color(0xFF5E4E96);
  static const luteal = Color(0xFFFED276);
  static const lutealDark = Color(0xFF9A762B);

  static const success = Color(0xFF6A9E78);
  static const warning = Color(0xFFD8B36A);
  static const info = Color(0xFF8AAFC4);
  static const error = Color(0xFFB3564A);
  static const errorForeground = Color(0xFFFFF6F1);
  static const errorLight = Color(0xFFF7E6E1);

  static const medicationPrimary = Color(0xFF4E88A8);
  static const skincarePrimary = Color(0xFFB06F88);

  static const moodHappy = primaryDark;
  static const moodGood = Color(0xFF9CAB84);
  static const moodNeutral = Color(0xFF8AAFC4);
  static const moodSad = Color(0xFF9E8E86);
  static const moodAngry = periodPrimary;
  static const moodPeaceful = Color(0xFF6A9E78);

  static const insightRose = Color(0xFFA05050);
  static const insightGold = Color(0xFF8A7038);

  static const pregnancySoftTones = <Color>[
    periodLight,
    Color(0xFFEAF0E5),
    Color(0xFFECE7F3),
    Color(0xFFFFF3D9),
    Color(0xFFF5E9EC),
    Color(0xFFE7F0EB),
    Color(0xFFF0EAF4),
    Color(0xFFF8E9EB),
    Color(0xFFE8EFE7),
  ];

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF9CAB84), Color(0xFF74835A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const tealGradient = LinearGradient(
    colors: [Color(0xFFEDF5F8), Color(0xFFDDF0F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
