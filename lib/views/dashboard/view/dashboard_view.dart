import 'package:app_proje_a/views/dashboard/widgets/horizontal_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/oma_design_widgets.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/daily_log_formatters.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/services/api_service.dart';
import '../viewmodel/dashboard_view_model.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../../calendar/view/calendar_view.dart' as cal;
import '../widgets/countdown_circle.dart';
import '../widgets/daily_log_sheet.dart';
import '../widgets/feeling_card.dart';
import '../widgets/cycle_insights_card.dart';
import '../../articles/model/article_model.dart';
import '../../articles/view/article_detail_view.dart';
import '../../insights/view/insights_view.dart';

/// Dashboard ana ekranı.
class DashboardView extends StatelessWidget {
  final VoidCallback? onOpenInsights;

  const DashboardView({super.key, this.onOpenInsights});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 112),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // ── Karşılama ──────────────────────────
                    _buildHomeHeader(context, vm),
                    const SizedBox(height: 18),

                    // ── Yatay Takvim ──
                    HorizontalCalendar(
                      selectedDate: vm.selectedDate,
                      onDateSelected: vm.selectDate,
                      periodCalculator: vm.periodCalculator,
                    ),
                    if (!vm.selectedDate.isSameDay(AppTime.now)) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => vm.selectDate(AppTime.now),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              AppStrings.today,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

                    // ── Hızlı Erişim (4 yuvarlak) ────────
                    FeelingCard(
                      showPeriod: vm.hasPeriodTracking,
                      onPeriodTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 0,
                        isSingleTab: true,
                      ),
                      onNutritionTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: vm.hasPeriodTracking ? 1 : 0,
                        isSingleTab: true,
                      ),
                      onMedicationTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: vm.hasPeriodTracking ? 2 : 1,
                        isSingleTab: true,
                      ),
                      onMoodTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: vm.hasPeriodTracking ? 3 : 2,
                        isSingleTab: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (vm.personalInsights.isNotEmpty) ...[
                      _buildPersonalInsightsPreview(vm),
                      const SizedBox(height: 16),
                    ],

                    // ── Size Özel Tavsiye / Makale Kartı ──
                    _buildRecommendationCard(context),
                    const SizedBox(height: 16),

                    // ── Döngülerim İstatistik Kartı ───────
                    if (vm.hasPeriodTracking && vm.cycleInsights != null) ...[
                      CycleInsightsCard(insights: vm.cycleInsights!),
                      const SizedBox(height: 16),
                    ],

                    // ── Günlük Kayıtlar (Timeline) ──────────
                    _buildTimeline(context, vm),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeHeader(BuildContext context, DashboardViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 7,
            runSpacing: 3,
            children: [
              Text(
                vm.todayDateStr.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                vm.cleanGreeting,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: AppStrings.calendar,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const cal.CalendarView()),
            );
          },
          style: IconButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.outline),
          ),
          icon: const Icon(Icons.calendar_month_outlined, size: 19),
        ),
      ],
    );
  }

  Widget _buildPersonalInsightsPreview(DashboardViewModel vm) {
    return Column(
      key: const ValueKey('dashboard_personal_insights'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OmaSectionHeader(
          title: AppStrings.personalInsightsPreviewTitle,
          eyebrow: AppStrings.insights,
          action: onOpenInsights == null
              ? null
              : TextButton(
                  key: const ValueKey('dashboard_view_all_insights'),
                  onPressed: onOpenInsights,
                  child: Text(AppStrings.viewAllInsights),
                ),
        ),
        const SizedBox(height: 14),
        for (var index = 0; index < vm.personalInsights.length; index++) ...[
          PersonalInsightCard(insight: vm.personalInsights[index]),
          if (index != vm.personalInsights.length - 1)
            const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ── Regl Kartı ──────────────────────────────────────────
  Widget _buildPeriodCard(DashboardViewModel vm) {
    final pc = vm.periodCalculator;
    final phaseColor = pc == null
        ? AppColors.periodPrimary
        : [
            AppColors.periodPrimary,
            AppColors.fertile,
            AppColors.ovulation,
            AppColors.luteal,
          ][pc.currentPhaseIndex];

    return Column(
      children: [
        Text(
          AppStrings.cycleTracking.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.8,
          ),
        ),
        const SizedBox(height: 6),
        CountdownCircle(
          daysRemaining: pc?.daysUntilNextPeriod,
          totalDays: pc?.cycleLength,
          phaseDayCounts: pc?.phaseDayCounts,
          phaseName: pc?.currentPhaseName ?? AppStrings.missingInformation,
          phaseColor: phaseColor,
          phase: pc?.currentPhase,
        ),
        if (pc != null)
          Text(
            AppStrings.phaseAfterDays(
              pc.currentPhaseDaysRemaining,
              pc.nextPhaseName,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: phaseColor,
            ),
          ),
      ],
    );
  }

  // ── Size Özel Tavsiye Kartı ─────────────────────────────
  Widget _buildRecommendationCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final json = await context.read<ApiService>().fetchArticle(
            'adet-doneminde-beslenme',
          );
          if (!context.mounted) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ArticleDetailView(article: Article.fromJson(json)),
            ),
          );
        } on ApiException catch (error) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.message)));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFF2F0E7), const Color(0xFFE4ECD8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF74835A).withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 90,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: AppColors.primary,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.recommendationOfTheDay,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: AppColors.textSecondary,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.dayCount(5),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  AppStrings.recommendationTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.recommendationSummary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      AppStrings.startReading,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primaryDark,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Günlük Kayıtlar (Timeline) ─────────────────────────
  Widget _buildTimeline(BuildContext context, DashboardViewModel vm) {
    final isToday = vm.selectedDate.isToday;
    final title = isToday
        ? AppStrings.todaysLogs
        : AppStrings.datedLogs(vm.selectedDate.toDotFormat());

    final hasLogs = vm.todayLogs.any((log) => log.hasData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            // "+ Ekle" Butonu
            GestureDetector(
              onTap: () => _showDailyLogSheet(context, vm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.addDailyLog,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasLogs)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: 40,
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.noLogForDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showDailyLogSheet(context, vm),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(
                    AppStrings.addDailyLog,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
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
                              AppStrings.mood,
                              '${log.moodEmoji ?? ''} ${AppStrings.localizeStoredValue(log.mood!)}',
                            ),
                          if (log.moodNote != null && log.moodNote!.isNotEmpty)
                            _summaryTile(AppStrings.moodNote, log.moodNote!),
                          if (log.sleepDurationMinutes != null)
                            _summaryTile(
                              AppStrings.sleepDuration,
                              AppStrings.hoursMinutes(
                                log.sleepDurationMinutes!,
                              ),
                            ),
                          if (log.sleepQuality != null)
                            _summaryTile(
                              AppStrings.sleepQuality,
                              AppStrings.levelOutOfFive(log.sleepQuality!),
                            ),
                          if (log.stressLevel != null)
                            _summaryTile(
                              AppStrings.stressLevel,
                              AppStrings.levelOutOfFive(log.stressLevel!),
                            ),
                          if (log.energyLevel != null)
                            _summaryTile(
                              AppStrings.energyLevel,
                              AppStrings.levelOutOfFive(log.energyLevel!),
                            ),
                          if (log.activities.isNotEmpty)
                            _summaryTile(
                              AppStrings.activity,
                              log.activities
                                  .map(AppStrings.localizeStoredValue)
                                  .join(', '),
                            ),
                          if (log.nutritionTags.isNotEmpty)
                            _summaryTile(
                              AppStrings.nutrition,
                              log.nutritionTags
                                  .map(AppStrings.localizeStoredValue)
                                  .join(', '),
                            ),
                          if (log.waterIntakeMl != null)
                            _summaryTile(
                              AppStrings.waterIntake,
                              AppStrings.milliliters(log.waterIntakeMl!),
                            ),
                          if (log.caffeineServings != null)
                            _summaryTile(
                              AppStrings.caffeineIntake,
                              AppStrings.servingCount(log.caffeineServings!),
                            ),
                          if (log.bowelActivity.isNotEmpty)
                            _summaryTile(
                              AppStrings.bowel,
                              log.bowelActivity
                                  .map(AppStrings.localizeStoredValue)
                                  .join(', '),
                            ),
                          if (log.painLocations.isNotEmpty)
                            _summaryTile(
                              AppStrings.pain,
                              log.painLocations
                                  .map(AppStrings.localizeStoredValue)
                                  .join(', '),
                            ),
                          if (log.flowIntensity != null)
                            _summaryTile(
                              AppStrings.flow,
                              AppStrings.localizeStoredValue(
                                log.flowIntensity!,
                              ),
                            ),
                          if (log.periodPainLevel != null)
                            _summaryTile(
                              AppStrings.periodPain,
                              '${log.periodPainLevel}/5',
                            ),
                          if (log.vaginalDischargePresent != null)
                            _summaryTile(
                              AppStrings.vaginalDischarge,
                              DailyLogFormatters.vaginalDischarge(log),
                            ),
                          if (log.medications.any((m) => m.taken))
                            _summaryTile(
                              AppStrings.medications,
                              log.medications
                                  .where((m) => m.taken)
                                  .map((m) => '${m.name} (${m.dosage})')
                                  .join(', '),
                            ),
                          if (log.supplements.any((s) => s.taken))
                            _summaryTile(
                              AppStrings.supplements,
                              log.supplements
                                  .where((s) => s.taken)
                                  .map((s) => '${s.name} (${s.dosage})')
                                  .join(', '),
                            ),
                          if (log.sexualActivity != null)
                            _summaryTile(
                              AppStrings.sexualActivity,
                              log.sexualActivity!
                                  ? AppStrings.yes
                                  : AppStrings.no,
                            ),
                          if (log.notes != null && log.notes!.isNotEmpty)
                            _summaryTile(AppStrings.notes, log.notes!),
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
  void _showDailyLogSheet(
    BuildContext context,
    DashboardViewModel vm, {
    int initialIndex = 0,
    bool isSingleTab = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyLogSheet(
        initialLog: DailyLog.empty(
          vm.selectedDate.isToday ? AppTime.now : vm.selectedDate,
        ), // Her seferinde yeni bir kayıt açılır (bugün ise güncel saatle)
        settings: vm.settings!,
        initialTabIndex: initialIndex,
        isSingleTab: isSingleTab,
        onSave: (log) async {
          // Adet verisi varsa döngü istatistiklerini yeniden hesapla
          final success = log.flowIntensity != null
              ? await vm.recordPeriodAndRecalculate(log)
              : await vm.saveLog(log);
          if (success && context.mounted) {
            await context.read<CalendarViewModel>().loadData();
          }
          return success;
        },
      ),
    );
  }
}
