import 'package:app_proje_a/views/dashboard/widgets/horizontal_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/app_time.dart';
import '../../../data/models/period_log_model.dart';
import '../viewmodel/dashboard_view_model.dart';
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../../calendar/view/calendar_view.dart' as cal;
import '../widgets/countdown_circle.dart';
import '../widgets/daily_log_sheet.dart';
import '../widgets/feeling_card.dart';
import '../widgets/cycle_insights_card.dart';
import '../../articles/model/article_model.dart';
import '../../articles/view/article_detail_view.dart';

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
                    const SizedBox(height: 8),
                    // ── Karşılama ──────────────────────────
                    Row(
                      children: [
                        Image.asset(
                          AppTime.now.hour < 12
                              ? 'assets/images/morning.png'
                              : AppTime.now.hour < 18
                              ? 'assets/images/afternoon.png'
                              : 'assets/images/night.png',
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            vm.cleanGreeting,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const cal.CalendarView(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/calendar.png',
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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
                            child: const Text(
                              'Bugün',
                              style: TextStyle(
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
        decoration: const BoxDecoration(color: Colors.transparent),
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
              phase: null,
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
      decoration: const BoxDecoration(color: Colors.transparent),
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
            phase: pc.currentPhase,
          ),
          const SizedBox(height: 12),
          Text(
            '${pc.currentPhaseDaysRemaining} gün sonra ${pc.nextPhaseName}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: phaseColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Takvim ve ovülasyon bilgileri yaklaşık tahminlerdir.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  // ── Size Özel Tavsiye Kartı ─────────────────────────────
  Widget _buildRecommendationCard(BuildContext context) {
    // ID'si 6 olan PMS makalesini veya varsayılan olarak ilk makaleyi bulalım
    final article = DummyArticles.articles.firstWhere(
      (a) => a.id == '6',
      orElse: () => DummyArticles.articles.first,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailView(article: article),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF9CAB84),
              const Color(0xFF9CAB84).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9CAB84).withValues(alpha: 0.25),
              blurRadius: 15,
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
                color: Colors.white.withValues(alpha: 0.12),
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
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'GÜNÜN TAVSİYESİ',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
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
                          color: Colors.white70,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article.readTime,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      'Okumaya Başla',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Colors.white,
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
        ? '📋 Bugünün Kayıtları'
        : '📋 ${vm.selectedDate.toDotFormat()} Tarihli Kayıtlar';

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
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Kayıt Ekle',
                      style: TextStyle(
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
                const Text(
                  'Bu tarih için henüz bir kayıt girilmemiş.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  label: const Text(
                    'Kayıt Ekle',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                              'Ruh Hali',
                              '${log.moodEmoji ?? ''} ${log.mood}',
                            ),
                          if (log.moodNote != null && log.moodNote!.isNotEmpty)
                            _summaryTile('Ruh Hali Notu', log.moodNote!),
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
                            _summaryTile(
                              'Ağrılar',
                              log.painLocations.join(', '),
                            ),
                          if (log.flowIntensity != null)
                            _summaryTile('Akış', log.flowIntensity!),
                          if (log.periodPainLevel != null)
                            _summaryTile(
                              'Regl Ağrısı',
                              '${log.periodPainLevel}/5',
                            ),
                          if (log.medications.any((m) => m.taken))
                            _summaryTile(
                              'İlaçlar',
                              log.medications
                                  .where((m) => m.taken)
                                  .map((m) => '${m.name} (${m.dosage})')
                                  .join(', '),
                            ),
                          if (log.supplements.any((s) => s.taken))
                            _summaryTile(
                              'Takviyeler',
                              log.supplements
                                  .where((s) => s.taken)
                                  .map((s) => '${s.name} (${s.dosage})')
                                  .join(', '),
                            ),
                          if (log.sexualActivity != null)
                            _summaryTile(
                              'Cinsel Aktivite',
                              log.sexualActivity! ? 'Evet' : 'Hayır',
                            ),
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
