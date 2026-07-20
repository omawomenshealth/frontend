import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/daily_log_formatters.dart';
import '../../../data/models/period_log_model.dart';
import '../../dashboard/widgets/daily_log_sheet.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';
import '../viewmodel/calendar_view_model.dart';

/// Takvim ekranı — aylık görünüm, renkli günler, günlük kayıt detayı.
///
/// Optimizasyon: Consumer yerine StatefulWidget + hedefli Selector'lar
/// kullanılarak ay geçişlerinde gereksiz rebuild engellendi.
class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  // focusedDay'i local state'te tutuyoruz — ViewModel'den notifyListeners
  // tetiklemeden TableCalendar'ın kendi iç durumunu yönetebilmesi için.
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = context.read<CalendarViewModel>().focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Selector<CalendarViewModel, bool>(
      selector: (_, vm) => vm.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Column(
              children: [
                // Başlık — geri butonu ile
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      if (Navigator.of(context).canPop())
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      Text(
                        '📅 ${AppStrings.calendar}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Takvim — sadece selectedDay değiştiğinde rebuild
                _buildCalendarSection(),

                const SizedBox(height: 16),

                // Seçili gün detayları — kendi Selector'ı var
                Expanded(child: _DayDetailSection()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarSection() {
    final vm = context.read<CalendarViewModel>();

    return Selector<CalendarViewModel, DateTime>(
      selector: (_, vm) => vm.selectedDay,
      builder: (context, selectedDay, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
          child: TableCalendar(
            locale: AppStrings.localeName,
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => day.isSameDay(selectedDay),
            onDaySelected: (selected, focused) {
              vm.selectDay(selected);
              // 🚀 State senkronizasyonu: local state ve viewModel aynı anda güncellenir
              setState(() => _focusedDay = focused.dateOnly);
              vm.setFocusedDay(focused);
            },
            onPageChanged: (focused) {
              setState(() => _focusedDay = focused.dateOnly);
              vm.setFocusedDay(focused);
            },

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: AppColors.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: AppColors.primary,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              weekendStyle: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              defaultTextStyle: const TextStyle(color: AppColors.textPrimary),
            ),

            // 🚀 Her gün çizilirken burası tetiklenir (Artık kasmayacak)
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  context,
                  day,
                  vm,
                  isSelected: false,
                  isToday: false,
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  context,
                  day,
                  vm,
                  isSelected: false,
                  isToday: true,
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  context,
                  day,
                  vm,
                  isSelected: true,
                  isToday: false,
                );
              },
              markerBuilder: (context, day, events) {
                return _buildMarkers(day, vm);
              },
            ),
          ),
        );
      },
    );
  }

  // ── Gün Hücresi Oluşturma (Büyük, hafif transparan daireler) ──
  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    CalendarViewModel vm, {
    required bool isSelected,
    required bool isToday,
  }) {
    final isPeriod = vm.isPeriodDay(day);
    final isOvulation = vm.isEstimatedOvulationDay(day);
    final isFertile = vm.isFertileDay(day);

    Color? backgroundColor;
    TextStyle textStyle = const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14,
    );

    if (isPeriod) {
      backgroundColor = AppColors.periodPrimary.withValues(alpha: 0.15);
      if (!isSelected && !isToday) {
        textStyle = const TextStyle(
          color: AppColors.periodPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
      }
    } else if (isOvulation) {
      backgroundColor = AppColors.ovulation.withValues(alpha: 0.15);
      if (!isSelected && !isToday) {
        textStyle = const TextStyle(
          color: AppColors.ovulation,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
      }
    } else if (isFertile) {
      backgroundColor = AppColors.fertile.withValues(alpha: 0.15);
      if (!isSelected && !isToday) {
        textStyle = const TextStyle(
          color: AppColors.fertile,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
      }
    }

    Widget dayNumText = Text(
      '${day.day}',
      style: isSelected
          ? const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            )
          : isToday
          ? const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            )
          : textStyle,
    );

    Widget cellBody;

    if (isSelected) {
      cellBody = Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: dayNumText,
      );
    } else {
      final decorationColor =
          backgroundColor ??
          (isToday ? AppColors.primary.withValues(alpha: 0.15) : null);
      final border = isToday
          ? Border.all(color: AppColors.primary, width: 1.5)
          : null;

      cellBody = Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: decorationColor,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.center,
        child: dayNumText,
      );
    }

    return Center(child: cellBody);
  }

  // ── Gün Marker'ları ─────────────────────────────────────
  Widget? _buildMarkers(DateTime day, CalendarViewModel vm) {
    final hasLog = vm.hasLogForDay(day);
    if (!hasLog) return null;

    return Positioned(
      bottom: 5,
      child: Container(
        width: 5,
        height: 5,
        decoration: const BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Seçili Gün Detayı — kendi Selector scope'u ile
// ══════════════════════════════════════════════════════════════
class _DayDetailSection extends StatelessWidget {
  void _showDailyLogSheet(
    BuildContext context,
    DateTime date,
    CalendarViewModel calendarVm,
  ) {
    final dashboardVm = context.read<DashboardViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DailyLogSheet(
        initialLog: DailyLog.empty(date),
        settings: calendarVm.settings ?? dashboardVm.settings!,
        initialTabIndex: 0,
        onSave: (log) async {
          final success = log.flowIntensity != null
              ? await dashboardVm.recordPeriodAndRecalculate(log)
              : await dashboardVm.saveLog(log);
          if (success) {
            await calendarVm.loadData();
          }
          return success;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CalendarViewModel, DateTime>(
      selector: (_, vm) => vm.selectedDay,
      builder: (context, selectedDay, _) {
        final vm = context.read<CalendarViewModel>();
        final logs = vm.selectedDayLogs.where((l) => l.hasData).toList();
        final isPeriod = vm.isPeriodDay(selectedDay);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    selectedDay.toTurkishLong(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // "Kayıt Ekle" Butonu
                  GestureDetector(
                    onTap: () => _showDailyLogSheet(context, selectedDay, vm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                  const SizedBox(width: 8),
                  if (isPeriod)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.periodPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '🩸 ${AppStrings.period}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.periodPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (logs.isEmpty) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          size: 48,
                          color: AppColors.textHint.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.noLogsForDay,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _showDailyLogSheet(context, selectedDay, vm),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(
                            AppStrings.addDailyLog,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final timeStr =
                          '${log.date.hour.toString().padLeft(2, '0')}:${log.date.minute.toString().padLeft(2, '0')}';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (log.mood != null)
                              _detailRow(
                                AppStrings.mood,
                                '${log.moodEmoji ?? ''} ${AppStrings.localizeStoredValue(log.mood!)}',
                              ),
                            if (log.sleepDurationMinutes != null)
                              _detailRow(
                                AppStrings.sleepDuration,
                                AppStrings.hoursMinutes(
                                  log.sleepDurationMinutes!,
                                ),
                              ),
                            if (log.sleepQuality != null)
                              _detailRow(
                                AppStrings.sleepQuality,
                                AppStrings.levelOutOfFive(log.sleepQuality!),
                              ),
                            if (log.stressLevel != null)
                              _detailRow(
                                AppStrings.stressLevel,
                                AppStrings.levelOutOfFive(log.stressLevel!),
                              ),
                            if (log.energyLevel != null)
                              _detailRow(
                                AppStrings.energyLevel,
                                AppStrings.levelOutOfFive(log.energyLevel!),
                              ),
                            if (log.activities.isNotEmpty)
                              _detailRow(
                                AppStrings.activity,
                                log.activities
                                    .map(AppStrings.localizeStoredValue)
                                    .join(', '),
                              ),
                            if (log.nutritionTags.isNotEmpty)
                              _detailRow(
                                AppStrings.nutrition,
                                log.nutritionTags
                                    .map(AppStrings.localizeStoredValue)
                                    .join(', '),
                              ),
                            if (log.waterIntakeMl != null)
                              _detailRow(
                                AppStrings.waterIntake,
                                AppStrings.milliliters(log.waterIntakeMl!),
                              ),
                            if (log.caffeineServings != null)
                              _detailRow(
                                AppStrings.caffeineIntake,
                                AppStrings.servingCount(log.caffeineServings!),
                              ),
                            if (log.medications.isNotEmpty)
                              _detailRow(
                                AppStrings.medications,
                                log.medications
                                    .map(
                                      (m) => '${m.name} ${m.taken ? "✅" : "❌"}',
                                    )
                                    .join(', '),
                              ),
                            if (log.supplements.isNotEmpty)
                              _detailRow(
                                AppStrings.supplements,
                                log.supplements
                                    .map(
                                      (s) => '${s.name} ${s.taken ? "✅" : "❌"}',
                                    )
                                    .join(', '),
                              ),
                            if (log.bowelActivity.isNotEmpty)
                              _detailRow(
                                AppStrings.bowel,
                                log.bowelActivity
                                    .map(AppStrings.localizeStoredValue)
                                    .join(', '),
                              ),
                            if (log.painLocations.isNotEmpty)
                              _detailRow(
                                AppStrings.pain,
                                log.painLocations
                                    .map(AppStrings.localizeStoredValue)
                                    .join(', '),
                              ),
                            if (log.flowIntensity != null)
                              _detailRow(
                                AppStrings.flow,
                                AppStrings.localizeStoredValue(
                                  log.flowIntensity!,
                                ),
                              ),
                            if (log.vaginalDischargePresent != null)
                              _detailRow(
                                AppStrings.vaginalDischarge,
                                DailyLogFormatters.vaginalDischarge(log),
                              ),
                            if (log.notes != null && log.notes!.isNotEmpty)
                              _detailRow(AppStrings.notes, log.notes!),
                            if (index != logs.length - 1)
                              Divider(
                                color: AppColors.textHint.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
