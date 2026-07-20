import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/personal_insight_model.dart';
import '../viewmodel/insights_view_model.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer<InsightsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: vm.loadData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    sliver: SliverToBoxAdapter(child: _buildHeader()),
                  ),
                  if (vm.isLoading && vm.insights.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.insights.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList.separated(
                        itemCount: vm.insights.length,
                        itemBuilder: (context, index) =>
                            _InsightCard(insight: vm.insights[index]),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                      sliver: SliverToBoxAdapter(child: _buildDisclaimer()),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.insights,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.insightsSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.phone_android_rounded,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.insightsPrivacyNote,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_rounded,
              size: 42,
              color: AppColors.secondaryDark,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.insightsEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.insightsEmptyDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 17,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            AppStrings.insightsDisclaimer,
            style: const TextStyle(
              fontSize: 11,
              height: 1.45,
              color: AppColors.textHint,
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final PersonalInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final presentation = _InsightPresentation.from(insight);
    return Semantics(
      label: '${presentation.title}. ${presentation.body}',
      child: Container(
        key: ValueKey('personal_insight_${insight.id}'),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: presentation.color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                presentation.icon,
                size: 22,
                color: presentation.color,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    presentation.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    presentation.body,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: presentation.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fact_check_outlined,
                          size: 13,
                          color: presentation.color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          presentation.evidence,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: presentation.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightPresentation {
  final String title;
  final String body;
  final String evidence;
  final IconData icon;
  final Color color;

  const _InsightPresentation({
    required this.title,
    required this.body,
    required this.evidence,
    required this.icon,
    required this.color,
  });

  factory _InsightPresentation.from(PersonalInsight insight) {
    final primary = insight.primaryLabel == null
        ? ''
        : AppStrings.localizeInsightFeature(insight.primaryLabel!);
    final secondary = insight.secondaryLabel == null
        ? ''
        : AppStrings.localizeInsightFeature(insight.secondaryLabel!);

    late final String title;
    late final String body;
    late final IconData icon;
    late final Color color;

    switch (insight.kind) {
      case PersonalInsightKind.dataBuilding:
        title = AppStrings.insightDataBuildingTitle;
        body = AppStrings.insightDataBuildingBody(insight.value!);
        icon = Icons.hourglass_top_rounded;
        color = AppColors.info;
      case PersonalInsightKind.recordingSummary:
        title = AppStrings.insightRecordingSummaryTitle;
        body = AppStrings.insightRecordingSummaryBody(
          loggedDays: insight.value!,
          spanDays: insight.comparisonValue!,
        );
        icon = Icons.calendar_view_month_rounded;
        color = AppColors.primary;
      case PersonalInsightKind.cycleLength:
        title = AppStrings.insightCycleLengthTitle;
        body = AppStrings.insightCycleLengthBody(insight.value!);
        icon = Icons.autorenew_rounded;
        color = AppColors.periodPrimary;
      case PersonalInsightKind.cycleVariation:
        title = AppStrings.insightCycleVariationTitle;
        body = AppStrings.insightCycleVariationBody(
          count: insight.total!,
          min: insight.value!,
          max: insight.comparisonValue!,
        );
        icon = Icons.show_chart_rounded;
        color = AppColors.luteal;
      case PersonalInsightKind.periodDuration:
        title = AppStrings.insightPeriodDurationTitle;
        body = AppStrings.insightPeriodDurationBody(insight.value!);
        icon = Icons.water_drop_rounded;
        color = AppColors.periodFlow;
      case PersonalInsightKind.frequentMood:
        title = AppStrings.insightFrequentMoodTitle;
        body = AppStrings.insightFrequentMoodBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.mood_rounded;
        color = AppColors.secondaryDark;
      case PersonalInsightKind.recurringSymptom:
        title = AppStrings.insightRecurringSymptomTitle;
        body = AppStrings.insightRecurringSymptomBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.healing_rounded;
        color = AppColors.accent;
      case PersonalInsightKind.frequentActivity:
        title = AppStrings.insightFrequentActivityTitle;
        body = AppStrings.insightFrequentActivityBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.directions_walk_rounded;
        color = AppColors.primary;
      case PersonalInsightKind.frequentNutrition:
        title = AppStrings.insightFrequentNutritionTitle;
        body = AppStrings.insightFrequentNutritionBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.restaurant_rounded;
        color = AppColors.warning;
      case PersonalInsightKind.frequentBowel:
        title = AppStrings.insightFrequentBowelTitle;
        body = AppStrings.insightFrequentBowelBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.waves_rounded;
        color = AppColors.info;
      case PersonalInsightKind.symptomMoodCooccurrence:
        title = AppStrings.insightSymptomMoodTitle;
        body = AppStrings.insightSymptomMoodBody(
          primary: primary,
          secondary: secondary,
          count: insight.value!,
        );
        icon = Icons.join_inner_rounded;
        color = AppColors.secondaryDark;
      case PersonalInsightKind.symptomBleedingCooccurrence:
        title = AppStrings.insightSymptomBleedingTitle;
        body = AppStrings.insightSymptomBleedingBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.bubble_chart_rounded;
        color = AppColors.periodPrimary;
      case PersonalInsightKind.structuredAssociation:
        title = AppStrings.insightAssociationTitle;
        body = AppStrings.insightAssociationBody(
          primary: primary,
          secondary: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
          lagDays: insight.lagDays!,
        );
        icon = Icons.account_tree_outlined;
        color = AppColors.primaryDark;
      case PersonalInsightKind.medicationAdherence:
        title = AppStrings.insightMedicationAdherenceTitle;
        body = AppStrings.insightMedicationAdherenceBody(
          taken: insight.value!,
          total: insight.total!,
        );
        icon = Icons.medication_outlined;
        color = AppColors.medicationPrimary;
      case PersonalInsightKind.medicationSkipSymptomAssociation:
        title = AppStrings.insightMedicationSkipAssociationTitle;
        body = AppStrings.insightMedicationSkipAssociationBody(
          primary: primary,
          secondary: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.medication_liquid_outlined;
        color = AppColors.accent;
      case PersonalInsightKind.fertileDischargeSignal:
        title = AppStrings.insightFertileDischargeTitle;
        body = AppStrings.insightFertileDischargeBody(
          color: primary,
          consistency: secondary,
        );
        icon = Icons.spa_outlined;
        color = AppColors.ovulation;
      case PersonalInsightKind.menstrualDischargeContext:
        title = AppStrings.insightMenstrualDischargeTitle;
        body = AppStrings.insightMenstrualDischargeBody(primary);
        icon = Icons.water_drop_outlined;
        color = AppColors.periodPrimary;
      case PersonalInsightKind.dischargeHealthNotice:
        title = AppStrings.insightDischargeHealthTitle;
        body = AppStrings.insightDischargeHealthBody;
        icon = Icons.health_and_safety_outlined;
        color = AppColors.warning;
    }

    return _InsightPresentation(
      title: title,
      body: body,
      evidence: _evidenceText(insight),
      icon: icon,
      color: color,
    );
  }

  static String _evidenceText(PersonalInsight insight) {
    if (insight.confidence != null) {
      return AppStrings.insightAssociationEvidence(
        confidence: AppStrings.insightConfidenceLabel(insight.confidence!.name),
        count: insight.evidenceCount,
      );
    }
    final count = insight.evidenceCount;
    return switch (insight.evidenceUnit) {
      PersonalInsightEvidenceUnit.days => AppStrings.insightEvidenceDays(count),
      PersonalInsightEvidenceUnit.cycles => AppStrings.insightEvidenceCycles(
        count,
      ),
      PersonalInsightEvidenceUnit.entries => AppStrings.insightEvidenceEntries(
        count,
      ),
      PersonalInsightEvidenceUnit.records => AppStrings.insightEvidenceRecords(
        count,
      ),
    };
  }

  static int _percentage(int value, int total) =>
      total == 0 ? 0 : (value * 100 / total).round();
}
