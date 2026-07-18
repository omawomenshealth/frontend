import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/utils/app_time.dart';

/// Yatay kaydırılabilir günlük takvim şeridi.
/// Sol başta küçük bir takvim ikonu, ardından yatay scroll ile günler gösterilir.
/// Adet ve ovülasyon günleri renkli göstergelerle işaretlenir.
class HorizontalCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final PeriodCalculator? periodCalculator;
  final VoidCallback? onCalendarTap;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.periodCalculator,
    this.onCalendarTap,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late final ScrollController _scrollController;
  static const int _totalDays = 365; // ±6 ay
  static const int _centerIndex = 182; // bugünün indeksi

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _scrollToSelected() {
    final today = AppTime.now.dateOnly;
    final diff = widget.selectedDate.dateOnly.difference(today).inDays;
    final targetIndex = _centerIndex + diff;
    // Her item ~64px genişlikte
    const itemWidth = 64.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final offset =
        (targetIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void didUpdateWidget(HorizontalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selectedDate.isSameDay(widget.selectedDate)) {
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Belirli bir tarih için döngü durumunu döndürür.
  _CycleStatus _getCycleStatus(DateTime date) {
    final pc = widget.periodCalculator;
    if (pc == null) return _CycleStatus.none;

    if (pc.isInPeriod(date)) return _CycleStatus.period;
    if (pc.isInEstimatedOvulationWindow(date)) {
      return _CycleStatus.ovulation;
    }
    if (pc.isInFertileWindow(date)) return _CycleStatus.fertile;
    return _CycleStatus.none;
  }

  @override
  Widget build(BuildContext context) {
    final today = AppTime.now.dateOnly;

    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _totalDays,
        itemBuilder: (context, index) {
          final date = today.add(Duration(days: index - _centerIndex));
          final isSelected = date.isSameDay(widget.selectedDate);
          final isToday = date.isSameDay(today);
          final cycleStatus = _getCycleStatus(date);

          return RepaintBoundary(
            child: GestureDetector(
              onTap: () => widget.onDateSelected(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: 56,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: isSelected
                      ? null
                      : isToday
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: isToday && !isSelected
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _shortWeekday(date.weekday),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : isToday
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // ── Döngü göstergesi (nokta) ──────
                    _buildCycleIndicator(cycleStatus, isSelected),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Döngü durumuna göre küçük renkli nokta göstergesi
  Widget _buildCycleIndicator(_CycleStatus status, bool isSelected) {
    if (status == _CycleStatus.none) {
      return const SizedBox(height: 6);
    }

    Color dotColor;
    double dotSize;

    switch (status) {
      case _CycleStatus.period:
        dotColor = isSelected ? Colors.white : AppColors.periodPrimary;
        dotSize = 6;
        break;
      case _CycleStatus.ovulation:
        dotColor = isSelected ? Colors.white : AppColors.ovulation;
        dotSize = 6;
        break;
      case _CycleStatus.fertile:
        dotColor = isSelected
            ? Colors.white.withValues(alpha: 0.7)
            : AppColors.fertile;
        dotSize = 5;
        break;
      case _CycleStatus.none:
        return const SizedBox(height: 6);
    }

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: dotColor.withValues(alpha: 0.4),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  /// Kısa gün adı (Türkçe)
  String _shortWeekday(int weekday) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return days[weekday - 1];
  }
}

/// Döngü durumu enum
enum _CycleStatus { none, period, ovulation, fertile }
