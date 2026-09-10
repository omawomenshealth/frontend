import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/daily_log_formatters.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/widgets/oma_toast.dart';
import '../../../data/models/period_log_model.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';
import '../../dashboard/widgets/daily_log_sheet.dart';
import '../../profile/viewmodel/profile_view_model.dart';
import '../viewmodel/calendar_view_model.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  static const _monthTitleExtent = 50.0;
  static const _monthGridPadding = 8.0;
  static const _monthDividerExtent = 16.0;
  static const _calendarRowExtent = 45.0;
  static const _monthSectionExtent =
      _monthTitleExtent +
      _monthGridPadding +
      (6 * _calendarRowExtent) +
      _monthDividerExtent;

  late DateTime _focusedMonth;
  late DateTime _firstCalendarMonth;
  late DateTime _lastCalendarMonth;
  late List<DateTime> _calendarMonths;
  late List<double> _monthStartOffsets;
  late ScrollController _calendarController;
  bool _isQuickPeriodSelectionMode = false;
  bool _isSavingPeriodChanges = false;
  final Map<DateTime, bool> _pendingPeriodChanges = {};

  @override
  void initState() {
    super.initState();
    final vm = context.read<CalendarViewModel>();
    final today = AppTime.now.dateOnly;
    final earliestLoggedYear = vm.logMap.keys.fold<int>(
      today.year,
      (earliest, day) => math.min(earliest, day.year),
    );
    _firstCalendarMonth = DateTime(
      math.min(today.year - 5, earliestLoggedYear),
      1,
    );
    _lastCalendarMonth = DateTime(today.year + 25, 12);
    _calendarMonths = List.generate(
      _monthIndex(_lastCalendarMonth) + 1,
      _monthAt,
      growable: false,
    );
    _monthStartOffsets = _buildMonthStartOffsets();
    _focusedMonth = DateTime(today.year, today.month);
    _calendarController = ScrollController(
      initialScrollOffset: _initialCalendarOffset(today),
    )..addListener(_updateFocusedMonthFromScroll);
  }

  @override
  void dispose() {
    _calendarController
      ..removeListener(_updateFocusedMonthFromScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);

    return Selector<
      CalendarViewModel,
      ({bool isLoading, DateTime selectedDay, int dataRevision})
    >(
      selector: (_, vm) => (
        isLoading: vm.isLoading,
        selectedDay: vm.selectedDay,
        dataRevision: vm.dataRevision,
      ),
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
                          if (_isQuickPeriodSelectionMode)
                            _buildQuickPeriodSelectionHint(),
                          const _WeekdayStrip(),
                          Expanded(child: _buildContinuousCalendar()),
                        ],
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 18,
                        child: _buildCalendarActions(),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildQuickPeriodSelectionHint() {
    return Container(
      key: const ValueKey('calendar_quick_period_hint'),
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.periodLight.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.periodPrimary.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.touch_app_rounded,
            size: 18,
            color: AppColors.periodPrimary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppStrings.quickPeriodSelectHint,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.periodPrimary,
              ),
            ),
          ),
          IconButton(
            key: const ValueKey('calendar_cancel_period_changes'),
            tooltip: AppStrings.cancel,
            onPressed: _isSavingPeriodChanges
                ? null
                : _cancelQuickPeriodSelection,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.periodPrimary,
            ),
          ),
        ],
      ),
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: Text(
                  _monthAndYear(_focusedMonth),
                  key: ValueKey(_focusedMonth),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 24,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
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
                Icons.info_rounded,
                size: 25,
                color: AppColors.periodPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinuousCalendar() {
    return ListView.builder(
      key: const ValueKey('calendar-continuous-view'),
      controller: _calendarController,
      padding: const EdgeInsets.only(bottom: 112),
      itemCount: _calendarMonths.length,
      itemExtent: _monthSectionExtent,
      itemBuilder: (context, index) {
        final month = _calendarMonths[index];
        return Column(
          children: [
            SizedBox(
              height: _monthTitleExtent,
              child: Center(
                child: Text(
                  _monthAndYear(month),
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
              month: month,
              compact: true,
              onDayTap: _handleDayTap,
              quickSelectionMode: _isQuickPeriodSelectionMode,
              pendingPeriodChanges: _pendingPeriodChanges,
            ),
            const SizedBox(
              height: _monthDividerExtent,
              child: Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: AppColors.outline,
              ),
            ),
          ],
        );
      },
    );
  }

  List<double> _buildMonthStartOffsets() {
    return List.generate(
      _calendarMonths.length,
      (index) => index * _monthSectionExtent,
      growable: false,
    );
  }

  double _initialCalendarOffset(DateTime today) {
    final monthIndex = _monthIndex(DateTime(today.year, today.month));
    final firstDay = DateTime(today.year, today.month);
    final leadingCells = firstDay.weekday - DateTime.monday;
    final currentWeek = (leadingCells + today.day - 1) ~/ 7;
    return _monthStartOffsets[monthIndex] +
        _monthTitleExtent +
        (_monthGridPadding / 2) +
        (currentWeek * _calendarRowExtent);
  }

  void _updateFocusedMonthFromScroll() {
    if (!_calendarController.hasClients || _monthStartOffsets.isEmpty) return;
    final offset = _calendarController.offset;
    var low = 0;
    var high = _monthStartOffsets.length - 1;
    while (low < high) {
      final middle = (low + high + 1) ~/ 2;
      if (_monthStartOffsets[middle] <= offset) {
        low = middle;
      } else {
        high = middle - 1;
      }
    }
    final visibleMonth = _calendarMonths[low];
    if (visibleMonth == _focusedMonth || !mounted) return;
    setState(() => _focusedMonth = visibleMonth);
    context.read<CalendarViewModel>().setFocusedDay(visibleMonth);
  }

  Widget _buildCalendarActions() {
    final isEditing = _isQuickPeriodSelectionMode;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.periodPrimary.withValues(alpha: 0.34),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FilledButton.icon(
        key: const ValueKey('calendar_period_edit_button'),
        onPressed: isEditing
            ? (_pendingPeriodChanges.isNotEmpty && !_isSavingPeriodChanges
                  ? _saveQuickPeriodSelection
                  : null)
            : _startQuickPeriodSelection,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.periodPrimary,
          disabledBackgroundColor: AppColors.periodPrimary.withValues(
            alpha: 0.52,
          ),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: const StadiumBorder(),
        ),
        icon: _isSavingPeriodChanges
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                isEditing ? Icons.check_rounded : Icons.water_drop_rounded,
                size: 19,
              ),
        label: Text(
          isEditing ? AppStrings.confirm : AppStrings.editPeriodDates,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _startQuickPeriodSelection() {
    setState(() {
      _pendingPeriodChanges.clear();
      _isQuickPeriodSelectionMode = true;
    });
  }

  void _cancelQuickPeriodSelection() {
    setState(() {
      _pendingPeriodChanges.clear();
      _isQuickPeriodSelectionMode = false;
    });
  }

  Future<void> _handleDayTap(DateTime day) async {
    if (!_isQuickPeriodSelectionMode) {
      await _openDayDetails(day);
      return;
    }

    final normalized = day.dateOnly;
    if (normalized.isAfter(AppTime.now.dateOnly)) {
      OmaToast.show(
        context,
        title: AppStrings.error,
        description: AppStrings.futureLogNotAllowed,
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    final calendarVm = context.read<CalendarViewModel>();
    setState(() {
      if (_pendingPeriodChanges.containsKey(normalized)) {
        _pendingPeriodChanges.remove(normalized);
      } else {
        _pendingPeriodChanges[normalized] = !calendarVm.isLoggedPeriodDay(
          normalized,
        );
      }
    });
  }

  Future<void> _saveQuickPeriodSelection() async {
    if (_pendingPeriodChanges.isEmpty || _isSavingPeriodChanges) return;
    final changes = Map<DateTime, bool>.from(_pendingPeriodChanges);
    setState(() => _isSavingPeriodChanges = true);

    final success = await context
        .read<CalendarViewModel>()
        .applyPeriodDayChanges(changes);
    if (!mounted) return;
    if (success) await context.read<DashboardViewModel>().loadData();
    if (!mounted) return;

    setState(() {
      _isSavingPeriodChanges = false;
      if (success) {
        _pendingPeriodChanges.clear();
        _isQuickPeriodSelectionMode = false;
      }
    });
    if (!success) {
      OmaToast.show(
        context,
        title: AppStrings.error,
        description: AppStrings.quickPeriodSaveFailed,
        icon: Icons.error_outline_rounded,
      );
    }
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

  int _monthIndex(DateTime month) =>
      (month.year - _firstCalendarMonth.year) * 12 +
      month.month -
      _firstCalendarMonth.month;

  DateTime _monthAt(int index) =>
      DateTime(_firstCalendarMonth.year, _firstCalendarMonth.month + index);

  static String _monthName(DateTime month) {
    final value = DateFormat.MMMM(AppStrings.localeName).format(month);
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static String _monthAndYear(DateTime month) {
    return '${_monthName(month)} ${month.year}';
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
  final bool quickSelectionMode;
  final Map<DateTime, bool> pendingPeriodChanges;

  const _MonthGrid({
    required this.month,
    required this.onDayTap,
    this.compact = false,
    this.quickSelectionMode = false,
    this.pendingPeriodChanges = const {},
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month);
    final leadingCells = firstDay.weekday - DateTime.monday;
    final dayCount = DateTime(month.year, month.month + 1, 0).day;
    final populatedCells = leadingCells + dayCount;
    final cellCount = compact ? 42 : ((populatedCells + 6) ~/ 7) * 7;

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
            quickSelectionMode: quickSelectionMode,
            pendingPeriodState: pendingPeriodChanges[day.dateOnly],
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
  final bool quickSelectionMode;
  final bool? pendingPeriodState;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.day,
    required this.compact,
    required this.quickSelectionMode,
    required this.pendingPeriodState,
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
    final willBeRecorded = pendingPeriodState ?? isRecordedPeriod;
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

    if (pendingPeriodState == true && !isRecordedPeriod) {
      dayCircle = Stack(
        key: ValueKey('period_pending_add_${day.toStorageKey()}'),
        clipBehavior: Clip.none,
        children: [
          _circle(
            size: circleSize,
            color: AppColors.periodPrimary,
            textColor: Colors.white,
          ),
          const Positioned(
            right: -2,
            top: -2,
            child: CircleAvatar(
              radius: 6.5,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add_rounded,
                size: 11,
                color: AppColors.periodPrimary,
              ),
            ),
          ),
        ],
      );
    } else if (pendingPeriodState == false && isRecordedPeriod) {
      dayCircle = Stack(
        key: ValueKey('period_pending_remove_${day.toStorageKey()}'),
        clipBehavior: Clip.none,
        children: [
          Opacity(opacity: 0.32, child: dayCircle),
          const Positioned(
            right: -2,
            top: -2,
            child: CircleAvatar(
              radius: 6.5,
              backgroundColor: AppColors.periodPrimary,
              child: Icon(Icons.remove_rounded, size: 11, color: Colors.white),
            ),
          ),
        ],
      );
    } else if (quickSelectionMode && isRecordedPeriod) {
      dayCircle = Stack(
        key: ValueKey('period_edit_recorded_${day.toStorageKey()}'),
        clipBehavior: Clip.none,
        children: [
          dayCircle,
          const Positioned(
            right: -2,
            top: -2,
            child: CircleAvatar(
              radius: 6.5,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.remove_rounded,
                size: 11,
                color: AppColors.periodPrimary,
              ),
            ),
          ),
        ],
      );
    } else if (!quickSelectionMode && isSelected && !isToday) {
      dayCircle = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.periodPrimary, width: 1.4),
        ),
        child: dayCircle,
      );
    }

    return Semantics(
      key: ValueKey('calendar_day_${day.toStorageKey()}'),
      button: true,
      selected: quickSelectionMode ? willBeRecorded : isSelected,
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
            if (isToday && !isRecordedPeriod && pendingPeriodState != true)
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
            if (isToday || hasLog) ...[
              const SizedBox(height: 2),
              Container(
                key: ValueKey('calendar_log_marker_${day.toStorageKey()}'),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: willBeRecorded
                      ? AppColors.periodPrimary
                      : AppColors.textSecondary,
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
              label: AppStrings.periodStartPredictionWindow,
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
    OmaToast.show(
      context,
      title: AppStrings.error,
      description: AppStrings.futureLogNotAllowed,
      icon: Icons.error_outline_rounded,
    );
    return;
  }
  final dashboardVm = context.read<DashboardViewModel>();
  final settings = calendarVm.settings ?? dashboardVm.settings;
  if (settings == null) {
    OmaToast.show(
      context,
      title: AppStrings.error,
      description: AppStrings.missingInformation,
      icon: Icons.error_outline_rounded,
    );
    return;
  }

  final section = switch (initialIndex) {
    0 => DailyLogObservedSection.period,
    1 => DailyLogObservedSection.nutrition,
    2 => DailyLogObservedSection.symptom,
    3 => DailyLogObservedSection.wellbeing,
    _ => DailyLogObservedSection.skincare,
  };
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DailyLogSheet(
      initialLog: dashboardVm.initialLogForSection(section, date: date),
      settings: settings,
      themeColor: initialIndex == 0
          ? AppColors.periodPrimary
          : AppColors.forCyclePhase(
              dashboardVm.periodCalculator?.phaseAt(date),
            ),
      initialTabIndex: initialIndex == 4 ? 5 : initialIndex,
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
    OmaToast.show(
      context,
      title: AppStrings.error,
      description: AppStrings.futureLogNotAllowed,
      icon: Icons.error_outline_rounded,
    );
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
    (
      label: AppStrings.skincare,
      icon: Icons.spa_outlined,
      color: AppColors.secondaryDark,
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
      value.dreamRemembered == null &&
              value.dreamType == null &&
              (value.dreamNote?.isEmpty ?? true)
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
      AppStrings.medications,
      value.medications.isEmpty
          ? null
          : value.medications
                .map(
                  (item) =>
                      '${AppStrings.localizeStoredValue(item.displayName)} · '
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
                      '${AppStrings.localizeStoredValue(item.displayName)} · '
                      '${AppStrings.localizeStoredValue(item.time)} · '
                      '${AppStrings.localizeStoredValue(item.dosage)} · '
                      '${AppStrings.localizeStoredValue(item.stomachState)} · '
                      '${item.takenDoseCount}/${item.doseCount}',
                )
                .join(', '),
    );
    add(
      AppStrings.skincare,
      value.skincare.isEmpty
          ? null
          : value.skincare.map(AppStrings.localizeStoredValue).join(', '),
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
