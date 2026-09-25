import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/widgets/oma_wrap.dart';
import '../../../data/models/personal_insight_model.dart';
import '../viewmodel/insights_view_model.dart';

part 'insights_story_view.dart';

class InsightsListView extends StatelessWidget {
  const InsightsListView({super.key});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer<InsightsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: context.omaTheme.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: vm.loadData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      OmaSpacing.lg,
                      OmaSpacing.xxl,
                      OmaSpacing.lg,
                      OmaSpacing.md,
                    ),
                    sliver: SliverToBoxAdapter(child: _buildHeader(context)),
                  ),
                  if (vm.isLoading && vm.insights.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.insights.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(context),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OmaSpacing.lg,
                      ),
                      sliver: SliverList.separated(
                        itemCount: vm.insights.length,
                        itemBuilder: (context, index) =>
                            PersonalInsightCard(insight: vm.insights[index]),
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: OmaSpacing.md),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        OmaSpacing.xl,
                        OmaSpacing.xl,
                        OmaSpacing.xl,
                        110,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildDisclaimer(context),
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InsightsPageHeader(
          title: AppStrings.insights,
          subtitle: AppStrings.insightsSubtitle,
          icon: Icons.auto_awesome_outlined,
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.omaTheme.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(OmaRadius.xl),
            border: Border.all(
              color: context.omaTheme.primary.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.phone_android_rounded,
                size: 19,
                color: context.omaTheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.insightsPrivacyNote,
                  style: TextStyle(
                    fontSize: OmaTypeScale.caption,
                    height: 1.45,
                    color: context.omaTheme.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OmaSpacing.xxxl,
        OmaSpacing.xl,
        OmaSpacing.xxxl,
        120,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: OmaPalette.ovulation.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_rounded,
              size: 42,
              color: OmaPalette.ovulationDark,
            ),
          ),
          const SizedBox(height: OmaSpacing.xl),
          Text(
            AppStrings.insightsEmptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.omaTheme.foreground,
            ),
          ),
          const SizedBox(height: OmaSpacing.sm),
          Text(
            AppStrings.insightsEmptyDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: context.omaTheme.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 17,
          color: OmaPalette.textHint,
        ),
        const SizedBox(width: OmaSpacing.sm),
        Expanded(
          child: Text(
            AppStrings.insightsDisclaimer,
            style: TextStyle(
              fontSize: 11,
              height: 1.45,
              color: OmaPalette.textHint,
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightsPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const _InsightsPageHeader({
    required this.title,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: oma.primarySoft,
            borderRadius: BorderRadius.circular(OmaRadius.lg),
          ),
          child: Icon(icon, size: 21, color: oma.primaryStrong),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: OmaSpacing.xxs),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class PersonalInsightCard extends StatelessWidget {
  final PersonalInsight insight;
  final VoidCallback? onTap;

  const PersonalInsightCard({super.key, required this.insight, this.onTap});

  @override
  Widget build(BuildContext context) {
    final presentation = _InsightPresentation.from(insight, context.omaTheme);
    final card = Container(
      key: ValueKey('personal_insight_${insight.id}'),
      width: double.infinity,
      padding: const EdgeInsets.all(OmaSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.lerp(presentation.color, context.omaTheme.surface, 0.83)!,
            Color.lerp(presentation.color, context.omaTheme.surface, 0.93)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(OmaRadius.xl),
        boxShadow: OmaShadows.soft(presentation.color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: presentation.color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(OmaRadius.md),
            ),
            child: Icon(presentation.icon, size: 22, color: presentation.color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  presentation.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  presentation.body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: context.omaTheme.muted,
                  ),
                ),
                const SizedBox(height: OmaSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: presentation.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(OmaRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fact_check_outlined,
                        size: 13,
                        color: presentation.color,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          presentation.evidence,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: OmaTypeScale.micro,
                            fontWeight: FontWeight.w600,
                            color: presentation.color,
                          ),
                        ),
                      ),
                      if (onTap != null) ...[
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: presentation.color,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: onTap != null,
      label: '${presentation.title}. ${presentation.body}',
      child: onTap == null
          ? card
          : _PressableInsightCard(onTap: onTap!, child: card),
    );
  }
}

class _PressableInsightCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _PressableInsightCard({required this.onTap, required this.child});

  @override
  State<_PressableInsightCard> createState() => _PressableInsightCardState();
}

class _PressableInsightCardState extends State<_PressableInsightCard> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: const Duration(milliseconds: 120),
          child: widget.child,
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

  factory _InsightPresentation.from(PersonalInsight insight, OmaTheme theme) {
    final primary = insight.primaryLabel == null
        ? ''
        : AppStrings.localizeInsightFeature(insight.primaryLabel!);
    final secondary = insight.secondaryLabel == null
        ? ''
        : AppStrings.localizeInsightFeature(insight.secondaryLabel!);
    final contexts = insight.contextLabels
        .map(AppStrings.localizeInsightFeature)
        .toList(growable: false);

    late final String title;
    late final String body;
    late final IconData icon;
    late final Color color;

    switch (insight.kind) {
      case PersonalInsightKind.dataBuilding:
        title = AppStrings.insightDataBuildingTitle;
        body = AppStrings.insightDataBuildingBody(insight.value!);
        icon = Icons.hourglass_top_rounded;
        color = OmaPalette.info;
      case PersonalInsightKind.recordingSummary:
        title = AppStrings.insightRecordingSummaryTitle;
        body = AppStrings.insightRecordingSummaryBody(
          loggedDays: insight.value!,
          spanDays: insight.comparisonValue!,
        );
        icon = Icons.calendar_view_month_rounded;
        color = theme.primary;
      case PersonalInsightKind.cycleLength:
        title = AppStrings.insightCycleLengthTitle;
        body = AppStrings.insightCycleLengthBody(insight.value!);
        icon = Icons.autorenew_rounded;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.cycleVariation:
        title = AppStrings.insightCycleVariationTitle;
        body = AppStrings.insightCycleVariationBody(
          count: insight.total!,
          min: insight.value!,
          max: insight.comparisonValue!,
        );
        icon = Icons.show_chart_rounded;
        color = OmaPalette.luteal;
      case PersonalInsightKind.cycleTimingReview:
        title = AppStrings.insightCycleTimingReviewTitle;
        body = AppStrings.insightCycleTimingReviewBody(insight.value!);
        icon = Icons.event_repeat_rounded;
        color = OmaPalette.warning;
      case PersonalInsightKind.periodDuration:
        title = AppStrings.insightPeriodDurationTitle;
        body = AppStrings.insightPeriodDurationBody(insight.value!);
        icon = Icons.water_drop_rounded;
        color = OmaPalette.periodFlow;
      case PersonalInsightKind.periodTrackingStarted:
        title = AppStrings.insightPeriodTrackingTitle;
        body = AppStrings.insightPeriodTrackingBody;
        icon = Icons.bookmark_added_outlined;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.periodSymptomPattern:
        title = AppStrings.insightPeriodSymptomTitle;
        body = AppStrings.insightPeriodSymptomBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.monitor_heart_outlined;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.periodDurationReview:
        title = AppStrings.insightPeriodDurationReviewTitle;
        body = AppStrings.insightPeriodDurationReviewBody(
          duration: insight.value!,
          comparison: insight.comparisonValue,
        );
        icon = Icons.timelapse_rounded;
        color = OmaPalette.warning;
      case PersonalInsightKind.frequentMood:
        title = AppStrings.insightFrequentMoodTitle;
        body = AppStrings.insightFrequentMoodBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.mood_rounded;
        color = OmaPalette.ovulationDark;
      case PersonalInsightKind.recurringSymptom:
        title = AppStrings.insightRecurringSymptomTitle;
        body = AppStrings.insightRecurringSymptomBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.healing_rounded;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.symptomMoodCooccurrence:
        title = AppStrings.insightSymptomMoodTitle;
        body = AppStrings.insightSymptomMoodBody(
          primary: primary,
          secondary: secondary,
          count: insight.value!,
        );
        icon = Icons.join_inner_rounded;
        color = OmaPalette.ovulationDark;
      case PersonalInsightKind.symptomBleedingCooccurrence:
        title = AppStrings.insightSymptomBleedingTitle;
        body = AppStrings.insightSymptomBleedingBody(
          label: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.bubble_chart_rounded;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.moodCyclePhaseAssociation:
        title = AppStrings.insightMoodCyclePhaseTitle;
        body = AppStrings.insightMoodCyclePhaseBody(
          mood: primary,
          phase: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.donut_large_rounded;
        color = OmaPalette.luteal;
      case PersonalInsightKind.symptomCyclePhaseAssociation:
        title = AppStrings.insightSymptomCyclePhaseTitle;
        body = AppStrings.insightSymptomCyclePhaseBody(
          symptom: primary,
          phase: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.monitor_heart_outlined;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.moodSymptomAssociation:
        title = AppStrings.insightMoodSymptomTitle;
        body = AppStrings.insightMoodSymptomBody(
          mood: primary,
          symptom: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.psychology_alt_outlined;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.moodFoodAssociation:
        title = AppStrings.insightMoodFoodTitle;
        body = AppStrings.insightMoodFoodBody(
          mood: primary,
          food: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.restaurant_menu_rounded;
        color = OmaPalette.ovulationDark;
      case PersonalInsightKind.moodCravingAssociation:
        title = AppStrings.insightMoodCravingTitle;
        body = AppStrings.insightMoodCravingBody(
          mood: primary,
          craving: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.icecream_outlined;
        color = OmaPalette.ovulation;
      case PersonalInsightKind.foodBowelAssociation:
        title = AppStrings.insightFoodBowelTitle;
        body = AppStrings.insightFoodBowelBody(
          food: primary,
          bowel: secondary,
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
        icon = Icons.waves_rounded;
        color = OmaPalette.info;
      case PersonalInsightKind.moodPlaceAssociation:
        title = AppStrings.insightMoodPlaceTitle;
        body = AppStrings.insightMoodPlaceBody(
          mood: primary,
          place: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.place_outlined;
        color = theme.primaryStrong;
      case PersonalInsightKind.moodCompanionAssociation:
        title = AppStrings.insightMoodCompanionTitle;
        body = AppStrings.insightMoodCompanionBody(
          mood: primary,
          companion: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.people_alt_outlined;
        color = theme.primary;
      case PersonalInsightKind.stressCompanionAssociation:
        title = AppStrings.insightStressCompanionTitle;
        body = AppStrings.insightStressCompanionBody(
          companion: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.people_alt_outlined;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.stressCravingAssociation:
        title = AppStrings.insightStressCravingTitle;
        body = AppStrings.insightStressCravingBody(
          craving: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.icecream_outlined;
        color = OmaPalette.ovulation;
      case PersonalInsightKind.stressFoodAssociation:
        title = AppStrings.insightStressFoodTitle;
        body = AppStrings.insightStressFoodBody(
          food: secondary,
          withEvent: insight.withEventCount!,
          withTotal: insight.withTotal!,
          withoutTotal: insight.withoutTotal!,
          withPercent: _percentage(insight.withEventCount!, insight.withTotal!),
          withoutPercent: _percentage(
            insight.withoutEventCount!,
            insight.withoutTotal!,
          ),
        );
        icon = Icons.restaurant_menu_rounded;
        color = OmaPalette.ovulationDark;
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
        color = theme.primaryStrong;
      case PersonalInsightKind.foodObservationStarted:
        title = AppStrings.insightFoodObservationTitle;
        body =
            '${AppStrings.insightFoodObservationBody(primary: primary, secondary: secondary)} '
            '${AppStrings.insightContextNote(contexts)}';
        icon = Icons.search_rounded;
        color = OmaPalette.ovulationDark;
      case PersonalInsightKind.foodPatternBuilding:
        title = AppStrings.insightFoodPatternBuildingTitle;
        body =
            '${AppStrings.insightFoodPatternBuildingBody(primary: primary, secondary: secondary, withEvent: insight.withEventCount!, withTotal: insight.withTotal!)} '
            '${AppStrings.insightContextNote(contexts)}';
        icon = Icons.hub_outlined;
        color = OmaPalette.ovulationDark;
      case PersonalInsightKind.foodSensitivityAssociation:
        title = AppStrings.insightFoodSensitivityTitle;
        body =
            '${AppStrings.insightFoodSensitivityBody(primary: primary, secondary: secondary, withEvent: insight.withEventCount!, withTotal: insight.withTotal!, withoutTotal: insight.withoutTotal!, withPercent: _percentage(insight.withEventCount!, insight.withTotal!), withoutPercent: _percentage(insight.withoutEventCount!, insight.withoutTotal!))} '
            '${AppStrings.insightContextNote(contexts)}';
        icon = Icons.food_bank_outlined;
        color = OmaPalette.warning;
      case PersonalInsightKind.medicationAdherence:
        title = AppStrings.insightMedicationAdherenceTitle;
        body = AppStrings.insightMedicationAdherenceBody(
          taken: insight.value!,
          total: insight.total!,
        );
        icon = Icons.medication_outlined;
        color = OmaPalette.medicationPrimary;
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
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.biotinLabInteraction:
        title = AppStrings.biotinInsightTitle;
        body = AppStrings.biotinInsightBody;
        icon = Icons.science_outlined;
        color = OmaPalette.warning;
      case PersonalInsightKind.doctorReportPremiumReady:
        title = AppStrings.premiumDoctorReportInsightTitle;
        body = AppStrings.premiumDoctorReportInsightBody;
        icon = Icons.workspace_premium_outlined;
        color = OmaPalette.insightGold;
      case PersonalInsightKind.dischargeBaselineObservation:
        title = AppStrings.insightDischargeBaselineTitle;
        body = AppStrings.insightDischargeBaselineBody(
          color: primary,
          consistency: secondary.isEmpty ? null : secondary,
        );
        icon = Icons.water_drop_outlined;
        color = OmaPalette.info;
      case PersonalInsightKind.fertileDischargeSignal:
        title = AppStrings.insightFertileDischargeTitle;
        body = AppStrings.insightFertileDischargeBody(
          color: primary,
          consistency: secondary,
        );
        icon = Icons.spa_outlined;
        color = OmaPalette.ovulation;
      case PersonalInsightKind.menstrualDischargeContext:
        title = AppStrings.insightMenstrualDischargeTitle;
        body = AppStrings.insightMenstrualDischargeBody(primary);
        icon = Icons.water_drop_outlined;
        color = OmaPalette.periodPrimary;
      case PersonalInsightKind.dischargeHealthNotice:
        title = AppStrings.insightDischargeHealthTitle;
        body = AppStrings.insightDischargeHealthBody;
        icon = Icons.health_and_safety_outlined;
        color = OmaPalette.warning;
      case PersonalInsightKind.sexualAfterFeelingPattern:
        title = AppStrings.insightSexualAfterPatternTitle;
        body = AppStrings.insightSexualAfterPatternBody(
          feeling: primary,
          count: insight.value!,
          total: insight.total!,
        );
        icon = Icons.favorite_outline_rounded;
        color = OmaPalette.ovulationDark;
      case PersonalInsightKind.unprotectedFertileWindowNotice:
        title = AppStrings.insightUnprotectedFertileTitle;
        body = AppStrings.insightUnprotectedFertileBody;
        icon = Icons.health_and_safety_outlined;
        color = OmaPalette.warning;
      case PersonalInsightKind.fertileWindowFocus:
        title = AppStrings.insightFertilityFocusTitle;
        body = AppStrings.insightFertilityFocusBody;
        icon = Icons.favorite_outline_rounded;
        color = OmaPalette.ovulation;
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
    if (insight.kind == PersonalInsightKind.biotinLabInteraction) {
      return AppStrings.biotinInsightEvidence;
    }
    if (insight.confidence != null &&
        insight.evidenceUnit == PersonalInsightEvidenceUnit.days) {
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
