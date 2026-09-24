import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class OmaTypeScale {
  static const double micro = 10;
  static const double caption = 12;
  static const double body = 14;
  static const double bodyLarge = 16;
  static const double title = 20;
  static const double heading = 24;
  static const double display = 32;
}

abstract final class OmaText {
  static TextStyle display(
    double size, {
    FontStyle? style,
    FontWeight? weight,
    Color? color,
  }) => GoogleFonts.fraunces(
    fontSize: size,
    height: 1.15,
    fontStyle: style ?? FontStyle.italic,
    fontWeight: weight,
    color: color,
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
    color: color,
  );

  static TextStyle label({Color? color, FontWeight weight = FontWeight.w600}) =>
      body(OmaTypeScale.caption, weight: weight, color: color, height: 1.2);

  static TextStyle caption({
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) => body(OmaTypeScale.caption, weight: weight, color: color, height: 1.35);
}
