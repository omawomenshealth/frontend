import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/date_extensions.dart';
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
                // Başlık — sabit, hiç rebuild olmaz
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
            locale: 'tr_TR',
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
              markerBuilder: (context, day, events) {
                return _buildMarkers(day, vm);
              },
            ),
          ),
        );
      },
    );
  }

  // ── Gün Marker'ları ─────────────────────────────────────
  Widget? _buildMarkers(DateTime day, CalendarViewModel vm) {
    // Bu fonksiyonlar artık saniyenin binde biri hızında çalışıyor (O(1))
    final hasLog = vm.hasLogForDay(day);
    final isPeriod = vm.isPeriodDay(day);
    final isOvulation = vm.isOvulationDay(day);
    final isFertile = vm.isFertileDay(
      day,
    ); // Not: ViewModel içinde ovülasyon elendiği için direkt çağırıyoruz

    if (!hasLog && !isPeriod && !isOvulation && !isFertile) return null;

    return Positioned(
      bottom:
          4, // Noktaların gün sayısının altına düzgün oturması için hafif artırıldı
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasLog) _dot(AppColors.primary),
          if (isPeriod) _dot(AppColors.periodPrimary),
          if (isOvulation) _dot(AppColors.ovulation),
          if (isFertile) _dot(AppColors.fertile),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Seçili Gün Detayı — kendi Selector scope'u ile
// ══════════════════════════════════════════════════════════════
class _DayDetailSection extends StatelessWidget {
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
                              _detailRow(
                                'Ruh Hali',
                                '${log.moodEmoji ?? ''} ${log.mood}',
                              ),
                            if (log.activities.isNotEmpty)
                              _detailRow('Hareket', log.activities.join(', ')),
                            if (log.nutritionTags.isNotEmpty)
                              _detailRow(
                                'Beslenme',
                                log.nutritionTags.join(', '),
                              ),
                            if (log.medications.isNotEmpty)
                              _detailRow(
                                'İlaçlar',
                                log.medications
                                    .map(
                                      (m) => '${m.name} ${m.taken ? "✅" : "❌"}',
                                    )
                                    .join(', '),
                              ),
                            if (log.supplements.isNotEmpty)
                              _detailRow(
                                'Takviyeler',
                                log.supplements
                                    .map(
                                      (s) => '${s.name} ${s.taken ? "✅" : "❌"}',
                                    )
                                    .join(', '),
                              ),
                            if (log.bowelActivity.isNotEmpty)
                              _detailRow(
                                'Bağırsak',
                                log.bowelActivity.join(', '),
                              ),
                            if (log.painLocations.isNotEmpty)
                              _detailRow(
                                'Ağrılar',
                                log.painLocations.join(', '),
                              ),
                            if (log.flowIntensity != null)
                              _detailRow('Akış', log.flowIntensity!),
                            if (log.notes != null && log.notes!.isNotEmpty)
                              _detailRow('Notlar', log.notes!),
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
