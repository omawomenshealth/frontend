import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/daily_log_formatters.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/period_log_model.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';
import '../../dashboard/widgets/daily_log_sheet.dart';
import '../../profile/viewmodel/profile_view_model.dart';
import '../viewmodel/calendar_view_model.dart';

final _firstCalendarMonth = DateTime(2024, 1);
final _lastCalendarMonth = DateTime(2030, 12);

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedMonth;
  late PageController _monthController;
  bool _isYearView = false;

  @override
  void initState() {
    super.initState();
    final focused = context.read<CalendarViewModel>().focusedDay;
    _focusedMonth = _clampMonth(DateTime(focused.year, focused.month));
    _monthController = PageController(initialPage: _monthIndex(_focusedMonth));
  }

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);

    return Selector<
      CalendarViewModel,
      ({bool isLoading, DateTime selectedDay})
    >(
      selector: (_, vm) =>
          (isLoading: vm.isLoading, selectedDay: vm.selectedDay),
      builder: (context, calendarState, _) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: calendarState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Column(
                        children: [
                          _buildHeader(),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: _isYearView
                                  ? _buildYearView()
                                  : _buildMonthPager(),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 18,
                        child: Center(child: _buildEditPeriodButton()),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: IconButton(
              tooltip: AppStrings.close,
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.close_rounded,
                size: 27,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8E0),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CalendarModeButton(
                      label: AppStrings.month,
                      selected: !_isYearView,
                      onTap: () => setState(() => _isYearView = false),
                    ),
                    _CalendarModeButton(
                      label: AppStrings.year,
                      selected: _isYearView,
                      onTap: () => setState(() => _isYearView = true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: IconButton(
              tooltip: AppStrings.calendarLegend,
              onPressed: _showCalendarLegend,
              icon: const Icon(
                Icons.settings_outlined,
                size: 25,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPager() {
    final monthCount = _monthIndex(_lastCalendarMonth) + 1;
    return PageView.builder(
      key: const ValueKey('calendar-month-view'),
      controller: _monthController,
      itemCount: monthCount,
      onPageChanged: (index) {
        final month = _monthAt(index);
        setState(() => _focusedMonth = month);
        context.read<CalendarViewModel>().setFocusedDay(month);
      },
      itemBuilder: (context, index) {
        final month = _monthAt(index);
        final nextMonth = DateTime(month.year, month.month + 1);
        final canShowNext = !nextMonth.isAfter(_lastCalendarMonth);

        return ListView(
          padding: const EdgeInsets.only(bottom: 112),
          children: [
            const _WeekdayStrip(),
            _MonthGrid(month: month, onDayTap: _openDayDetails),
            if (canShowNext) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: AppColors.outline),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  _monthName(nextMonth),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 27,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _MonthGrid(month: nextMonth, onDayTap: _openDayDetails),
            ],
          ],
        );
      },
    );
  }

  Widget _buildYearView() {
    return ListView(
      key: const ValueKey('calendar-year-view'),
      padding: const EdgeInsets.only(bottom: 112),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Text(
            '${_focusedMonth.year}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const _WeekdayStrip(),
        for (var month = 1; month <= 12; month++) ...[
          InkWell(
            onTap: () =>
                _selectMonthFromYear(DateTime(_focusedMonth.year, month)),
            child: Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 4),
              child: Text(
                _monthName(DateTime(_focusedMonth.year, month)),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          _MonthGrid(
            month: DateTime(_focusedMonth.year, month),
            compact: true,
            onDayTap: _openDayDetails,
          ),
          if (month != 12)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Divider(height: 1, color: AppColors.outline),
            ),
        ],
      ],
    );
  }

  Widget _buildEditPeriodButton() {
    final selectedDay = context.read<CalendarViewModel>().selectedDay;
    final canLog = !selectedDay.dateOnly.isAfter(AppTime.now.dateOnly);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.34),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: canLog
            ? () async {
                final vm = context.read<CalendarViewModel>();
                await _showDailyLogEditor(context, vm.selectedDay, vm);
              }
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 15),
          shape: const StadiumBorder(),
        ),
        child: Text(
          AppStrings.editPeriodDates,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 20,
            height: 1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _openDayDetails(DateTime day) async {
    final vm = context.read<CalendarViewModel>();
    vm.selectDay(day);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.78,
        child: _DayDetailSection(),
      ),
    );
  }

  Future<void> _showCalendarLegend() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CalendarLegendSheet(),
    );
  }

  void _selectMonthFromYear(DateTime month) {
    final clamped = _clampMonth(month);
    setState(() {
      _focusedMonth = clamped;
      _isYearView = false;
    });
    _monthController.jumpToPage(_monthIndex(clamped));
    context.read<CalendarViewModel>().setFocusedDay(clamped);
  }

  static DateTime _clampMonth(DateTime month) {
    if (month.isBefore(_firstCalendarMonth)) return _firstCalendarMonth;
    if (month.isAfter(_lastCalendarMonth)) return _lastCalendarMonth;
    return month;
  }

  static int _monthIndex(DateTime month) =>
      (month.year - _firstCalendarMonth.year) * 12 +
      month.month -
      _firstCalendarMonth.month;

  static DateTime _monthAt(int index) =>
      DateTime(_firstCalendarMonth.year, _firstCalendarMonth.month + index);

  static String _monthName(DateTime month) {
    final value = DateFormat.MMMM(AppStrings.localeName).format(month);
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _CalendarModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CalendarModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      elevation: selected ? 1 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayStrip extends StatelessWidget {
  const _WeekdayStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.outline),
        ),
      ),
      child: Row(
        children: [
          for (final label in AppStrings.calendarWeekdayInitials)
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final ValueChanged<DateTime> onDayTap;
  final bool compact;

  const _MonthGrid({
    required this.month,
    required this.onDayTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month);
    final leadingCells = firstDay.weekday - DateTime.monday;
    final dayCount = DateTime(month.year, month.month + 1, 0).day;
    final populatedCells = leadingCells + dayCount;
    final cellCount = ((populatedCells + 6) ~/ 7) * 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cellCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: compact ? 45 : 56,
        ),
        itemBuilder: (context, index) {
          final dayNumber = index - leadingCells + 1;
          if (dayNumber < 1 || dayNumber > dayCount) {
            return const SizedBox.shrink();
          }

          final day = DateTime(month.year, month.month, dayNumber);
          return _CalendarDayCell(
            day: day,
            compact: compact,
            onTap: () => onDayTap(day),
          );
        },
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final bool compact;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.day,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CalendarViewModel>();
    final today = AppTime.now.dateOnly;
    final isToday = day.dateOnly == today;
    final isSelected = day.dateOnly == vm.selectedDay.dateOnly;
    final isRecordedPeriod = vm.isLoggedPeriodDay(day);
    final isPredictedPeriod = vm.isPredictedPeriodDay(day);
    final isPredictionWindow = vm.isPeriodPredictionWindowDay(day);
    final isOvulation = vm.isEstimatedOvulationDay(day);
    final isFertile = vm.isFertileDay(day);
    final hasLog = vm.hasLogForDay(day);
    final circleSize = compact ? 32.0 : 40.0;

    Widget dayCircle;
    if (isRecordedPeriod) {
      dayCircle = _circle(
        size: circleSize,
        color: AppColors.periodPrimary,
        textColor: Colors.white,
      );
    } else if (isPredictedPeriod) {
      dayCircle = CustomPaint(
        painter: const _DashedCirclePainter(AppColors.periodPrimary),
        child: _circle(size: circleSize, textColor: AppColors.periodPrimary),
      );
    } else if (isPredictionWindow) {
      dayCircle = _circle(
        size: circleSize,
        color: AppColors.periodLight.withValues(alpha: 0.64),
        textColor: AppColors.periodPrimary,
      );
    } else if (isOvulation) {
      dayCircle = _circle(
        size: circleSize,
        color: AppColors.secondaryLight,
        textColor: AppColors.secondaryDark,
      );
    } else if (isFertile) {
      dayCircle = _circle(
        size: circleSize,
        color: AppColors.primaryLight,
        textColor: AppColors.primaryDark,
      );
    } else {
      dayCircle = _circle(size: circleSize);
    }

    if (isSelected && !isToday) {
      dayCircle = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1.4),
        ),
        child: dayCircle,
      );
    }

    return Semantics(
      button: true,
      selected: isSelected,
      label: DateFormat.yMMMMd(AppStrings.localeName).format(day),
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isToday && !compact)
              Text(
                AppStrings.today.toUpperCase(),
                style: const TextStyle(
                  fontSize: 8,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
            if (isToday && !compact) const SizedBox(height: 1),
            if (isToday)
              Text(
                '${day.day}',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: compact ? 20 : 26,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.periodPrimary,
                ),
              )
            else
              dayCircle,
            if ((isToday || hasLog) && !compact) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _circle({
    required double size,
    Color? color,
    Color textColor = AppColors.textPrimary,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: compact ? 13 : 15,
              fontWeight: color == null ? FontWeight.w500 : FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  const _DashedCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    const dashCount = 12;
    final sweep = (math.pi * 2 / dashCount) * 0.58;

    for (var index = 0; index < dashCount; index++) {
      final start = index * math.pi * 2 / dashCount;
      canvas.drawArc(
        rect.deflate(paint.strokeWidth / 2),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _CalendarLegendSheet extends StatelessWidget {
  const _CalendarLegendSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _SheetHandle()),
            const SizedBox(height: 20),
            Text(
              AppStrings.calendarLegend,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            _LegendRow(
              color: AppColors.periodPrimary,
              label: AppStrings.recordedPeriod,
            ),
            _LegendRow(
              color: AppColors.periodPrimary,
              label: AppStrings.predictedPeriod,
              dashed: true,
            ),
            _LegendRow(
              color: AppColors.periodLight,
              label: AppStrings.isTurkish
                  ? 'Regl başlangıcı tahmin aralığı'
                  : 'Period start prediction window',
            ),
            _LegendRow(
              color: AppColors.secondary,
              label: AppStrings.estimatedOvulationWindow,
            ),
            _LegendRow(color: AppColors.primary, label: AppStrings.fertileDays),
            const SizedBox(height: 8),
            Text(
              AppStrings.phasePredictionDisclaimer,
              style: const TextStyle(
                fontSize: 12,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _LegendRow({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    final marker = dashed
        ? CustomPaint(
            painter: _DashedCirclePainter(color),
            child: const SizedBox(width: 22, height: 22),
          )
        : Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          marker,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

Future<void> _showDailyLogEditor(
  BuildContext context,
  DateTime date,
  CalendarViewModel calendarVm, {
  int initialIndex = 0,
}) async {
  if (date.dateOnly.isAfter(AppTime.now.dateOnly)) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.futureLogNotAllowed)));
    return;
  }
  final dashboardVm = context.read<DashboardViewModel>();
  final settings = calendarVm.settings ?? dashboardVm.settings;
  if (settings == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.missingInformation)));
    return;
  }

  final section = switch (initialIndex) {
    0 => DailyLogObservedSection.period,
    1 => DailyLogObservedSection.nutrition,
    2 => DailyLogObservedSection.symptom,
    _ => DailyLogObservedSection.wellbeing,
  };
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DailyLogSheet(
      initialLog: dashboardVm.initialLogForSection(section, date: date),
      settings: settings,
      themeColor: AppColors.forCyclePhase(
        dashboardVm.periodCalculator?.phaseAt(date),
      ),
      initialTabIndex: initialIndex,
      isSingleTab: true,
      onSettingsChanged: () async {
        context.read<ProfileViewModel>().loadSettings();
        await dashboardVm.loadData();
        await calendarVm.loadData();
      },
      onSave: (log) async {
        final success = log.flowIntensity != null
            ? await dashboardVm.recordPeriodAndRecalculate(log)
            : await dashboardVm.saveLog(log);
        if (success) await calendarVm.loadData();
        return success;
      },
      onDeletePeriod: (date) async {
        final success = await dashboardVm.deletePeriodForDate(date);
        if (success) await calendarVm.loadData();
        return success;
      },
    ),
  );
}

Future<void> _showDailyLogTypePicker(
  BuildContext context,
  DateTime date,
  CalendarViewModel calendarVm,
) async {
  if (date.dateOnly.isAfter(AppTime.now.dateOnly)) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.futureLogNotAllowed)));
    return;
  }
  final options = [
    (
      label: AppStrings.period,
      icon: Icons.water_drop_outlined,
      color: AppColors.periodPrimary,
    ),
    (
      label: AppStrings.nutrition,
      icon: Icons.restaurant_outlined,
      color: AppColors.secondaryDark,
    ),
    (
      label: AppStrings.symptom,
      icon: Icons.healing_outlined,
      color: AppColors.periodFlow,
    ),
    (
      label: AppStrings.mood,
      icon: Icons.mood_outlined,
      color: AppColors.primaryDark,
    ),
  ];
  final selected = await showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
              child: Text(
                AppStrings.addDailyLog,
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            for (var index = 0; index < options.length; index++)
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: CircleAvatar(
                  backgroundColor: options[index].color.withValues(alpha: 0.12),
                  foregroundColor: options[index].color,
                  child: Icon(options[index].icon),
                ),
                title: Text(options[index].label),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(sheetContext, index),
              ),
          ],
        ),
      ),
    ),
  );
  if (selected == null || !context.mounted) return;
  await _showDailyLogEditor(context, date, calendarVm, initialIndex: selected);
}

class _DayDetailSection extends StatelessWidget {
  const _DayDetailSection();

  @override
  Widget build(BuildContext context) {
    return Selector<CalendarViewModel, DateTime>(
      selector: (_, vm) => vm.selectedDay,
      builder: (context, selectedDay, _) {
        final vm = context.read<CalendarViewModel>();
        final logs = vm.selectedDayLogs.where((log) => log.hasData).toList();
        final isPeriod = vm.isPeriodDay(selectedDay);
        final canLog = !selectedDay.dateOnly.isAfter(AppTime.now.dateOnly);

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _SheetHandle()),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      DateFormat.yMMMMEEEEd(
                        AppStrings.localeName,
                      ).format(selectedDay),
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 23,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isPeriod) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.periodLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            size: 14,
                            color: AppColors.periodPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.period,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.periodPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: canLog
                      ? () => _showDailyLogTypePicker(context, selectedDay, vm)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(AppStrings.addDailyLog),
                ),
              ),
              const SizedBox(height: 14),
              if (logs.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          size: 46,
                          color: AppColors.textHint.withValues(alpha: 0.55),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.noLogsForDay,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: AppColors.outline, height: 24),
                    itemBuilder: (context, index) =>
                        _DailyLogDetails(log: logs[index]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DailyLogDetails extends StatelessWidget {
  final DailyLog log;

  const _DailyLogDetails({required this.log});

  @override
  Widget build(BuildContext context) {
    final details = _detailsFor(log);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          log.hasExplicitTime
              ? DateFormat.Hm(AppStrings.localeName).format(log.date)
              : AppStrings.timeNotAdded,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 10),
        for (final detail in details)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    detail.key,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    detail.value,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<MapEntry<String, String>> _detailsFor(DailyLog value) {
    final result = <MapEntry<String, String>>[];
    void add(String label, String? text) {
      if (text != null && text.isNotEmpty) result.add(MapEntry(label, text));
    }

    add(
      AppStrings.mood,
      value.mood == null
          ? null
          : '${value.moodEmoji ?? ''} ${AppStrings.localizeStoredValue(value.mood!)}'
                .trim(),
    );
    add(
      AppStrings.moodWhoWith,
      value.moodCompanions.isEmpty
          ? null
          : value.moodCompanions.map(AppStrings.localizeStoredValue).join(', '),
    );
    add(
      AppStrings.moodWhere,
      value.moodPlaces.isEmpty
          ? null
          : value.moodPlaces.map(AppStrings.localizeStoredValue).join(', '),
    );
    add(
      AppStrings.dreamQuestion,
      value.dreamRemembered == null && (value.dreamNote?.isEmpty ?? true)
          ? null
          : DailyLogFormatters.dream(value),
    );
    add(
      AppStrings.mealsToday,
      value.mealTypes.isEmpty
          ? null
          : value.mealTypes.map(AppStrings.localizeStoredValue).join(', '),
    );
    add(
      AppStrings.mealsFeel,
      value.mealQualities.isEmpty
          ? null
          : DailyLogFormatters.mealQualities(value),
    );
    add(
      AppStrings.whatDidYouEat,
      value.mealFoodGroups.isEmpty
          ? null
          : DailyLogFormatters.mealFoodGroups(value),
    );
    add(
      AppStrings.howFeltAfterEating,
      value.mealPostFeelings.isEmpty
          ? null
          : DailyLogFormatters.mealPostFeelings(value),
    );
    add(
      AppStrings.cravingsQuestion,
      value.cravings.isEmpty
          ? null
          : value.cravings.map(AppStrings.localizeStoredValue).join(', '),
    );
    add(
      AppStrings.waterIntake,
      value.waterIntakeMl == null
          ? null
          : AppStrings.milliliters(value.waterIntakeMl!),
    );
    add(
      AppStrings.caffeineIntake,
      value.caffeineServings == null
          ? null
          : AppStrings.servingCount(value.caffeineServings!),
    );
    add(
      AppStrings.medications,
      value.medications.isEmpty
          ? null
          : value.medications
                .map(
                  (item) =>
                      '${item.name} · '
                      '${AppStrings.localizeStoredValue(item.time)} · '
                      '${AppStrings.localizeStoredValue(item.dosage)} · '
                      '${AppStrings.localizeStoredValue(item.stomachState)} · '
                      '${item.takenDoseCount}/${item.doseCount}',
                )
                .join(', '),
    );
    add(
      AppStrings.supplements,
      value.supplements.isEmpty
          ? null
          : value.supplements
                .map(
                  (item) =>
                      '${item.name} · '
                      '${AppStrings.localizeStoredValue(item.time)} · '
                      '${AppStrings.localizeStoredValue(item.dosage)} · '
                      '${AppStrings.localizeStoredValue(item.stomachState)} · '
                      '${item.takenDoseCount}/${item.doseCount}',
                )
                .join(', '),
    );
    add(
      AppStrings.symptom,
      value.symptoms.isEmpty
          ? null
          : value.symptoms
                .map((symptom) {
                  final localized = AppStrings.localizeStoredValue(symptom);
                  final severity =
                      value.symptomSeverities[symptom] ??
                      value.symptomSeverities[localized];
                  if (severity == null) return localized;
                  return '$localized '
                      '(${AppStrings.symptomSeverityOptions[severity - 1]})';
                })
                .join(', '),
    );
    add(
      AppStrings.flow,
      value.flowIntensity == null
          ? null
          : AppStrings.localizeStoredValue(value.flowIntensity!),
    );
    add(
      AppStrings.vaginalDischarge,
      value.vaginalDischargePresent == null
          ? null
          : DailyLogFormatters.vaginalDischarge(value),
    );
    add(
      AppStrings.sexualActivity,
      value.sexualActivity == null && value.sexualActivityTypes.isEmpty
          ? null
          : DailyLogFormatters.sexualActivity(value),
    );
    return result;
  }
}
