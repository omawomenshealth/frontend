import 'package:flutter/material.dart';
import '../../../../core/utils/pregnancy_calculator.dart';
import '../../../../core/widgets/oma_theme.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../../../localization/generated/strings.g.dart';
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

      _ when cycleData != null => PhaseHeroCard(
          key: ValueKey(
            'dashboard_phase_${cycleData!.phase.name}',
          ),
          data: cycleData!,
          onOpenInsights: onOpenInsights,
        ),

      _ => const _HeroEmptyState(
          key: ValueKey('dashboard_hero_empty'),
        ),
    };
  }
}

/// Henüz döngü verisi (son adet tarihi) girilmemişken gösterilen kart.
class _HeroEmptyState extends StatelessWidget {
  const _HeroEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.t.home.common.hero;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: OmaColors.border),
        color: OmaColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.spa_outlined,
            color: OmaColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            strings.emptyTitle,
            style: OmaText.display(18, style: FontStyle.normal),
          ),
          const SizedBox(height: 8),
          Text(
            strings.emptyMessage,
            style: OmaText.body(
              14,
              color: OmaColors.muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}