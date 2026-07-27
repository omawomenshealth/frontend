import 'package:flutter/material.dart';

/// Figma'daki OMA arayuzunden uretilen ortak renk sistemi.
///
/// Ekranlar dogrudan hex renk kullanmak yerine bu anlamsal renkleri tuketir.
class AppColors {
  AppColors._();

  // Marka ve vurgu renkleri
  static const Color primary = Color(0xFF89986D);
  static const Color primaryLight = Color(0xFFF0F2E7);
  static const Color primaryDark = Color(0xFF313B23);
  static const Color secondary = Color(0xFF8A72B0);
  static const Color secondaryLight = Color(0xFFF0EAF5);
  static const Color secondaryDark = Color(0xFF5E4E96);
  static const Color accent = Color(0xFFC0606E);
  static const Color accentLight = Color(0xFFF7E5E7);

  // Yuzeyler
  static const Color background = Color(0xFFF7F2EC);
  static const Color surface = Color(0xFFFFFDFC);
  static const Color surfaceMuted = Color(0xFFFAF7F3);
  static const Color cardBackground = Color(0xFFFFFDFC);
  static const Color scaffoldBackground = Color(0xFFF7F2EC);
  static const Color outline = Color(0xFFE7DED5);

  // Metinler
  static const Color textPrimary = Color(0xFF1A1C1A);
  static const Color textSecondary = Color(0xFF746D68);
  static const Color textHint = Color(0xFF9A918B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Ic goru kartlari
  static const Color insightRose = Color(0xFFA05050);
  static const Color insightRoseSurface = Color(0xFFF9E9EA);
  static const Color insightPurple = Color(0xFF5E4E96);
  static const Color insightPurpleSurface = Color(0xFFEDE8F5);
  static const Color insightBlue = Color(0xFF3A7090);
  static const Color insightBlueSurface = Color(0xFFDDF0F6);
  static const Color insightGold = Color(0xFF8A7038);
  static const Color insightGoldSurface = Color(0xFFF5E8D5);

  // Ruh hali
  static const Color moodHappy = Color(0xFF313B23);
  static const Color moodGood = Color(0xFF9CAB84);
  static const Color moodNeutral = Color(0xFF8AAFC4);
  static const Color moodSad = Color(0xFF9E8E86);
  static const Color moodAngry = Color(0xFFC0606E);
  static const Color moodAnxious = Color(0xFF8A72B0);
  static const Color moodPeaceful = Color(0xFF6A9E78);

  // Ilac ve dongu
  static const Color medicationPrimary = Color(0xFF4E88A8);
  static const Color medicationTaken = Color(0xFF6A9E78);
  static const Color medicationMissed = Color(0xFFC0606E);
  static const Color periodPrimary = Color(0xFFC0606E);
  static const Color periodLight = Color(0xFFF7E5E7);
  static const Color periodFlow = Color(0xFFA05050);
  static const Color ovulation = Color(0xFF8A72B0);
  static const Color fertile = Color(0xFF6A9E78);
  static const Color luteal = Color(0xFFFED276);
  static const Color lutealDark = Color(0xFF9A762B);

  // Durumlar
  static const Color success = Color(0xFF6A9E78);
  static const Color warning = Color(0xFFD8B36A);
  static const Color error = Color(0xFFC0606E);
  static const Color info = Color(0xFF8AAFC4);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9CAB84), Color(0xFF74835A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF9E9EA), Color(0xFFF3D8DD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFFEDF5F8), Color(0xFFDDF0F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFFFDFC), Color(0xFFF7F2EC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
