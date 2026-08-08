import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../calendar/view/calendar_view.dart' as cal;
import '../../calendar/viewmodel/calendar_view_model.dart';
import '../../insights/view/insights_view.dart';
import '../../profile/viewmodel/profile_view_model.dart';
import '../viewmodel/dashboard_view_model.dart';
import '../widgets/daily_log_sheet.dart';
import '../widgets/feeling_card.dart';
import '../widgets/horizontal_calendar.dart';
import '../widgets/medication_reminder_section.dart';
import '../widgets/phase_hero_card.dart';

/// Oma's daily home screen, adapted from the exported mobile design while
/// retaining the existing Flutter data and logging flows.
class DashboardView extends StatelessWidget {
  final VoidCallback? onOpenInsights;

  const DashboardView({super.key, this.onOpenInsights});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final calculator = vm.periodCalculator;
        final phase =
            calculator?.phaseAt(vm.selectedDate) ?? CyclePhase.follicular;
        final accent = AppColors.forCyclePhase(phase);
        final cycleDay = _cycleDay(calculator, vm.selectedDate);
        final periodCount = phase == CyclePhase.menstrual
            ? cycleDay
            : _daysToPeriod(calculator, cycleDay);

        return Scaffold(
          backgroundColor: Color.lerp(
            AppColors.scaffoldBackground,
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
                    _HomeHeader(
                      vm: vm,
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
                          label: Text(AppStrings.today),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    PhaseHeroCard(
                      phase: phase,
                      cycleDay: cycleDay,
                      periodCount: periodCount,
                      onOpenInsights: () => _openInsights(context),
                      onPeriodTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 0,
                        isSingleTab: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _SectionTitle(
                      title: AppStrings.quickLogTitle,
                      caption: AppStrings.quickLogCaption,
                    ),
                    const SizedBox(height: 16),
                    FeelingCard(
                      showPeriod: false,
                      themeColor: accent,
                      onPeriodTap: () => _showDailyLogSheet(
                        context,
                        vm,
                        initialIndex: 0,
                        isSingleTab: true,
                      ),
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
                    if (vm.personalInsights.isNotEmpty)
                      _PersonalInsightsPreview(
                        vm: vm,
                        accent: accent,
                        onViewAll: () => _openInsights(context),
                        onInsightTap: (insight) =>
                            _openInsight(context, insight),
                      )
                    else
                      _InsightPlaceholder(accent: accent),
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

  int _daysToPeriod(PeriodCalculator? calculator, int cycleDay) {
    if (calculator == null || calculator.cycleLength <= 0) return 0;
    return (calculator.cycleLength - cycleDay + 1).clamp(
      0,
      calculator.cycleLength,
    );
  }

  void _showDailyLogSheet(
    BuildContext context,
    DashboardViewModel vm, {
    int initialIndex = 0,
    bool isSingleTab = false,
  }) {
    if (vm.selectedDate.dateOnly.isAfter(AppTime.now.dateOnly)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.futureLogNotAllowed)));
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
        themeColor: AppColors.forCyclePhase(
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

class _HomeHeader extends StatelessWidget {
  final DashboardViewModel vm;
  final Color accent;
  final VoidCallback onCalendarTap;

  const _HomeHeader({
    required this.vm,
    required this.accent,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final now = AppTime.now;
    final greeting = switch (now.hour) {
      < 12 => '${AppStrings.goodMorning},',
      < 18 => '${AppStrings.goodAfternoon},',
      _ => '${AppStrings.goodEvening},',
    };
    final storedName = vm.settings?.userName.trim() ?? '';
    final name = storedName.isEmpty
        ? AppStrings.greetingNameFallback
        : storedName;
    final month = DateFormat.MMMM(locale.toString()).format(vm.selectedDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'CormorantGaramond',
                  fontSize: 34,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  height: 1.02,
                  letterSpacing: -0.9,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${vm.selectedDate.day}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'CormorantGaramond',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                month,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 19),
        Semantics(
          button: true,
          label: AppStrings.calendar,
          child: IconButton(
            onPressed: onCalendarTap,
            style: IconButton.styleFrom(
              fixedSize: const Size(46, 46),
              foregroundColor: accent,
              backgroundColor: const Color(0xFFF4EDE5),
              side: BorderSide(color: accent.withValues(alpha: 0.34)),
            ),
            icon: const Icon(Icons.calendar_month_outlined, size: 20),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String caption;

  const _SectionTitle({required this.title, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'CormorantGaramond',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.4,
            ),
          ),
        ),
        Text(
          caption,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PersonalInsightsPreview extends StatelessWidget {
  final DashboardViewModel vm;
  final Color accent;
  final VoidCallback onViewAll;
  final ValueChanged<PersonalInsight> onInsightTap;

  const _PersonalInsightsPreview({
    required this.vm,
    required this.accent,
    required this.onViewAll,
    required this.onInsightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('dashboard_personal_insights'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.omaConnectsYourData,
          style: TextStyle(
            color: accent,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                AppStrings.myDailyInsights,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'CormorantGaramond',
                  fontSize: 29,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.7,
                ),
              ),
            ),
            TextButton(
              key: const ValueKey('dashboard_view_all_insights'),
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(AppStrings.viewAllChevron),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 224,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            itemCount: vm.personalInsights.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final insight = vm.personalInsights[index];
              return SizedBox(
                width: 300,
                child: PersonalInsightCard(
                  insight: insight,
                  onTap: () => onInsightTap(insight),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InsightPlaceholder extends StatelessWidget {
  final Color accent;

  const _InsightPlaceholder({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Color.lerp(accent, Colors.white, 0.86),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined, color: accent),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              AppStrings.insightLearning,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
