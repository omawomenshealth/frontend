import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../utils/onboarding_label_utils.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class CyclePage extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onPickLastPeriod;
  final VoidCallback onAddBirthControl;

  const CyclePage({
    super.key,
    required this.vm,
    required this.onPickLastPeriod,
    required this.onAddBirthControl,
  });

  @override
  Widget build(BuildContext context) {
    final cycle = context.t.onboarding.cycle;

    final birthControlOptions = uniqueOnboardingLabels([
      AppStrings.noBirthControl,
      AppStrings.pill,
      AppStrings.iud,
      AppStrings.condom,
      AppStrings.implant,
      ...vm.customBirthControlMethods,
    ]);

    final selectedBirthControl = AppStrings.localizeStoredValue(
      vm.birthControlMethod ?? '',
    );

    final menopauseOptions = <(String, MenopauseStatus)>[
      (AppStrings.none, MenopauseStatus.none),
      (AppStrings.preMenopause, MenopauseStatus.pre),
      (AppStrings.periMenopause, MenopauseStatus.peri),
      (AppStrings.postMenopause, MenopauseStatus.post),
    ];

    final canEnterCycleInformation =
        vm.hasMenopauseSelection &&
        vm.menopauseStatus == MenopauseStatus.none;

    return OnboardingDeckCard(
      eyebrow: cycle.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          OnboardingQuestion(
            question: cycle.menopauseStatus,
            child: OnboardingSingleSelect<MenopauseStatus>(
              options: [
                for (final option in menopauseOptions) option.$2,
              ],
              selectedValue: vm.hasMenopauseSelection
                  ? vm.menopauseStatus
                  : null,
              labelBuilder: (value) {
                return menopauseOptions
                    .firstWhere((option) => option.$2 == value)
                    .$1;
              },
              onChanged: vm.setMenopauseStatus,
              spacing: 6,
              runSpacing: 6,
            ),
          ),

          if (canEnterCycleInformation) ...[
            OnboardingQuestion(
              question: cycle.averageCycleLength,
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: vm.averageCycleLength.toDouble(),
                      min: 21,
                      max: 40,
                      divisions: 19,
                      activeColor: AppColors.primary,
                      onChanged: (value) =>
                          vm.setAverageCycleLength(value.round()),
                    ),
                  ),
                  Text(
                    cycle.dayCount(
                      days: vm.averageCycleLength,
                    ),
                  ),
                ],
              ),
            ),

            OnboardingQuestion(
              question: cycle.lastPeriodDays,
              helper: cycle.lastPeriodHelper,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const ValueKey(
                    'onboarding_last_period_days',
                  ),
                  onPressed: onPickLastPeriod,
                  icon: const Icon(Icons.date_range_outlined),
                  label: Text(cycle.selectLastPeriodDays),
                ),
              ),
            ),

            OnboardingQuestion(
              question: cycle.birthControl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  OnboardingMultiSelect(
                    options: birthControlOptions,
                    selectedValues: {
                      if (selectedBirthControl.isNotEmpty)
                        selectedBirthControl,
                    },
                    onChanged: (next) => vm.setBirthControlMethod(
                      next.isEmpty ? null : next.first,
                    ),
                  ),
                  ActionChip(
                    key: const ValueKey(
                      'onboarding_add_birth_control',
                    ),
                    avatar: const Icon(
                      Icons.add_rounded,
                      size: 17,
                    ),
                    label: Text(cycle.addBirthControl),
                    onPressed: onAddBirthControl,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}