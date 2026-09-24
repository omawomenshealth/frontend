import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/widgets/oma_toast.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../localization/generated/strings.g.dart';
import '../../../views/calendar/view/calendar_view.dart' as cal;
import '../../../views/calendar/viewmodel/calendar_view_model.dart';
import '../../../views/dashboard/widgets/daily_log_sheet.dart';
import '../../../views/dashboard/widgets/medication_reminder_section.dart';
import '../../../views/insights/view/insights_view.dart';
import '../../../views/profile/viewmodel/profile_view_model.dart';
import '../../notifications/view/notifications_view.dart';
import '../viewmodel/home_view_model.dart';
import 'widgets/index.dart';

/// Oma's daily home screen.
///
/// Responsible only for composing the home UI and forwarding user actions.
/// Cycle-derived presentation data is prepared by [HomeViewModel].
class HomeView extends StatelessWidget {
  final VoidCallback? onOpenInsights;

  const HomeView({super.key, this.onOpenInsights});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return Scaffold(
            backgroundColor: context.omaTheme.background,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final calculator = vm.periodCalculator;

        final trackingMode = vm.settings?.trackingMode ?? TrackingMode.cycle;
        final theme = context.omaTheme;
        final accent = theme.primary;

        return Scaffold(
          backgroundColor: Color.lerp(theme.background, accent, 0.035),
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: accent,
              onRefresh: vm.loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(OmaSpacing.lg, OmaSpacing.md, OmaSpacing.lg, 132),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      userName: vm.settings?.userName,
                      selectedDate: vm.selectedDate,
                      accent: accent,
                      onCalendarTap: () => _openCalendar(context),
                      onNotificationTap: () => _onNotificationView(context),
                    ),

                    const SizedBox(height: 22),

                    HorizontalCalendar(
                      selectedDate: vm.selectedDate,
                      onDateSelected: vm.selectDate,
                      periodCalculator: calculator,
                    ),

                    const SizedBox(height: 14),

                    HomeHeroSection(
                      trackingMode: trackingMode,
                      pregnancyEstimate: vm.pregnancyEstimate,
                      positiveTestDate: vm.settings?.pregnancyTestPositiveDate,
                      cycleData: vm.cycleHeroData,
                      onOpenInsights: () => _openInsights(context),
                    ),

                    const SizedBox(height: OmaSpacing.xl),

                    QuickLogs(
                      accent: accent,
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

                    InsightsPreview(
                      insights: vm.personalInsights,
                      accent: accent,
                      onViewAll: () => _openInsights(context),
                      onInsightTap: (insight) => _openInsight(context, insight),
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

  void _onNotificationView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsView()),
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
        themeColor: context.omaTheme.primary,
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
