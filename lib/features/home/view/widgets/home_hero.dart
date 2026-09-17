import 'package:flutter/material.dart';
import '../../../../core/utils/pregnancy_calculator.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../viewmodel/cycle_hero_data.dart';
import 'hero/phase_hero_card.dart';
import 'hero/pregnancy_hero_card.dart';

/// Dashboard'un ana hero bölümü.
///
/// Kullanıcının takip moduna göre döngü veya gebelik kartını gösterir.
class HomeHeroSection extends StatelessWidget {
  final TrackingMode trackingMode;

  final CycleHeroData? cycleData;

  final PregnancyEstimate? pregnancyEstimate;
  final DateTime? positiveTestDate;

  final VoidCallback onOpenInsights;

  const HomeHeroSection({
    super.key,
    required this.trackingMode,
    required this.onOpenInsights,
    this.cycleData,
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
          key: ValueKey(
            'dashboard_phase_${cycleData!.phase.name}',
          ),
          data: cycleData!,
          onOpenInsights: onOpenInsights,
        ),
    };
  }
}