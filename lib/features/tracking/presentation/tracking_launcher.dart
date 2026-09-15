import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/core/widgets/oma_toast.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';

import '../application/tracking_controller.dart';
import '../domain/models/daily_log.dart';
import '../domain/models/tracking_section.dart';
import 'daily_log_sheet.dart';

/// Public entry point for tracking UI. Screens choose a section and react to
/// edits, without constructing DailyLogSheet or performing log writes.
abstract final class TrackingLauncher {
  static Future<void> open(
    BuildContext context, {
    required TrackingSection section,
    required DateTime date,
    required UserSettings settings,
    required Color themeColor,
    Future<void> Function()? onChanged,
    Future<void> Function()? onSettingsChanged,
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

    final tracking = context.read<TrackingController>();
    final initialLog = tracking.initialLogForSection(section, date);
    Future<bool> save(DailyLog log) async {
      final saved = await tracking.saveLog(log);
      if (saved) await _refreshConsumer(onChanged);
      return saved;
    }

    Future<bool> deletePeriod(DateTime date) async {
      final deleted = await tracking.deletePeriodForDate(date);
      if (deleted) await _refreshConsumer(onChanged);
      return deleted;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => switch (section) {
        TrackingSection.period => PeriodTrackingSheet(
          initialLog: initialLog,
          settings: settings,
          themeColor: themeColor,
          onSave: save,
          onDeletePeriod: deletePeriod,
          onSettingsChanged: onSettingsChanged,
        ),
        TrackingSection.nutrition => NutritionTrackingSheet(
          initialLog: initialLog,
          settings: settings,
          themeColor: themeColor,
          onSave: save,
          onSettingsChanged: onSettingsChanged,
        ),
        TrackingSection.symptoms => SymptomsTrackingSheet(
          initialLog: initialLog,
          settings: settings,
          themeColor: themeColor,
          onSave: save,
          onSettingsChanged: onSettingsChanged,
        ),
        TrackingSection.wellbeing => WellbeingTrackingSheet(
          initialLog: initialLog,
          settings: settings,
          themeColor: themeColor,
          onSave: save,
          onSettingsChanged: onSettingsChanged,
        ),
        TrackingSection.medication => MedicationTrackingSheet(
          initialLog: initialLog,
          settings: settings,
          themeColor: themeColor,
          onSave: save,
          onSettingsChanged: onSettingsChanged,
        ),
        TrackingSection.skincare => SkincareTrackingSheet(
          initialLog: initialLog,
          settings: settings,
          themeColor: themeColor,
          onSave: save,
          onSettingsChanged: onSettingsChanged,
        ),
      },
    );
  }

  static Future<void> _refreshConsumer(
    Future<void> Function()? callback,
  ) async {
    try {
      await callback?.call();
    } catch (error) {
      // A screen refresh is not part of the encrypted log transaction.
      debugPrint('Tracking consumer refresh failed after save: $error');
    }
  }
}
