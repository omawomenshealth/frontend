import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/shared_widgets/lab_results_form.dart';
import '../../../../../data/models/lab_result_model.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../../widgets/index.dart';

class LabResultsSheetData {
  final Map<String, LabResult> results;
  final DateTime? testDate;
  final bool? fasting;

  const LabResultsSheetData({
    required this.results,
    required this.testDate,
    required this.fasting,
  });
}

Future<LabResultsSheetData?> showLabResultsSheet(
  BuildContext context,
  OnboardingViewModel vm,
) async {
  var results = Map<String, LabResult>.from(vm.labResults);
  var testDate = vm.labTestDate;
  var fasting = vm.labTestFasting;
  final save = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => OnboardingSelectionSheet(
      title: AppStrings.bloodResults,
      icon: Icons.science_outlined,
      accent: AppColors.secondary,
      onSave: () => Navigator.pop(sheetContext, true),
      child: LabResultsForm(
        initialResults: results,
        initialTestDate: testDate,
        initialFasting: fasting,
        accent: AppColors.secondary,
        onResultsChanged: (value) => results = value,
        onTestDateChanged: (value) => testDate = value,
        onFastingChanged: (value) => fasting = value,
      ),
    ),
  );
  if (save != true) return null;
  return LabResultsSheetData(
    results: results,
    testDate: testDate,
    fasting: fasting,
  );
}