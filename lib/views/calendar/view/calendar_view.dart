import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/daily_log_formatters.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/widgets/oma_toast.dart';
import '../../../core/widgets/oma_circle_avatar.dart';
import '../../../core/widgets/oma_divider.dart';
import '../../../core/widgets/list_tile/oma_list_tile.dart';
import '../../../data/models/period_log_model.dart';
import '../../../features/home/viewmodel/home_view_model.dart';
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
          backgroundColor: context.omaTheme.background,
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
      margin: const EdgeInsets.fromLTRB(18, OmaSpacing.none, 18, OmaSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: OmaPalette.periodLight.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(OmaRadius.lg),
        border: Border.all(
          color: OmaPalette.periodPrimary.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.touch_app_rounded,
            size: 18,
            color: OmaPalette.periodPrimary,
          ),
          const SizedBox(width: OmaSpacing.sm),
          Expanded(
            child: Text(
              AppStrings.quickPeriodSelectHint,
              style: TextStyle(
                fontSize: OmaTypeScale.caption,
                fontWeight: FontWeight.w700,
                color: OmaPalette.periodPrimary,
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
              color: OmaPalette.periodPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OmaSpacing.md,
        OmaSpacing.sm,
        OmaSpacing.md,
        OmaSpacing.md,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: IconButton(
              tooltip: AppStrings.close,
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.close_rounded,
                size: 27,
                color: context.omaTheme.foreground,
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
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: OmaTypeScale.heading,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: context.omaTheme.foreground,
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
                color: OmaPalette.periodPrimary,
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
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: context.omaTheme.foreground,
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
            SizedBox(
              height: _monthDividerExtent,
              child: const OmaDivider(height: 1, indent: 20, endIndent: 20),
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
        boxShadow: OmaShadows.elevated(OmaPalette.periodPrimary),
      ),
      child: FilledButton.icon(
        key: const ValueKey('calendar_period_edit_button'),
        onPressed: isEditing
            ? (_pendingPeriodChanges.isNotEmpty && !_isSavingPeriodChanges
                  ? _saveQuickPeriodSelection
                  : null)
            : _startQuickPeriodSelection,
        style: FilledButton.styleFrom(
          backgroundColor: OmaPalette.periodPrimary,
          disabledBackgroundColor: OmaPalette.periodPrimary.withValues(
            alpha: 0.52,
          ),
          foregroundColor: context.omaTheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: const StadiumBorder(),
        ),
        icon: _isSavingPeriodChanges
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: OmaPalette.onMedia,
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
          style: TextStyle(fontWeight: FontWeight.w700),
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
    if (success) await context.read<HomeViewModel>().loadData();
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
      padding: const EdgeInsets.symmetric(
        horizontal: OmaSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: context.omaTheme.border),
        ),
      ),
      child: Row(
        children: [
          for (final label in AppStrings.calendarWeekdayInitials)
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: context.omaTheme.muted,
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
      padding: const EdgeInsets.symmetric(
        horizontal: OmaSpacing.md,
        vertical: OmaSpacing.xs,
      ),
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
        context,
        size: circleSize,
        color: OmaPalette.periodPrimary,
        textColor: OmaPalette.onMedia,
      );
    } else if (isPredictedPeriod) {
      dayCircle = CustomPaint(
        painter: const _DashedCirclePainter(OmaPalette.periodPrimary),
        child: _circle(
          context,
          size: circleSize,
          textColor: OmaPalette.periodPrimary,
        ),
      );
    } else if (isPredictionWindow) {
      dayCircle = _circle(
        context,
        size: circleSize,
        color: OmaPalette.periodLight.withValues(alpha: 0.64),
        textColor: OmaPalette.periodPrimary,
      );
    } else if (isOvulation) {
      dayCircle = _circle(
        context,
        size: circleSize,
        color: OmaPalette.ovulationLight,
        textColor: OmaPalette.ovulationDark,
      );
    } else if (isFertile) {
      dayCircle = _circle(
        context,
        size: circleSize,
        color: context.omaTheme.primarySoft,
        textColor: context.omaTheme.primaryStrong,
      );
    } else {
      dayCircle = _circle(context, size: circleSize);
    }

    if (pendingPeriodState == true && !isRecordedPeriod) {
      dayCircle = Stack(
        key: ValueKey('period_pending_add_${day.toStorageKey()}'),
        clipBehavior: Clip.none,
        children: [
          _circle(
            context,
            size: circleSize,
            color: OmaPalette.periodPrimary,
            textColor: OmaPalette.onMedia,
          ),
          const Positioned(
            right: -2,
            top: -2,
            child: OmaCircleAvatar(
              radius: 6.5,
              backgroundColor: OmaPalette.onMedia,
              child: Icon(
                Icons.add_rounded,
                size: 11,
                color: OmaPalette.periodPrimary,
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
            child: OmaCircleAvatar(
              radius: 6.5,
              backgroundColor: OmaPalette.periodPrimary,
              child: Icon(
                Icons.remove_rounded,
                size: 11,
                color: OmaPalette.onMedia,
              ),
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
            child: OmaCircleAvatar(
              radius: 6.5,
              backgroundColor: OmaPalette.onMedia,
              child: Icon(
                Icons.remove_rounded,
                size: 11,
                color: OmaPalette.periodPrimary,
              ),
            ),
          ),
        ],
      );
    } else if (!quickSelectionMode && isSelected && !isToday) {
      dayCircle = Container(
        padding: const EdgeInsets.all(OmaSpacing.xxs),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: OmaPalette.periodPrimary, width: 1.4),
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
                style: TextStyle(
                  fontSize: 8,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: context.omaTheme.foreground,
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
                  color: OmaPalette.periodPrimary,
                ),
              )
            else
              dayCircle,
            if (isToday || hasLog) ...[
              const SizedBox(height: OmaSpacing.xxs),
              Container(
                key: ValueKey('calendar_log_marker_${day.toStorageKey()}'),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: willBeRecorded
                      ? OmaPalette.periodPrimary
                      : context.omaTheme.muted,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _circle(
    BuildContext context, {
    required double size,
    Color? color,
    Color? textColor,
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
              color: textColor ?? context.omaTheme.foreground,
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
        padding: const EdgeInsets.fromLTRB(
          OmaSpacing.xxl,
          OmaSpacing.md,
          OmaSpacing.xxl,
          28,
        ),
        decoration: BoxDecoration(
          color: context.omaTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _SheetHandle()),
            const SizedBox(height: OmaSpacing.xl),
            Text(
              AppStrings.calendarLegend,
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: context.omaTheme.foreground,
              ),
            ),
            const SizedBox(height: 18),
            _LegendRow(
              color: OmaPalette.periodPrimary,
              label: AppStrings.recordedPeriod,
            ),
            _LegendRow(
              color: OmaPalette.periodPrimary,
              label: AppStrings.predictedPeriod,
              dashed: true,
            ),
            _LegendRow(
              color: OmaPalette.periodLight,
              label: AppStrings.periodStartPredictionWindow,
            ),
            _LegendRow(
              color: OmaPalette.ovulation,
              label: AppStrings.estimatedOvulationWindow,
            ),
            _LegendRow(
              color: context.omaTheme.primary,
              label: AppStrings.fertileDays,
            ),
            const SizedBox(height: OmaSpacing.sm),
            Text(
              AppStrings.phasePredictionDisclaimer,
              style: TextStyle(
                fontSize: OmaTypeScale.caption,
                height: 1.45,
                color: context.omaTheme.muted,
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
          const SizedBox(width: OmaSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: OmaTypeScale.body,
                fontWeight: FontWeight.w600,
                color: context.omaTheme.foreground,
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
        color: context.omaTheme.border,
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
  final homeVm = context.read<HomeViewModel>();
  final settings = calendarVm.settings ?? homeVm.settings;
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
      initialLog: homeVm.initialLogForSection(section, date: date),
      settings: settings,
      themeColor: initialIndex == 0
          ? OmaPalette.periodPrimary
          : OmaCycleSchemes.forPhase(
              homeVm.periodCalculator?.phaseAt(date) ?? CyclePhase.follicular,
            ).primary,
      initialTabIndex: initialIndex == 4 ? 5 : initialIndex,
      isSingleTab: true,
      onSettingsChanged: () async {
        context.read<ProfileViewModel>().loadSettings();
        await homeVm.loadData();
        await calendarVm.loadData();
      },
      onSave: (log) async {
        final success = log.flowIntensity != null
            ? await homeVm.recordPeriodAndRecalculate(log)
            : await homeVm.saveLog(log);
        if (success) await calendarVm.loadData();
        return success;
      },
      onDeletePeriod: (date) async {
        final success = await homeVm.deletePeriodForDate(date);
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
      color: OmaPalette.periodPrimary,
    ),
    (
      label: AppStrings.nutrition,
      icon: Icons.restaurant_outlined,
      color: OmaPalette.ovulationDark,
    ),
    (
      label: AppStrings.symptom,
      icon: Icons.healing_outlined,
      color: OmaPalette.periodFlow,
    ),
    (
      label: AppStrings.mood,
      icon: Icons.mood_outlined,
      color: context.omaTheme.primaryStrong,
    ),
    (
      label: AppStrings.skincare,
      icon: Icons.spa_outlined,
      color: OmaPalette.ovulationDark,
    ),
  ];
  final selected = await showModalBottomSheet<int>(
    context: context,
    backgroundColor: context.omaTheme.surface,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, OmaSpacing.xs, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                OmaSpacing.sm,
                OmaSpacing.xs,
                OmaSpacing.sm,
                10,
              ),
              child: Text(
                AppStrings.addDailyLog,
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: OmaTypeScale.heading,
                  fontWeight: FontWeight.w700,
                  color: context.omaTheme.foreground,
                ),
              ),
            ),
            for (var index = 0; index < options.length; index++)
              OmaListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(OmaRadius.lg),
                ),
                leading: OmaCircleAvatar(
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
          padding: const EdgeInsets.fromLTRB(
            OmaSpacing.xl,
            OmaSpacing.md,
            OmaSpacing.xl,
            OmaSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: context.omaTheme.surface,
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
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 23,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: context.omaTheme.foreground,
                      ),
                    ),
                  ),
                  if (isPeriod) ...[
                    const SizedBox(width: OmaSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: OmaPalette.periodLight,
                        borderRadius: BorderRadius.circular(OmaRadius.xl),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            size: 14,
                            color: OmaPalette.periodPrimary,
                          ),
                          const SizedBox(width: OmaSpacing.xs),
                          Text(
                            AppStrings.period,
                            style: TextStyle(
                              fontSize: OmaTypeScale.caption,
                              fontWeight: FontWeight.w700,
                              color: OmaPalette.periodPrimary,
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
                    backgroundColor: context.omaTheme.primary,
                    foregroundColor: context.omaTheme.onPrimary,
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
                          color: OmaPalette.textHint.withValues(alpha: 0.55),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.noLogsForDay,
                          style: TextStyle(
                            fontSize: OmaTypeScale.body,
                            color: OmaPalette.textHint,
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
                    separatorBuilder: (_, _) => const OmaDivider(height: 24),
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: context.omaTheme.primaryStrong,
          ),
        ),
        const SizedBox(height: 10),
        for (final detail in details)
          Padding(
            padding: const EdgeInsets.only(bottom: OmaSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    detail.key,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.omaTheme.muted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    detail.value,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.omaTheme.foreground,
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
