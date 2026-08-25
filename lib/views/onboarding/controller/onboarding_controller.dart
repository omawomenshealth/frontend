import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/cycle_rules.dart';
import '../view/sheets/index.dart';
import '../viewmodel/onboarding_view_model.dart';

class OnboardingController {
  OnboardingController({
    required this.context,
    required this.vm,
  });

  final BuildContext context;
  final OnboardingViewModel vm;

  Future<void> pickBirthDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: vm.birthDate ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      helpText: AppStrings.selectBirthDate,
    );
    if (selected == null) return;
    vm.setBirthDate(selected);
  }

  Future<void> showLabPicker() async {
    final data = await showLabResultsSheet(context, vm);
    if (data == null) return;
    vm.setLabResults(data.results);
    vm.setLabTestDate(data.testDate);
    vm.setLabTestFasting(data.fasting);
  }

  Future<void> showDiseasePicker() async {
    await showDiseaseSelectionSheet(context, vm);
  }

  Future<void> pickLastPeriod() async {
    final now = DateTime.now();
    final selectedDays = vm.lastPeriodDays;
    final initialStart = selectedDays.isEmpty ? now : selectedDays.first;
    final initialEnd = selectedDays.isEmpty ? now : selectedDays.last;
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: AppStrings.lastPeriodDaysQuestion,
      saveText: AppStrings.save,
    );
    if (selected == null) return;
    final dayCount = selected.duration.inDays + 1;
    if (dayCount > CycleRules.maxPeriodLength) {
      _showError(
        AppStrings.periodDaySelectionLimit(CycleRules.maxPeriodLength),
      );
      return;
    }
    vm.setLastPeriodDays(
      List.generate(
        dayCount,
        (index) => selected.start.add(Duration(days: index)),
      ),
    );
  }

  Future<void> addBirthControl() async {
    final value = await showOnboardingTextInputDialog(
      context,
      AppStrings.addBirthControlMethod,
    );
    if (value == null || value.isEmpty) return;
    vm.addBirthControlMethod(value);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}