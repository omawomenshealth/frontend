import 'package:flutter/material.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/oma_divider.dart';
import '../../../data/services/local_storage_service.dart';

/// Döngülerim istatistik kartı — rakip uygulamadaki gibi
/// önceki döngü süresi, regl süresi ve döngü değişkenliğini gösterir.
/// Tüm veriler gerçek kayıtlardan hesaplanır.
class CycleInsightsCard extends StatelessWidget {
  final CycleInsights insights;

  const CycleInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;
    return Container(
      padding: const EdgeInsets.all(OmaSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.surface, theme.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(OmaRadius.xl),
        border: Border.all(color: theme.border),
        boxShadow: OmaShadows.soft(theme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Text(
                AppStrings.myCycles,
                style: TextStyle(
                  fontSize: OmaTypeScale.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: theme.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: OmaSpacing.lg),

          // 1. Önceki döngü süresi
          _buildInsightRow(
            theme: theme,
            label: AppStrings.previousCycleLength,
            value: insights.previousCycleLength != null
                ? AppStrings.dayCount(insights.previousCycleLength!)
                : AppStrings.noDataStatus,
            status: insights.cycleStatus,
            statusLabel: _cycleStatusLabel(insights.cycleStatus),
            infoText: AppStrings.normalCycleRange,
          ),

          OmaDivider(color: theme.divider.withValues(alpha: 0.7), height: 1),

          // 2. Önceki regl süresi
          _buildInsightRow(
            theme: theme,
            label: AppStrings.previousPeriodLength,
            value: AppStrings.dayCount(insights.previousPeriodLength),
            status: insights.periodStatus,
            statusLabel: _cycleStatusLabel(insights.periodStatus),
            infoText: AppStrings.normalPeriodRange,
          ),

          OmaDivider(color: theme.divider.withValues(alpha: 0.7), height: 1),

          // 3. Döngü süresi değişkenliği
          _buildInsightRow(
            theme: theme,
            label: AppStrings.cycleLengthVariation,
            value:
                insights.variationMin != null && insights.variationMax != null
                ? '${insights.variationMin}-${insights.variationMax} ${AppStrings.daysUnit}'
                : AppStrings.insufficientData,
            status: _regularityToCycleStatus(insights.regularity),
            statusLabel: _regularityLabel(insights.regularity),
            infoText: AppStrings.regularDifference,
          ),

          // Kayıt sayısı bilgisi
          const SizedBox(height: OmaSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: OmaSpacing.md,
              vertical: OmaSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(OmaRadius.sm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: theme.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: OmaSpacing.sm),
                Expanded(
                  child: Text(
                    insights.totalCyclesRecorded > 1
                        ? AppStrings.records(
                            insights.totalCyclesRecorded,
                            insights.cycleLengths.length,
                          )
                        : AppStrings.cycleStatisticsHint,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.muted.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tek satır istatistik ─────────────────────────────────
  Widget _buildInsightRow({
    required OmaTheme theme,
    required String label,
    required String value,
    required CycleStatus status,
    required String statusLabel,
    required String infoText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: OmaSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol taraf: etiket ve değer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: OmaTypeScale.caption,
                    color: theme.muted.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: OmaSpacing.xs),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.foreground,
                  ),
                ),
              ],
            ),
          ),
          // Sağ taraf: durum göstergesi + info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Info ikonu
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.info_outline,
                  size: 18,
                  color: theme.muted.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 6),
              // Durum badge'i
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _statusIcon(status, theme),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: OmaTypeScale.caption,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(status, theme),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ── Durum ikonu ──────────────────────────────────────────
  Widget _statusIcon(CycleStatus status, OmaTheme theme) {
    switch (status) {
      case CycleStatus.normal:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: theme.success,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 14, color: theme.onPrimary),
        );
      case CycleStatus.abnormal:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: theme.warning,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning_rounded, size: 14, color: theme.onPrimary),
        );
      case CycleStatus.noData:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: theme.muted.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.remove, size: 14, color: theme.onPrimary),
        );
    }
  }

  Color _statusColor(CycleStatus status, OmaTheme theme) {
    switch (status) {
      case CycleStatus.normal:
        return theme.success;
      case CycleStatus.abnormal:
        return theme.warning;
      case CycleStatus.noData:
        return theme.muted;
    }
  }

  String _cycleStatusLabel(CycleStatus status) {
    switch (status) {
      case CycleStatus.normal:
        return AppStrings.normal;
      case CycleStatus.abnormal:
        return AppStrings.abnormal;
      case CycleStatus.noData:
        return AppStrings.noDataStatus;
    }
  }

  String _regularityLabel(CycleRegularity regularity) {
    switch (regularity) {
      case CycleRegularity.regular:
        return AppStrings.regular;
      case CycleRegularity.irregular:
        return AppStrings.irregular;
      case CycleRegularity.noData:
        return AppStrings.noDataStatus;
    }
  }

  CycleStatus _regularityToCycleStatus(CycleRegularity regularity) {
    switch (regularity) {
      case CycleRegularity.regular:
        return CycleStatus.normal;
      case CycleRegularity.irregular:
        return CycleStatus.abnormal;
      case CycleRegularity.noData:
        return CycleStatus.noData;
    }
  }
}
