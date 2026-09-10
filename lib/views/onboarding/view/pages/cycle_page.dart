import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/index.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../utils/onboarding_label_utils.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class CyclePage extends StatelessWidget {
  const CyclePage({
    super.key,
    required this.vm,
    required this.onPickLastPeriod,
    required this.onAddBirthControl,
  });

  final OnboardingViewModel vm;
  final VoidCallback onPickLastPeriod;
  final VoidCallback onAddBirthControl;

  @override
  Widget build(BuildContext context) {
    final cycle = context.t.onboarding.cycle;


    return OnboardingCard(
      label: cycle.title,
      children: [
        _CycleLengthField(
          vm: vm,
          cycle: cycle,
        ),
        _LastPeriodField(
          cycle: cycle,
          onPickLastPeriod: onPickLastPeriod,
        ),
        _BirthControlField(
          vm: vm,
          cycle: cycle,
          onAddBirthControl: onAddBirthControl,
        ),
      ],
    );
  }
}

class _CycleLengthField extends StatelessWidget {
  const _CycleLengthField({
    required this.vm,
    required this.cycle,
  });

  final OnboardingViewModel vm;
  final dynamic cycle;

  @override
  Widget build(BuildContext context) {
    return OmaField(
      label: cycle.averageCycleLength,
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: vm.averageCycleLength.toDouble(),
              min: 21,
              max: 40,
              divisions: 19,
              activeColor: OmaColors.primary,
              onChanged: (value) {
                vm.setAverageCycleLength(
                  value.round(),
                );
              },
            ),
          ),
          Text(
            cycle.dayCount(
              days: vm.averageCycleLength,
            ),
          ),
        ],
      ),
    );
  }
}

class _LastPeriodField extends StatelessWidget {
  const _LastPeriodField({
    required this.cycle,
    required this.onPickLastPeriod,
  });

  final dynamic cycle;
  final VoidCallback onPickLastPeriod;

  @override
  Widget build(BuildContext context) {
    return OmaField(
      label: cycle.lastPeriodDays,
      hint: cycle.lastPeriodHelper,
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          key: const ValueKey(
            'onboarding_last_period_days',
          ),
          onPressed: onPickLastPeriod,
          icon: const Icon(
            Icons.date_range_outlined,
          ),
          label: Text(
            cycle.selectLastPeriodDays,
          ),
        ),
      ),
    );
  }
}

class _BirthControlField extends StatelessWidget {
  const _BirthControlField({
    required this.vm,
    required this.cycle,
    required this.onAddBirthControl,
  });

  final OnboardingViewModel vm;
  final dynamic cycle;
  final VoidCallback onAddBirthControl;

  @override
  Widget build(BuildContext context) {
    final birthControlOptions = uniqueOnboardingLabels([
      AppStrings.noBirthControl,
      AppStrings.pill,
      AppStrings.iud,
      AppStrings.condom,
      AppStrings.implant,
      ...vm.customBirthControlMethods,
    ]);

    final selectedBirthControl =
        AppStrings.localizeStoredValue(
      vm.birthControlMethod ?? '',
    );

    return OmaField(
      label: cycle.birthControl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OmaSingleSelect<String>(
            options: birthControlOptions,
            selectedValue: selectedBirthControl.isEmpty
                ? null
                : selectedBirthControl,
            labelBuilder: (value) => value,
            onChanged: vm.setBirthControlMethod,
          ),
          const SizedBox(height: 8),
          OmaChip(
            label: cycle.addBirthControl,
            showCheck: false,
            onTap: onAddBirthControl,
          ),
        ],
      ),
    );
  }
}