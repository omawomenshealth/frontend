import 'package:flutter/material.dart';

import '../../../../core/widgets/oma_theme.dart';
import '../../../../data/models/personal_insight_model.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../../../views/insights/view/insights_view.dart';

/// Home ekranındaki insight önizleme bölümü.
///
/// Insight mevcutsa yatay bir liste gösterir.
/// Henüz insight yoksa öğrenme durumunu gösteren placeholder görüntülenir.
///
/// Navigation işlemleri parent tarafından yönetilir.
class InsightsPreview extends StatelessWidget {
  final List<PersonalInsight> insights;
  final Color accent;
  final VoidCallback onViewAll;
  final ValueChanged<PersonalInsight> onInsightTap;

  const InsightsPreview({
    super.key,
    required this.insights,
    required this.accent,
    required this.onViewAll,
    required this.onInsightTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.t.home.common.insightsPreview;

    return Column(
      key: const ValueKey('dashboard_personal_insights'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.eyebrow,
          style: OmaText.label(
            color: accent,
            weight: FontWeight.w800,
          ).copyWith(
            fontSize: 9,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                strings.title,
                style: OmaText.display(
                  29,
                  style: FontStyle.normal,
                  color: OmaColors.foreground,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.7,
                ),
              ),
            ),
            TextButton(
              key: const ValueKey('dashboard_view_all_insights'),
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: OmaColors.muted,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(strings.viewAll),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (insights.isEmpty)
          _InsightPlaceholder(accent: accent)
        else
          SizedBox(
            height: 224,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(),
              itemCount: insights.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final insight = insights[index];

                return SizedBox(
                  width: 300,
                  child: PersonalInsightCard(
                    insight: insight,
                    onTap: () => onInsightTap(insight),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _InsightPlaceholder extends StatelessWidget {
  final Color accent;

  const _InsightPlaceholder({
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.t.home.common.insightsPreview;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Color.lerp(accent, OmaColors.card, 0.86),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            color: accent,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              strings.learning,
              style: OmaText.body(
                13,
                weight: FontWeight.w500,
                color: OmaColors.muted,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}