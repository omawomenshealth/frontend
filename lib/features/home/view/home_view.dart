import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/widgets/oma_toast.dart';
import '../../../core/widgets/oma_theme.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../domain/cycle/models/cycle_prediction.dart';
import '../../../localization/generated/strings.g.dart';
import '../../../views/calendar/view/calendar_view.dart' as cal;
import '../../../views/calendar/viewmodel/calendar_view_model.dart';
import '../../../views/insights/view/insights_view.dart';
import '../../../views/profile/viewmodel/profile_view_model.dart';
import '../viewmodel/home_view_model.dart';
import '../../../views/dashboard/widgets/daily_log_sheet.dart';
import '../../../views/dashboard/widgets/medication_reminder_section.dart';
import 'widgets/index.dart';

/// Oma's daily home screen, adapted from the exported mobile design while
/// retaining the existing Flutter data and logging flows.
class HomeView extends StatelessWidget {
  final VoidCallback? onOpenInsights;

  const HomeView({super.key, this.onOpenInsights});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Scaffold(
            backgroundColor: OmaColors.scaffoldBackground,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final calculator = vm.periodCalculator;
        final phase =
            calculator?.phaseAt(vm.selectedDate) ?? CyclePhase.follicular;
        final trackingMode = vm.settings?.trackingMode ?? TrackingMode.cycle;
        final accent = trackingMode == TrackingMode.pregnant
            ? OmaColors.plum
            : OmaColors.forCyclePhase(phase);
        final cycleDay = _cycleDay(calculator, vm.selectedDate);
        final periodCount = phase == CyclePhase.menstrual
            ? cycleDay
            : _daysToPeriod(calculator, vm.selectedDate, cycleDay);

        return Scaffold(
          backgroundColor: Color.lerp(
            OmaColors.scaffoldBackground,
            accent,
            0.035,
          ),
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: accent,
              onRefresh: vm.loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 132),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      userName: vm.settings?.userName,
                      selectedDate: vm.selectedDate,
                      accent: accent,
                      onCalendarTap: () => _openCalendar(context),
                    ),
                    const SizedBox(height: 22),
                    HorizontalCalendar(
                      selectedDate: vm.selectedDate,
                      onDateSelected: vm.selectDate,
                      periodCalculator: calculator,
                    ),
                    if (!vm.selectedDate.isSameDay(AppTime.now)) ...[
                      const SizedBox(height: 9),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => vm.selectDate(AppTime.now),
                          style: TextButton.styleFrom(
                            foregroundColor: accent,
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.today_outlined, size: 15),
                          label: Text(context.t.home.common.today),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    HomeHeroSection(
                      trackingMode: trackingMode,
                      pregnancyEstimate: vm.pregnancyEstimate,
                      positiveTestDate:
                          vm.settings?.pregnancyTestPositiveDate,
                      phase: phase,
                      cycleDay: cycleDay,
                      periodCount: periodCount,
                        forecastSummary: _forecastSummary(context, vm),
                      onOpenInsights: () => _openInsights(context),
                      onPeriodTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 0,
                        isSingleTab: true,
                      ),
                      ),
                    const SizedBox(height: 30),
                      QuickLogs(
                        accent: accent,
                      onNutritionTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 1,
                        isSingleTab: true,
                      ),
                      onSymptomTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 2,
                        isSingleTab: true,
                      ),
                      onMoodTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 3,
                        isSingleTab: true,
                      ),
                      onMedicationTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 4,
                        isSingleTab: true,
                      ),
                      onSkincareTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 5,
                        isSingleTab: true,
                      ),
                    ),
                    const SizedBox(height: 38),
                    InsightsPreview(
                      insights: vm.personalInsights,
                      accent: accent,
                      onViewAll: () => _openInsights(context),
                      onInsightTap: (insight) =>
                          _openInsight(context, insight),
                    ),
                    TodaysMedicationDosesCard(color: accent),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const cal.CalendarView()),
    );
  }

  void _openInsights(BuildContext context) {
    if (onOpenInsights != null) {
      onOpenInsights!();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InsightsView()),
    );
  }

  void _openInsight(BuildContext context, PersonalInsight insight) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InsightsView(initialInsight: insight)),
    );
  }

  int _cycleDay(PeriodCalculator? calculator, DateTime date) {
    if (calculator == null || calculator.cycleLength <= 0) return 1;
    final difference = date.dateOnly
        .difference(calculator.lastPeriodDate.dateOnly)
        .inDays;
    final normalized =
        ((difference % calculator.cycleLength) + calculator.cycleLength) %
        calculator.cycleLength;
    return normalized + 1;
  }

  int _daysToPeriod(
    PeriodCalculator? calculator,
    DateTime selectedDate,
    int cycleDay,
  ) {
    if (calculator == null || calculator.cycleLength <= 0) return 0;
    final forecastDifference = calculator.nextPeriodDate
        .difference(selectedDate.dateOnly)
        .inDays;
    if (forecastDifference >= 0) {
      return forecastDifference.clamp(0, calculator.cycleLength);
    }
    return (calculator.cycleLength - cycleDay + 1).clamp(
      0,
      calculator.cycleLength,
    );
  }

  String? _forecastSummary(
    BuildContext context,
    HomeViewModel vm,
  ) {
    final strings = context.t.home.common;
    final forecast = vm.cycleForecast;
    if (forecast == null) return null;
    final start = forecast.p80Window.start;
    final end = forecast.p80Window.end;
    final locale = Localizations.localeOf(context).toString();
    final format = DateFormat('d MMM', locale);
    final range = '${format.format(start)} – ${format.format(end)}';
    if (forecast.confidence == ForecastConfidence.low) {
      return strings.periodPredictionLowConfidenceSummary(range: range);
    }
    final confidence = switch (forecast.confidence) {
      ForecastConfidence.low => strings.forecastConfidenceLow,
      ForecastConfidence.medium => strings.forecastConfidenceMedium,
      ForecastConfidence.high => strings.forecastConfidenceHigh,
    };
    return strings.periodPredictionSummary(
      range: range,
      confidence: confidence,
    );
  }

  void _showDailyLogSheet(
    BuildContext context,
    HomeViewModel vm, {
    int initialIndex = 0,
    bool isSingleTab = false,
  }) {
    if (vm.selectedDate.dateOnly.isAfter(AppTime.now.dateOnly)) {
      OmaToast.show(
        context,
        title: context.t.home.common.error,
        description: context.t.home.common.futureLogNotAllowed,
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    final section = switch (initialIndex) {
      0 => DailyLogObservedSection.period,
      1 => DailyLogObservedSection.nutrition,
      2 => DailyLogObservedSection.symptom,
      3 => DailyLogObservedSection.wellbeing,
      4 => DailyLogObservedSection.medication,
      _ => DailyLogObservedSection.skincare,
    };
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyLogSheet(
        initialLog: vm.initialLogForSection(section),
        settings: vm.settings!,
        themeColor: OmaColors.forCyclePhase(
          vm.periodCalculator?.phaseAt(vm.selectedDate),
        ),
        initialTabIndex: initialIndex,
        isSingleTab: isSingleTab,
        onSettingsChanged: () async {
          context.read<ProfileViewModel>().loadSettings();
          await vm.loadData();
        },
        onSave: (log) async {
          final success = log.flowIntensity != null
              ? await vm.recordPeriodAndRecalculate(log)
              : await vm.saveLog(log);
          if (success && context.mounted) {
            await context.read<CalendarViewModel>().loadData();
          }
          return success;
        },
        onDeletePeriod: (date) async {
          final success = await vm.deletePeriodForDate(date);
          if (success && context.mounted) {
            await context.read<CalendarViewModel>().loadData();
          }
          return success;
        },
      ),
    );
  }
}

