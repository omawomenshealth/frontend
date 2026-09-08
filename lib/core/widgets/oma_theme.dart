import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Oma tasarım token'ları (web'deki src/styles.css karşılığı).
class OmaColors {
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
  }) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? OmaColors.foreground,
      );
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
