import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renk sabitleri.
/// Wellness temalı, modern ve sakinleştirici bir palet.
class AppColors {
  AppColors._();

  // ── Ana Renkler ──────────────────────────────────────────
  static const Color primary = Color(0xFFA1887F);       // Kahverengi
  static const Color primaryLight = Color(0xFFD7CCC8);
  static const Color primaryDark = Color(0xFF5D4037);

  static const Color secondary = Color(0xFFAED581);     // Adaçayı Yeşili
  static const Color secondaryLight = Color(0xFFDCEDC8);
  static const Color secondaryDark = Color(0xFF689F38);

  static const Color accent = Color(0xFFE64A19);        // Kiremit Rengi
  static const Color accentLight = Color(0xFFFFCCBC);

  // ── Arka Plan ────────────────────────────────────────────
  static const Color background = Color(0xFFFAF8F5);    // Krem
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF7F3F0); // Açık Krem

  // ── Metin ────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF3E2723);
  static const Color textSecondary = Color(0xFF795548);
  static const Color textHint = Color(0xFFBCAAA4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Modül Renkleri ───────────────────────────────────────
  // Mood
  static const Color moodHappy = Color(0xFFFFD54F);
  static const Color moodGood = Color(0xFFAED581);
  static const Color moodNeutral = Color(0xFF90CAF9);
  static const Color moodSad = Color(0xFFBCAAA4);
  static const Color moodAngry = Color(0xFFE57373);
  static const Color moodAnxious = Color(0xFFCE93D8);
  static const Color moodPeaceful = Color(0xFF80CBC4);

  // İlaç & Takviye
  static const Color medicationPrimary = Color(0xFF80CBC4);
  static const Color medicationTaken = Color(0xFFAED581);
  static const Color medicationMissed = Color(0xFFE57373);

  // Regl / Döngü
  static const Color periodPrimary = Color(0xFFE57373);
  static const Color periodLight = Color(0xFFFFCDD2);
  static const Color periodFlow = Color(0xFFD32F2F);
  static const Color ovulation = Color(0xFF81C784);
  static const Color fertile = Color(0xFFAED581);
  static const Color luteal = Color(0xFFFFD54F);

  // ── Durum Renkleri ───────────────────────────────────────
  static const Color success = Color(0xFFAED581);
  static const Color warning = Color(0xFFFFD54F);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF90CAF9);

  // ── Gradient'ler ─────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFD7CCC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFFCCBC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [secondary, Color(0xFFDCEDC8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF7F3F0), Color(0xFFEFEBE9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Cinsiyet Renkleri ────────────────────────────────────
  static const Color female = Color(0xFFE84393);
  static const Color male = Color(0xFF4D96FF);
}
