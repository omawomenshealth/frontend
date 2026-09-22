import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/period_calculator.dart';

/// Oma tasarım token'ları (web'deki src/styles.css karşılığı).
class OmaColors {
  static const scaffoldBackground = background;
  static const background = Color(0xFFFBF6EF); // surface-warm
  static const backgroundAlt = Color(0xFFF5EDE2);
  static const card = Color(0xFFFFFDF9);
  static const foreground = Color(0xFF3B342C);
  static const muted = Color(0xFF8C8175);
  static const border = Color(0xFFE7DCCB);
  static const primary = Color(0xFF7F9070); // sage
  static const primaryForeground = Color(0xFFFFFDF9);
  static const plum = Color(0xFF7A5468);
  static const plumForeground = Color(0xFFFFF6F1);
  static const periodPrimary = Color(0xFFC0606E);
  static const periodLight = Color(0xFFF7E5E7);
  static const ovulation = Color(0xFF8A72B0);
  static const lutealDark = Color(0xFF9A762B);

  static Color forCyclePhase(CyclePhase? phase) => switch (phase) {
    CyclePhase.menstrual => periodPrimary,
    CyclePhase.follicular => primary,
    CyclePhase.ovulation => ovulation,
    CyclePhase.luteal => lutealDark,
    null => primary,
  };

  // Hata / uyarı durumları için sıcak paletle uyumlu tonlar.
  // (Örn. giriş ekranındaki hata banner'ı, form validasyonu.)
  static const error = Color(0xFFB3564A); // warm terracotta
  static const errorForeground = Color(0xFFFFF6F1);
  static const errorLight = Color(0xFFF7E6E1); // banner arka planı
}

/// Faz kartlarında kullanılan faza özel görsel token'lar.
class OmaPhaseStyle {
  final String number;
  final Color accent;
  final Color strong;
  final Color soft;
  final Color border;
  final Color dayColor;
  final String flowerAsset;

  const OmaPhaseStyle({
    required this.number,
    required this.accent,
    required this.strong,
    required this.soft,
    required this.border,
    required this.dayColor,
    required this.flowerAsset,
  });

  static OmaPhaseStyle forPhase(CyclePhase phase) => switch (phase) {
    CyclePhase.menstrual => const OmaPhaseStyle(
      number: '01',
      accent: Color(0xFFB67A83),
      strong: Color(0xFFBE828C),
      soft: Color(0xFFFBF0EF),
      border: Color(0xFFEAD5D3),
      dayColor: Color(0xFF6F6063),
      flowerAsset: 'assets/images/decorative/blooms/oma-red-blossom.png',
    ),
    CyclePhase.follicular => const OmaPhaseStyle(
      number: '02',
      accent: Color(0xFF6E9775),
      strong: Color(0xFF819F7F),
      soft: Color(0xFFEEF4EA),
      border: Color(0xFFD7E3D3),
      dayColor: Color(0xFF324F3C),
      flowerAsset: 'assets/images/decorative/blooms/oma-orchid.png',
    ),
    CyclePhase.ovulation => const OmaPhaseStyle(
      number: '03',
      accent: Color(0xFF8B7AAE),
      strong: Color(0xFF9885BA),
      soft: Color(0xFFF4F0F9),
      border: Color(0xFFE0D9EC),
      dayColor: Color(0xFF665F75),
      flowerAsset: 'assets/images/decorative/blooms/oma-anemone.png',
    ),
    CyclePhase.luteal => const OmaPhaseStyle(
      number: '04',
      accent: Color(0xFFA18250),
      strong: Color(0xFFB18D54),
      soft: Color(0xFFFAF3E5),
      border: Color(0xFFE9DDC4),
      dayColor: Color(0xFF70634E),
      flowerAsset: 'assets/images/decorative/blooms/oma-daisy-warm.png',
    ),
  };
}

class OmaShadows {
  static const soft = <BoxShadow>[
    BoxShadow(color: Color(0x14503F2E), blurRadius: 18, offset: Offset(0, 6)),
  ];
  static const lift = <BoxShadow>[
    BoxShadow(color: Color(0x22503F2E), blurRadius: 28, offset: Offset(0, 12)),
  ];
}

class OmaText {
  static TextStyle display(double size, {FontStyle? style, Color? color}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        height: 1.15,
        fontStyle: style ?? FontStyle.italic,
        color: color ?? OmaColors.foreground,
      );

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color? color,
    double height = 1.5,
    double? letterSpacing,
  }) => GoogleFonts.dmSans(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color ?? OmaColors.foreground,
  );

  static TextStyle label({Color? color, FontWeight weight = FontWeight.w600}) =>
      body(
        12,
        weight: weight,
        color: color ?? OmaColors.foreground,
        height: 1.2,
      );

  static TextStyle caption({
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => body(12, weight: weight, color: color ?? OmaColors.muted, height: 1.35);
}

/// Sayfa arka planı: sıcak krem degrade.
class OmaSurface extends StatelessWidget {
  const OmaSurface({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [OmaColors.background, OmaColors.backgroundAlt],
        ),
      ),
      child: child,
    );
  }
}
