import 'package:flutter/material.dart';

import '../../utils/period_calculator.dart';
import 'oma_color_scheme.dart';

abstract final class OmaCycleSchemes {
  static const menstrual = OmaColorScheme(
    primary: Color(0xFFB67A83),
    primaryStrong: Color(0xFFBE828C),
    primarySoft: Color(0xFFFBF0EF),
    border: Color(0xFFEAD5D3),
    accent: Color(0xFF6F6063),
    accentSoft: Color(0xFFF6E7E8),
  );

  static const follicular = OmaColorScheme(
    primary: Color(0xFF6E9775),
    primaryStrong: Color(0xFF819F7F),
    primarySoft: Color(0xFFEEF4EA),
    border: Color(0xFFD7E3D3),
    accent: Color(0xFF324F3C),
    accentSoft: Color(0xFFE4EEE2),
  );

  static const ovulation = OmaColorScheme(
    primary: Color(0xFF8B7AAE),
    primaryStrong: Color(0xFF9885BA),
    primarySoft: Color(0xFFF4F0F9),
    border: Color(0xFFE0D9EC),
    accent: Color(0xFF665F75),
    accentSoft: Color(0xFFECE6F4),
  );

  static const luteal = OmaColorScheme(
    primary: Color(0xFFA18250),
    primaryStrong: Color(0xFFB18D54),
    primarySoft: Color(0xFFFAF3E5),
    border: Color(0xFFE9DDC4),
    accent: Color(0xFF70634E),
    accentSoft: Color(0xFFF3E8D2),
  );

  static OmaColorScheme forPhase(CyclePhase phase) => switch (phase) {
    CyclePhase.menstrual => menstrual,
    CyclePhase.follicular => follicular,
    CyclePhase.ovulation => ovulation,
    CyclePhase.luteal => luteal,
  };
}
