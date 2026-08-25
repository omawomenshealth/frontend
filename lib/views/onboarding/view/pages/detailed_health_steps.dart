import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/cycle_rules.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../utils/onboarding_date_utils.dart';
import '../../utils/onboarding_label_utils.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class LabStep extends StatelessWidget {
  final int resultCount;
  final VoidCallback onOpen;

  const LabStep({
    super.key,
    required this.resultCount,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingCompactPrompt(
      icon: Icons.science_outlined,
      accent: AppColors.secondary,
      title: AppStrings.bloodResults,
      description: AppStrings.bloodResultsDescription,
      summary: resultCount == 0
          ? AppStrings.noBloodResultsAdded
          : AppStrings.bloodResultsAdded(resultCount),
      buttonLabel: AppStrings.searchBloodTests,
      onPressed: onOpen,
    );
  }
}

class DiseaseStep extends StatelessWidget {
  final List<String> diseases;
  final VoidCallback onOpen;

  const DiseaseStep({
    super.key,
    required this.diseases,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingCompactPrompt(
      icon: Icons.health_and_safety_outlined,
      accent: AppColors.accent,
      title: AppStrings.knownConditionQuestion,
      description: AppStrings.combinedConditionsDescription,
      summary: diseases.isEmpty
          ? AppStrings.noConditionSelected
          : diseases
              .map(AppStrings.localizeStoredValue)
              .join(', '),
      buttonLabel: AppStrings.searchConditions,
      onPressed: onOpen,
    );
  }
}

class CycleStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onPickLastPeriod;

  const CycleStep({
    super.key,
    required this.vm,
    required this.onPickLastPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CycleLengthSection(vm: vm),
        const SizedBox(height: 8),
        _LastPeriodSection(
          selectedDays: vm.lastPeriodDays,
          onPick: onPickLastPeriod,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MenopauseSection(vm: vm),
        const SizedBox(height: 16),
        _BirthControlSection(
          vm: vm,
          onAddBirthControl: onAddBirthControl,
        ),
      ],
    );
  }
}

class _CycleLengthSection extends StatelessWidget {
  final OnboardingViewModel vm;

  const _CycleLengthSection({
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestion(
      question: AppStrings.cycleInformation,
      controlSpacing: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            _CycleLengthSlider(
              value: vm.averageCycleLength,
              onChanged: (value) =>
                  vm.setAverageCycleLength(value.round()),
            ),
        ],
      ),
    );
  }
}

class _LastPeriodSection extends StatelessWidget {
  final List<DateTime> selectedDays;
  final VoidCallback onPick;

  const _LastPeriodSection({
    required this.selectedDays,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestion(
      question: AppStrings.lastPeriodDaysQuestion,
      controlSpacing: 0,
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          key: const ValueKey(
            'onboarding_last_period_days',
          ),
          onPressed: onPick,
          icon: const Icon(Icons.date_range_outlined),
          label: Text(
            _buildPeriodSelectionLabel(selectedDays),
          ),
        ),
      ),
    );
  }
}

class _CycleLengthSlider extends StatelessWidget {
  final int value;
  final ValueChanged<double> onChanged;

  const _CycleLengthSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: CycleRules.minCycleLength.toDouble(),
            max: CycleRules.maxCycleLength.toDouble(),
            divisions: CycleRules.maxCycleLength - CycleRules.minCycleLength,
            activeColor: AppColors.accent,
            onChanged: onChanged,
          ),
        ),
        Text(
          AppStrings.dayCount(value),
          style: const TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

String _buildPeriodSelectionLabel(
  List<DateTime> days,
) {
  if (days.isEmpty) {
    return AppStrings.selectLastPeriodDays;
  }

  final first = days.first;

  if (days.length == 1) {
    return '${OnboardingDateUtils.formatDate(first)} · '
        '${AppStrings.periodDaysSelected(1)}';
  }

  final last = days.last;

  return '${OnboardingDateUtils.formatDate(first)} – '
      '${OnboardingDateUtils.formatDate(last)} · '
      '${AppStrings.periodDaysSelected(days.length)}';
}

class _MenopauseSection extends StatelessWidget {
  final OnboardingViewModel vm;

  const _MenopauseSection({
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    final options = <(String, MenopauseStatus)>[
      (AppStrings.none, MenopauseStatus.none),
      (AppStrings.preMenopause, MenopauseStatus.pre),
      (AppStrings.periMenopause, MenopauseStatus.peri),
      (AppStrings.postMenopause, MenopauseStatus.post),
    ];

    return OnboardingQuestion(
      question: AppStrings.menopauseStatus,
      controlSpacing: 0,
      child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(option.$1),
                selected: vm.menopauseStatus == option.$2,
                selectedColor: AppColors.secondary.withValues(
                  alpha: 0.14,
                ),
                visualDensity: VisualDensity.compact,
                onSelected: (_) {
                  vm.setMenopauseStatus(option.$2);
                },
              ),
          ],
      ),
    );
  }
}

class _BirthControlSection extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onAddBirthControl;

  const _BirthControlSection({
    required this.vm,
    required this.onAddBirthControl,
  });

  @override
  Widget build(BuildContext context) {
    final options = uniqueOnboardingLabels([
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

    return OnboardingQuestion(
      question: AppStrings.birthControl,
      controlSpacing: 0,
      child: Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final method in options)
              ChoiceChip(
                label: Text(method),
                selected: selectedMethod == method,
                selectedColor: AppColors.accent.withValues(
                  alpha: 0.14,
                ),
                visualDensity: VisualDensity.compact,
                onSelected: (_) {
                  vm.setBirthControlMethod(method);
                },
              ),
            ActionChip(
              key: const ValueKey(
                'onboarding_add_birth_control',
              ),
              avatar: const Icon(
                Icons.add_rounded,
                size: 17,
                color: AppColors.accent,
              ),
              label: Text(AppStrings.add),
              visualDensity: VisualDensity.compact,
              side: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.42),
              ),
              onPressed: onAddBirthControl,
            ),
          ],
      ),
    );
  }
}