import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          const Row(
            children: [
              Text(
                '📊 Döngülerim',
                style: TextStyle(
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
            label: 'Önceki döngü süresi',
            value: insights.previousCycleLength != null
                ? '${insights.previousCycleLength} gün'
                : 'Veri yok',
            status: insights.cycleStatus,
            statusLabel: _cycleStatusLabel(insights.cycleStatus),
            infoText: 'Normal aralık: 21-35 gün',
          ),

          _divider(),

          // 2. Önceki regl süresi
          _buildInsightRow(
            label: 'Önceki regl süresi',
            value: '${insights.previousPeriodLength} gün',
            status: insights.periodStatus,
            statusLabel: _cycleStatusLabel(insights.periodStatus),
            infoText: 'Normal aralık: 2-7 gün',
          ),

          _divider(),

          // 3. Döngü süresi değişkenliği
          _buildInsightRow(
            label: 'Döngü süresi değişkenliği',
            value: insights.variationMin != null && insights.variationMax != null
                ? '${insights.variationMin}-${insights.variationMax} gün'
                : 'Yeterli veri yok',
            status: _regularityToCycleStatus(insights.regularity),
            statusLabel: _regularityLabel(insights.regularity),
            infoText: '≤7 gün fark: Düzenli',
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
                        ? '${insights.totalCyclesRecorded} döngü kaydedildi · ${insights.cycleLengths.length} döngü süresi hesaplandı'
                        : 'Daha fazla veri girdikçe istatistikler daha doğru olacak',
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
          child: const Icon(Icons.warning_rounded, size: 14, color: Colors.white),
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
        return 'OLAĞAN';
      case CycleStatus.abnormal:
        return 'OLAĞAN DIŞI';
      case CycleStatus.noData:
        return 'VERİ YOK';
    }
  }

  String _regularityLabel(CycleRegularity regularity) {
    switch (regularity) {
      case CycleRegularity.regular:
        return 'DÜZENLİ';
      case CycleRegularity.irregular:
        return 'DÜZENSİZ';
      case CycleRegularity.noData:
        return 'VERİ YOK';
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
