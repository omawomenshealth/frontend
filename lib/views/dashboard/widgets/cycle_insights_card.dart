import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/local_storage_service.dart';

/// Döngülerim istatistik kartı — rakip uygulamadaki gibi
/// önceki döngü süresi, regl süresi ve döngü değişkenliğini gösterir.
/// Tüm veriler gerçek kayıtlardan hesaplanır.
class CycleInsightsCard extends StatelessWidget {
  final CycleInsights insights;

  const CycleInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFEF8), Color(0xFFF0F2E7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Text(
                AppStrings.myCycles,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Önceki döngü süresi
          _buildInsightRow(
            label: AppStrings.previousCycleLength,
            value: insights.previousCycleLength != null
                ? AppStrings.dayCount(insights.previousCycleLength!)
                : AppStrings.noDataStatus,
            status: insights.cycleStatus,
            statusLabel: _cycleStatusLabel(insights.cycleStatus),
            infoText: AppStrings.normalCycleRange,
          ),

          _divider(),

          // 2. Önceki regl süresi
          _buildInsightRow(
            label: AppStrings.previousPeriodLength,
            value: AppStrings.dayCount(insights.previousPeriodLength),
            status: insights.periodStatus,
            statusLabel: _cycleStatusLabel(insights.periodStatus),
            infoText: AppStrings.normalPeriodRange,
          ),

          _divider(),

          // 3. Döngü süresi değişkenliği
          _buildInsightRow(
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
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
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
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
    required String label,
    required String value,
    required CycleStatus status,
    required String statusLabel,
    required String infoText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
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
                  color: AppColors.textHint.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 6),
              // Durum badge'i
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _statusIcon(status),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(status),
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

  Widget _divider() {
    return Divider(
      color: AppColors.textHint.withValues(alpha: 0.15),
      height: 1,
    );
  }

  // ── Durum ikonu ──────────────────────────────────────────
  Widget _statusIcon(CycleStatus status) {
    switch (status) {
      case CycleStatus.normal:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      case CycleStatus.abnormal:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFFF9800),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_rounded,
            size: 14,
            color: Colors.white,
          ),
        );
      case CycleStatus.noData:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.textHint.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.remove, size: 14, color: Colors.white),
        );
    }
  }

  Color _statusColor(CycleStatus status) {
    switch (status) {
      case CycleStatus.normal:
        return const Color(0xFF4CAF50);
      case CycleStatus.abnormal:
        return const Color(0xFFFF9800);
      case CycleStatus.noData:
        return AppColors.textHint;
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
