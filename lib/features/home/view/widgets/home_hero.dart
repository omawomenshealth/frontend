import 'package:flutter/material.dart';

import '../../../../core/utils/period_calculator.dart';
import '../../../../core/utils/pregnancy_calculator.dart';
import '../../../../data/models/user_settings_model.dart';
import 'hero/phase_hero_card.dart';
import 'hero/pregnancy_hero_card.dart';

/// Dashboard'un ana hero bölümü.
///
/// Kullanıcının takip moduna göre döngü veya gebelik kartını gösterir.
class HomeHeroSection extends StatelessWidget {
  final TrackingMode trackingMode;

  // Cycle
  final CyclePhase phase;
  final int cycleDay;
  final int cycleLength;
  final String? forecastSummary;
  final int? daysUntilPeriod;
  final VoidCallback onOpenInsights;

  // Pregnancy
  final PregnancyEstimate? pregnancyEstimate;
  final DateTime? positiveTestDate;

  const HomeHeroSection({
    super.key,
    required this.trackingMode,
    required this.phase,
    required this.cycleDay,
    required this.cycleLength,
    required this.onOpenInsights,
    required this.daysUntilPeriod,
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
          key: ValueKey('dashboard_phase_${phase.name}'),
          phase: phase,
          cycleDay: cycleDay,
          cycleLength: cycleLength,
          forecastSummary: forecastSummary,
          daysUntilPeriod: daysUntilPeriod,
          onOpenInsights: onOpenInsights,
        ),
    };
  }
}