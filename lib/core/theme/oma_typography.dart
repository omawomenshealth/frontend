import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_constants.dart';

class OmaTypography {
  OmaTypography._();

  static TextStyle display({
    double size = 32,
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.fraunces(
    fontSize: size,
    fontStyle: FontStyle.italic,
    fontWeight: weight,
    height: 1.15,
    color: color,
  );

  static TextStyle body({
    double size = 14,
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.w400,
    double height = 1.6,
  }) => GoogleFonts.dmSans(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color,
  );
}
