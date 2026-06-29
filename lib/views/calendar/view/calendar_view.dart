import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/date_extensions.dart';
import '../viewmodel/calendar_view_model.dart';

/// Takvim ekranı — aylık görünüm, renkli günler, günlük kayıt detayı.
class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Column(
              children: [
                // Başlık
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Text(
                        '📅 Takvim',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Takvim
                Container(
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
                    locale: 'tr_TR',
                    firstDay: DateTime(2024, 1, 1),
                    lastDay: DateTime(2030, 12, 31),
                    focusedDay: vm.focusedDay,
                    selectedDayPredicate: (day) =>
                        day.isSameDay(vm.selectedDay),
                    onDaySelected: (selected, focused) {
                      vm.selectDay(selected);
                      vm.setFocusedDay(focused);
                    },
                    onPageChanged: vm.setFocusedDay,

                    // Stil
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
                      defaultTextStyle: const TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),

                    // Gün altı marker'lar
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        return _buildMarkers(day, vm);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Seçili gün detayları
                Expanded(
                  child: _buildDayDetail(vm),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Gün Marker'ları ─────────────────────────────────────
  Widget? _buildMarkers(DateTime day, CalendarViewModel vm) {
    final markers = <Widget>[];

    // Kayıt var mı?
    if (vm.hasLogForDay(day)) {
      markers.add(_dot(AppColors.primary));
    }

    // Regl günü
    if (vm.isPeriodDay(day)) {
      markers.add(_dot(AppColors.periodPrimary));
    }

    // Ovülasyon günü
    if (vm.isOvulationDay(day)) {
      markers.add(_dot(AppColors.ovulation));
    }

    // Verimli gün
    if (vm.isFertileDay(day) && !vm.isOvulationDay(day)) {
      markers.add(_dot(AppColors.fertile));
    }

    if (markers.isEmpty) return null;

    return Positioned(
      bottom: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: markers,
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // ── Seçili Gün Detayı ───────────────────────────────────
  Widget _buildDayDetail(CalendarViewModel vm) {
    final logs = vm.selectedDayLogs.where((l) => l.hasData).toList();

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
                vm.selectedDay.toTurkishLong(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (vm.isPeriodDay(vm.selectedDay))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.periodPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🩸 Adet',
                    style: TextStyle(
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
                    const Text(
                      'Bu gün için kayıt yok',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
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
                          _detailRow('Ruh Hali', '${log.moodEmoji ?? ''} ${log.mood}'),
                        if (log.activities.isNotEmpty)
                          _detailRow('Hareket', log.activities.join(', ')),
                        if (log.nutritionTags.isNotEmpty)
                          _detailRow('Beslenme', log.nutritionTags.join(', ')),
                        if (log.medications.isNotEmpty)
                          _detailRow(
                            'İlaçlar',
                            log.medications
                                .map((m) => '${m.name} ${m.taken ? "✅" : "❌"}')
                                .join(', '),
                          ),
                        if (log.supplements.isNotEmpty)
                          _detailRow(
                            'Takviyeler',
                            log.supplements
                                .map((s) => '${s.name} ${s.taken ? "✅" : "❌"}')
                                .join(', '),
                          ),
                        if (log.bowelActivity.isNotEmpty)
                          _detailRow('Bağırsak', log.bowelActivity.join(', ')),
                        if (log.painLocations.isNotEmpty)
                          _detailRow('Ağrılar', log.painLocations.join(', ')),
                        if (log.flowIntensity != null)
                          _detailRow('Akış', log.flowIntensity!),
                        if (log.notes != null && log.notes!.isNotEmpty)
                          _detailRow('Notlar', log.notes!),
                        if (index != logs.length - 1)
                          Divider(color: AppColors.textHint.withValues(alpha: 0.2)),
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
