import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../utils/onboarding_label_utils.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';
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
  final initialSelected = vm.knownDiseases
      .map(AppStrings.localizeStoredValue)
      .toSet();
  final selected = <String>{...initialSelected};
  final addedCustom = <String>{};
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
          onSave: () {
            for (final disease in initialSelected.difference(selected)) {
              vm.toggleKnownDisease(disease);
            }
            for (final disease in selected.difference(initialSelected)) {
              if (addedCustom.contains(disease)) {
                vm.addKnownDisease(disease);
              } else {
                vm.toggleKnownDisease(disease);
              }
            }
            Navigator.pop(sheetContext);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                key: const ValueKey('onboarding_disease_search'),
                onChanged: (value) => setSheetState(() => query = value),
                style: OnboardingTypography.input.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.searchConditions,
                  hintStyle: OnboardingTypography.input.copyWith(
                    color: AppColors.textHint,
                  ),
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
                      selected: selected.contains(disease),
                      selectedColor: AppColors.accent.withValues(alpha: 0.14),
                        labelStyle: selected.contains(disease)
                          ? OnboardingTypography.selectedControl
                          : OnboardingTypography.control,
                      onSelected: (_) {
                        if (selected.contains(disease)) {
                          selected.remove(disease);
                        } else {
                          selected.add(disease);
                        }
                        setSheetState(() {});
                      },
                    ),
                  ActionChip(
                    key: const ValueKey('onboarding_add_known_disease'),
                    avatar: const Icon(Icons.add_rounded, size: 17),
                    label: Text(AppStrings.add),
                    labelStyle: OnboardingTypography.control,
                    onPressed: () async {
                      final value = await showOnboardingTextInputDialog(
                        sheetContext,
                        AppStrings.addCondition,
                      );
                      if (value == null || value.isEmpty) return;
                      catalog.add(value);
                      addedCustom.add(value);
                      selected.add(value);
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