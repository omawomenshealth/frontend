import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/period_calculator.dart';

/// The seven-day card used by the home design.
///
/// Weeks can still be swiped in both directions and every day remains
/// selectable, so the visual adaptation does not remove the existing logging
/// workflow.
class HorizontalCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final PeriodCalculator? periodCalculator;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.periodCalculator,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  static const _centerPage = 5200;
  late final PageController _pageController;
  late DateTime _anchorMonday;

  @override
  void initState() {
    super.initState();
    _anchorMonday = _mondayOf(widget.selectedDate);
    _pageController = PageController(initialPage: _centerPage);
  }

  @override
  void didUpdateWidget(covariant HorizontalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate.isSameDay(widget.selectedDate)) return;

    final visibleMonday = _mondayForPage(
      _pageController.hasClients
          ? (_pageController.page?.round() ?? _centerPage)
          : _centerPage,
    );
    final selectedMonday = _mondayOf(widget.selectedDate);
    if (!visibleMonday.isSameDay(selectedMonday)) {
      _anchorMonday = selectedMonday;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_centerPage);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _mondayOf(DateTime date) {
    final normalized = date.dateOnly;
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  DateTime _mondayForPage(int page) {
    return _anchorMonday.add(Duration(days: (page - _centerPage) * 7));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3C2C24).withValues(alpha: 0.07),
            blurRadius: 26,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, page) {
            final monday = _mondayForPage(page);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              child: Row(
                children: [
                  for (var index = 0; index < 7; index++)
                    Expanded(
                      child: _DayButton(
                        date: monday.add(Duration(days: index)),
                        selectedDate: widget.selectedDate,
                        periodCalculator: widget.periodCalculator,
                        onTap: widget.onDateSelected,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DayButton extends StatelessWidget {
  final DateTime date;
  final DateTime selectedDate;
  final PeriodCalculator? periodCalculator;
  final ValueChanged<DateTime> onTap;

  const _DayButton({
    required this.date,
    required this.selectedDate,
    required this.periodCalculator,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = date.isSameDay(selectedDate);
    final today = date.isSameDay(AppTime.now);
    final phase = periodCalculator?.phaseAt(date);
    final phaseColor = _phaseColor(phase);
    final isPredictedPeriod =
        periodCalculator != null && periodCalculator!.isInPeriod(date);

    return Semantics(
      selected: selected,
      button: true,
      label: '${AppStrings.shortWeekdays[date.weekday - 1]} ${date.day}',
      child: InkResponse(
        onTap: () => onTap(date),
        radius: 26,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.shortWeekdays[date.weekday - 1].toUpperCase(),
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.05,
              ),
            ),
            const SizedBox(height: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? phaseColor : Colors.transparent,
                shape: BoxShape.circle,
                border: today && !selected
                    ? Border.all(
                        color: phaseColor.withValues(alpha: 0.45),
                        width: 1.2,
                      )
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : isPredictedPeriod
                      ? AppColors.periodPrimary
                      : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _phaseColor(CyclePhase? phase) {
    return switch (phase) {
      CyclePhase.menstrual => AppColors.periodPrimary,
      CyclePhase.follicular => AppColors.primary,
      CyclePhase.ovulation => AppColors.ovulation,
      CyclePhase.luteal => AppColors.lutealDark,
      null => AppColors.primary,
    };
  }
}
