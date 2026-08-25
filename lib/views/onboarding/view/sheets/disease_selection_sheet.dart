import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../../widgets/index.dart';
import 'text_input_dialog.dart';

Future<void> showDiseaseSelectionSheet(
  BuildContext context,
  OnboardingViewModel vm,
) async {
  final catalog = uniqueOnboardingLabels([
    ...AppStrings.chronicDiseasesList,
    ...AppStrings.womenDiseasesList,
    ...vm.customConditions,
  ]);
  var query = '';
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        final normalizedQuery = query.trim().toLowerCase();
        final visible = {
          ...catalog.where(
            (item) => item.toLowerCase().contains(normalizedQuery),
          ),
          ...vm.knownDiseases.where(
            (item) => item.toLowerCase().contains(normalizedQuery),
          ),
        }.toList(growable: false);
        return OnboardingSelectionSheet(
          title: AppStrings.conditions,
          icon: Icons.health_and_safety_outlined,
          accent: AppColors.accent,
          onSave: () => Navigator.pop(sheetContext),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                key: const ValueKey('onboarding_disease_search'),
                onChanged: (value) => setSheetState(() => query = value),
                decoration: InputDecoration(
                  hintText: AppStrings.searchConditions,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final disease in visible)
                    FilterChip(
                      label: Text(disease),
                      selected: vm.knownDiseases.any(
                        (value) =>
                            AppStrings.localizeStoredValue(
                              value,
                            ).toLowerCase() ==
                            disease.toLowerCase(),
                      ),
                      selectedColor: AppColors.accent.withValues(alpha: 0.14),
                      onSelected: (_) {
                        vm.toggleKnownDisease(disease);
                        setSheetState(() {});
                      },
                    ),
                  ActionChip(
                    key: const ValueKey('onboarding_add_known_disease'),
                    avatar: const Icon(Icons.add_rounded, size: 17),
                    label: Text(AppStrings.add),
                    onPressed: () async {
                      final value = await showOnboardingTextInputDialog(
                        sheetContext,
                        AppStrings.addCondition,
                      );
                      if (value == null || value.isEmpty) return;
                      vm.addKnownDisease(value);
                      setSheetState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}