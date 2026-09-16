import 'package:flutter/material.dart';

import '../../../../core/utils/period_calculator.dart';
import '../../../../core/utils/pregnancy_calculator.dart';
import '../../../../data/models/user_settings_model.dart';
import 'hero/phase_hero_card.dart';
import 'hero/pregnancy_hero_card.dart';

/// Dashboard'un ana hero bölümü.
///
/// Kullanıcının takip moduna göre döngü veya gebelik kartını gösterir.
/// Kartların kendi görsel ve presentation logic'i ilgili hero widget'larında
/// yönetilir.
class HomeHeroSection extends StatelessWidget {
  final TrackingMode trackingMode;

  // Döngü modu
  final CyclePhase phase;
  final int cycleDay;
  final int periodCount;
  final String? forecastSummary;
  final VoidCallback onOpenInsights;
  final VoidCallback onPeriodTap;

  // Gebelik modu
  final PregnancyEstimate? pregnancyEstimate;
  final DateTime? positiveTestDate;

  const HomeHeroSection({
    super.key,
    required this.trackingMode,
    required this.phase,
    required this.cycleDay,
    required this.periodCount,
    required this.onOpenInsights,
    required this.onPeriodTap,
    this.forecastSummary,
    this.pregnancyEstimate,
    this.positiveTestDate,
  });

  @override
  Widget build(BuildContext context) {
    return switch (trackingMode) {
      TrackingMode.pregnant => PregnancyHeroCard(
          key: const ValueKey('dashboard_pregnancy_hero'),
          estimate: pregnancyEstimate,
          positiveTestDate: positiveTestDate,
        ),
      _ => PhaseHeroCard(
          key: const ValueKey('dashboard_phase_hero'),
          phase: phase,
          cycleDay: cycleDay,
          periodCount: periodCount,
          forecastSummary: forecastSummary,
          onOpenInsights: onOpenInsights,
          onPeriodTap: onPeriodTap,
        ),
    };
  }
}