import 'package:flutter/material.dart';

import '../../../../../core/constants/image_constants.dart';
import '../../../../../core/utils/pregnancy_calculator.dart';
import '../../../../../core/theme/oma_theme.dart';
import '../../../../../localization/generated/strings.g.dart';

class PregnancyHeroCard extends StatelessWidget {
  final PregnancyEstimate? estimate;
  final DateTime? positiveTestDate;

  const PregnancyHeroCard({
    super.key,
    required this.estimate,
    this.positiveTestDate,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.t.home.pregnancy;
    final presentation = _PregnancyPresentation.forWeek(
      estimate?.displayWeek ?? 1,
      context,
    );

    final week = estimate?.displayWeek;

    final source = switch (estimate?.source) {
      PregnancyEstimateSource.combined => strings.estimateCombined,
      PregnancyEstimateSource.lastPeriod => strings.estimateLastPeriod,
      PregnancyEstimateSource.sexualActivity => strings.estimateSexualActivity,
      null => strings.estimateUnavailable,
    };

    final dueDate = estimate == null
        ? null
        : strings.estimatedDueDate.replaceAll(
            '{date}',
            MaterialLocalizations.of(
              context,
            ).formatMediumDate(estimate!.estimatedDueDate),
          );

    final positiveTest = positiveTestDate == null
        ? null
        : strings.positiveTestRecorded.replaceAll(
            '{date}',
            MaterialLocalizations.of(
              context,
            ).formatMediumDate(positiveTestDate!),
          );

    return Semantics(
      label: '${presentation.title}. ${presentation.body}. $source',
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 408),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: presentation.softColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              width: 252,
              height: 252,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    presentation.assetPath,
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 22,
              bottom: 94,
              child: Icon(
                Icons.local_florist_outlined,
                color: presentation.color.withValues(alpha: 0.16),
                size: 54,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                OmaSpacing.xxl,
                18,
                OmaSpacing.xxl,
                OmaSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: OmaPalette.onMedia.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(OmaRadius.full),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OmaSpacing.md,
                        vertical: 7,
                      ),
                      child: Text(
                        strings.badge,
                        style: OmaText.label(
                          color: presentation.color,
                          weight: FontWeight.w800,
                        ).copyWith(fontSize: 9, letterSpacing: 1.35),
                      ),
                    ),
                  ),

                  const SizedBox(height: 42),

                  Text(
                    week == null
                        ? strings.estimatedWeek
                        : '${strings.estimatedWeek} · '
                              '${strings.weekAndDay.replaceAll('{week}', '${estimate!.completedWeeks}').replaceAll('{day}', '${estimate!.dayOfWeek}')}',
                    style: OmaText.label(
                      color: presentation.color,
                      weight: FontWeight.w800,
                    ).copyWith(fontSize: 10.5, letterSpacing: 0.45),
                  ),

                  const SizedBox(height: 5),

                  SizedBox(
                    width: 300,
                    child: Text(
                      presentation.title,
                      style: OmaText.display(31, color: presentation.color)
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.02,
                            letterSpacing: -0.8,
                          ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: 310,
                    child: Text(
                      presentation.body,
                      style: OmaText.body(
                        13,
                        weight: FontWeight.w500,
                        color: context.omaTheme.muted,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: OmaSpacing.sm),

                  _PregnancyInfoLine(
                    icon: Icons.calculate_outlined,
                    text: source,
                    color: presentation.color,
                  ),

                  if (positiveTest != null) ...[
                    const SizedBox(height: 6),
                    _PregnancyInfoLine(
                      icon: Icons.science_outlined,
                      text: positiveTest,
                      color: presentation.color,
                    ),
                  ],

                  if (dueDate != null) ...[
                    const SizedBox(height: 6),
                    _PregnancyInfoLine(
                      icon: Icons.event_outlined,
                      text: dueDate,
                      color: presentation.color,
                    ),
                  ],

                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: OmaPalette.onMedia.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(OmaRadius.lg),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_outlined,
                                color: presentation.color,
                                size: 16,
                              ),
                              const SizedBox(width: OmaSpacing.sm),
                              Expanded(
                                child: Text(
                                  strings.infoComingSoon,
                                  style: OmaText.caption(
                                    color: context.omaTheme.muted,
                                    weight: FontWeight.w700,
                                  ).copyWith(fontSize: 10.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: OmaSpacing.md),
                      _PregnancyWeekBadge(
                        color: presentation.color,
                        week: week,
                      ),
                    ],
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

class _PregnancyInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _PregnancyInfoLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: OmaText.caption(
              color: context.omaTheme.muted,
              weight: FontWeight.w600,
            ).copyWith(fontSize: 10.5),
          ),
        ),
      ],
    );
  }
}

class _PregnancyWeekBadge extends StatelessWidget {
  final Color color;
  final int? week;

  const _PregnancyWeekBadge({required this.color, required this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: OmaPalette.onMedia.withValues(alpha: 0.82),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            week?.toString() ?? '—',
            style: OmaText.display(
              22,
              color: color,
            ).copyWith(height: 0.95, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            context.t.home.pregnancy.weekLabel,
            textAlign: TextAlign.center,
            style: OmaText.body(
              8,
              weight: FontWeight.w700,
              color: context.omaTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _PregnancyPresentation {
  final Color color;
  final Color softColor;
  final String assetPath;
  final String title;
  final String body;

  const _PregnancyPresentation({
    required this.color,
    required this.softColor,
    required this.assetPath,
    required this.title,
    required this.body,
  });

  factory _PregnancyPresentation.forWeek(int week, BuildContext context) {
    final index = PregnancyStage.forWeek(week).index;
    final stages = context.t.home.pregnancy.stages;

    final colors = [
      OmaPalette.periodPrimary,
      OmaPalette.primary,
      OmaPalette.ovulation,
      OmaPalette.lutealDark,
      OmaPalette.ovulationDark,
      OmaPalette.primaryDark,
      OmaPalette.ovulation,
      OmaPalette.periodPrimary,
      OmaPalette.primaryDark,
    ];

    const softColors = OmaPalette.pregnancySoftTones;

    final assets = [
      ImageConstants.phaseMenstrualHero,
      ImageConstants.phaseFollicularHero,
      ImageConstants.phaseOvulationHero,
      ImageConstants.phaseLutealHero,
      ImageConstants.phaseMenstrualHero,
      ImageConstants.phaseFollicularHero,
      ImageConstants.phaseOvulationHero,
      ImageConstants.phaseMenstrualHero,
      ImageConstants.phaseFollicularHero,
    ];

    final stageCopy = switch (index) {
      0 => (title: stages.stage1.title, body: stages.stage1.body),
      1 => (title: stages.stage2.title, body: stages.stage2.body),
      2 => (title: stages.stage3.title, body: stages.stage3.body),
      3 => (title: stages.stage4.title, body: stages.stage4.body),
      4 => (title: stages.stage5.title, body: stages.stage5.body),
      5 => (title: stages.stage6.title, body: stages.stage6.body),
      6 => (title: stages.stage7.title, body: stages.stage7.body),
      7 => (title: stages.stage8.title, body: stages.stage8.body),
      _ => (title: stages.stage9.title, body: stages.stage9.body),
    };

    return _PregnancyPresentation(
      color: colors[index],
      softColor: softColors[index],
      assetPath: assets[index],
      title: stageCopy.title,
      body: stageCopy.body,
    );
  }
}
