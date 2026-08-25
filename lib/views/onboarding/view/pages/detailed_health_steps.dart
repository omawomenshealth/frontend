import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/cycle_rules.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../../widgets/index.dart';

class LabStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onOpen;

  const LabStep({super.key, required this.vm, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return OnboardingCompactPrompt(
      icon: Icons.science_outlined,
      accent: AppColors.secondary,
      title: AppStrings.bloodResults,
      description: AppStrings.bloodResultsDescription,
      summary: vm.labResults.isEmpty
          ? AppStrings.noBloodResultsAdded
          : AppStrings.bloodResultsAdded(vm.labResults.length),
      buttonLabel: AppStrings.searchBloodTests,
      onPressed: onOpen,
    );
  }
}

class DiseaseStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onOpen;

  const DiseaseStep({super.key, required this.vm, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return OnboardingCompactPrompt(
      icon: Icons.health_and_safety_outlined,
      accent: AppColors.accent,
      title: AppStrings.knownConditionQuestion,
      description: AppStrings.combinedConditionsDescription,
      summary: vm.knownDiseases.isEmpty
          ? AppStrings.noConditionSelected
          : vm.knownDiseases.map(AppStrings.localizeStoredValue).join(', '),
      buttonLabel: AppStrings.searchConditions,
      onPressed: onOpen,
    );
  }
}

class CycleStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onPickLastPeriod;

  const CycleStep({super.key, required this.vm, required this.onPickLastPeriod});

  @override
  Widget build(BuildContext context) {
    final selectedDays = vm.lastPeriodDays;
    final firstDay = selectedDays.isEmpty ? null : selectedDays.first;
    final lastDay = selectedDays.isEmpty ? null : selectedDays.last;
    String format(DateTime date) =>
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
    final selectionLabel = firstDay == null
        ? AppStrings.selectLastPeriodDays
        : selectedDays.length == 1
        ? '${format(firstDay)} · ${AppStrings.periodDaysSelected(1)}'
        : '${format(firstDay)} – ${format(lastDay!)} · '
              '${AppStrings.periodDaysSelected(selectedDays.length)}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingFieldLabel(AppStrings.cycleInformation),
        Material(
          color: Colors.transparent,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(AppStrings.doNotKnowCycleLength),
            subtitle: Text(AppStrings.calculateCycleOverTime),
            value: vm.isCycleLengthUnknown,
            activeThumbColor: AppColors.accent,
            onChanged: vm.setIsCycleLengthUnknown,
          ),
        ),
        if (!vm.isCycleLengthUnknown)
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: vm.averageCycleLength.toDouble(),
                  min: CycleRules.minCycleLength.toDouble(),
                  max: CycleRules.maxCycleLength.toDouble(),
                  divisions:
                      CycleRules.maxCycleLength - CycleRules.minCycleLength,
                  activeColor: AppColors.accent,
                  onChanged: (value) => vm.setAverageCycleLength(value.round()),
                ),
              ),
              Text(
                AppStrings.dayCount(vm.averageCycleLength),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        Text(
          AppStrings.lastPeriodDaysQuestion,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            key: const ValueKey('onboarding_last_period_days'),
            onPressed: onPickLastPeriod,
            icon: const Icon(Icons.date_range_outlined),
            label: Text(selectionLabel),
          ),
        ),
      ],
    );
  }
}

class ReproductiveStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onAddBirthControl;

  const ReproductiveStep({
    super.key,
    required this.vm,
    required this.onAddBirthControl,
  });

  @override
  Widget build(BuildContext context) {
    final menopauseOptions = <(String, MenopauseStatus)>[
      (AppStrings.none, MenopauseStatus.none),
      (AppStrings.preMenopause, MenopauseStatus.pre),
      (AppStrings.periMenopause, MenopauseStatus.peri),
      (AppStrings.postMenopause, MenopauseStatus.post),
    ];
    final birthControlOptions = uniqueOnboardingLabels([
      AppStrings.noBirthControl,
      AppStrings.pill,
      AppStrings.iud,
      AppStrings.condom,
      AppStrings.implant,
      ...vm.customBirthControlMethods,
    ]);
    final selectedMethod = AppStrings.localizeStoredValue(
      vm.birthControlMethod ?? '',
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingFieldLabel(AppStrings.menopauseStatus),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final option in menopauseOptions)
              ChoiceChip(
                label: Text(option.$1),
                selected: vm.menopauseStatus == option.$2,
                selectedColor: AppColors.secondary.withValues(alpha: 0.14),
                visualDensity: VisualDensity.compact,
                onSelected: (_) => vm.setMenopauseStatus(option.$2),
              ),
          ],
        ),
        const SizedBox(height: 16),
        OnboardingFieldLabel(AppStrings.birthControl),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final method in birthControlOptions)
              ChoiceChip(
                label: Text(method),
                selected: selectedMethod == method,
                selectedColor: AppColors.accent.withValues(alpha: 0.14),
                visualDensity: VisualDensity.compact,
                onSelected: (_) => vm.setBirthControlMethod(method),
              ),
            ActionChip(
              key: const ValueKey('onboarding_add_birth_control'),
              avatar: const Icon(
                Icons.add_rounded,
                size: 17,
                color: AppColors.accent,
              ),
              label: Text(AppStrings.add),
              visualDensity: VisualDensity.compact,
              side: BorderSide(color: AppColors.accent.withValues(alpha: 0.42)),
              onPressed: onAddBirthControl,
            ),
          ],
        ),
      ],
    );
  }
}

