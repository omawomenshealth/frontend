import 'package:app_proje_a/views/dashboard/widgets/horizontal_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/period_log_model.dart';
import '../viewmodel/dashboard_view_model.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../../calendar/view/calendar_view.dart' as cal;
import '../widgets/countdown_circle.dart';
import '../widgets/daily_log_sheet.dart';
import '../widgets/feeling_card.dart';
import '../widgets/cycle_insights_card.dart';

/// Dashboard ana ekranı.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: vm.loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Karşılama ──────────────────────────
                    Text(
                      vm.greeting,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.todayDateStr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Küçük Takvim logosu + Yatay Takvim ──
                    HorizontalCalendar(
                      selectedDate: vm.selectedDate,
                      onDateSelected: vm.selectDate,
                      periodCalculator: vm.periodCalculator,
                    ),
                    const SizedBox(height: 16),

                    // ── Regl Geri Sayım (Kadın) ───────────
                    if (vm.hasPeriodTracking) ...[
                      GestureDetector(
                        onTap: () {
                          // Takvim sayfasına git
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const cal.CalendarView(),
                            ),
                          );
                        },
                        child: _buildPeriodCard(vm),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Döngülerim İstatistik Kartı ───────
                    if (vm.hasPeriodTracking && vm.cycleInsights != null) ...[
                      CycleInsightsCard(insights: vm.cycleInsights!),
                      const SizedBox(height: 16),
                    ],

                    // ── Hızlı Erişim (4 yuvarlak) ────────
                    FeelingCard(
                      showPeriod: vm.hasPeriodTracking,
                      onPeriodTap: () => _showDailyLogSheet(context, vm, initialIndex: 0),
                      onNutritionTap: () => _showDailyLogSheet(context, vm, initialIndex: vm.hasPeriodTracking ? 1 : 0),
                      onMedicationTap: () => _showDailyLogSheet(context, vm, initialIndex: vm.hasPeriodTracking ? 2 : 1),
                      onMoodTap: () => _showDailyLogSheet(context, vm, initialIndex: vm.hasPeriodTracking ? 3 : 2),
                    ),
                    const SizedBox(height: 24),

                    // ── Bugünün Kayıtları (Timeline) ───────
                    if (vm.todayLogs.isNotEmpty) _buildTimeline(vm),
                  ],
                ),
              ),
            ),
          ),

          // ── Günlük Kayıt Ekle FAB ──────────────────────
          /*floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showDailyLogSheet(context, vm),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text(
              'Günlük Kayıt',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),*/
        );
      },
    );
  }

  /*   // ── İlerleme Kartı ──────────────────────────────────────
  Widget _buildProgressCard(DashboardViewModel vm) {
    final percent = vm.completionPercentage;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bugünün Durumu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  percent == 0
                      ? 'Henüz kayıt eklenmedi'
                      : '${(percent * 100).round()}% tamamlandı',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                // İlerleme çubuğu
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${(percent * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } */

  // ── Regl Kartı ──────────────────────────────────────────
  Widget _buildPeriodCard(DashboardViewModel vm) {
    final pc = vm.periodCalculator;

    if (pc == null) {
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
          children: [
            Row(
              children: [
                const Text(
                  '🩸 Döngü Takibi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      58,
                      0,
                      0,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Bekleniyor',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.periodPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CountdownCircle(
              daysRemaining: null,
              totalDays: null,
              phaseName: 'Bilgi Eksik',
              phaseColor: AppColors.periodPrimary,
            ),
          ],
        ),
      );
    }

    final phaseColors = [
      AppColors.periodPrimary,
      AppColors.fertile,
      AppColors.ovulation,
      AppColors.luteal,
    ];
    final phaseColor = phaseColors[pc.currentPhaseIndex];

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
        children: [
          Row(
            children: [
              const Text(
                '🩸 Döngü Takibi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pc.currentPhaseName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: phaseColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CountdownCircle(
            daysRemaining: pc.daysUntilNextPeriod,
            totalDays: pc.cycleLength,
            phaseName: pc.currentPhaseName,
            phaseColor: phaseColor,
          ),
        ],
      ),
    );
  }

  // ── Bugünün Kayıtları (Timeline) ────────────────────────
  Widget _buildTimeline(DashboardViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📋 Bugünün Kayıtları',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...vm.todayLogs.where((log) => log.hasData).map((log) {
          final timeStr =
              '${log.date.hour.toString().padLeft(2, '0')}:${log.date.minute.toString().padLeft(2, '0')}';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saat
                SizedBox(
                  width: 50,
                  child: Text(
                    timeStr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                // Çizgi ve Nokta
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 50, // İhtiyaca göre uzar (basit bir çizgi)
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // İçerik Kartı
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
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
                        if (log.mood != null)
                          _summaryTile(
                            'Ruh Hali',
                            '${log.moodEmoji ?? ''} ${log.mood}',
                          ),
                        if (log.activities.isNotEmpty)
                          _summaryTile('Hareket', log.activities.join(', ')),
                        if (log.nutritionTags.isNotEmpty)
                          _summaryTile(
                            'Beslenme',
                            log.nutritionTags.join(', '),
                          ),
                        if (log.bowelActivity.isNotEmpty)
                          _summaryTile(
                            'Bağırsak',
                            log.bowelActivity.join(', '),
                          ),
                        if (log.painLocations.isNotEmpty)
                          _summaryTile('Ağrılar', log.painLocations.join(', ')),
                        if (log.flowIntensity != null)
                          _summaryTile('Akış', log.flowIntensity!),
                        if (log.notes != null && log.notes!.isNotEmpty)
                          _summaryTile('Not', log.notes!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _summaryTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Günlük Kayıt Sheet ──────────────────────────────────
  void _showDailyLogSheet(BuildContext context, DashboardViewModel vm, {int initialIndex = 0}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyLogSheet(
        initialLog: DailyLog.empty(
          vm.selectedDate,
        ), // Her seferinde yeni bir kayıt açılır
        settings: vm.settings!,
        initialTabIndex: initialIndex,
        onSave: (log) {
          // Adet verisi varsa döngü istatistiklerini yeniden hesapla
          if (log.flowIntensity != null) {
            vm.recordPeriodAndRecalculate(log).then((_) {
              // Takvim viewmodel'ini de senkronize et
              if (context.mounted) {
                context.read<CalendarViewModel>().loadData();
              }
            });
          } else {
            vm.saveLog(log).then((_) {
              // Takvimi de güncelle (non-period data için)
              if (context.mounted) {
                context.read<CalendarViewModel>().loadData();
              }
            });
          }
        },
      ),
    );
  }
}
