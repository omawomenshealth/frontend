import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class HealthProfilePage extends StatefulWidget {
  final OnboardingViewModel vm;
  final VoidCallback onOpenDiseases;

  const HealthProfilePage({
    super.key,
    required this.vm,
    required this.onOpenDiseases,
  });

  @override
  State<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  SmokingStatus? _smokingStatus;

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    return OnboardingDeckCard(
      eyebrow: AppStrings.symptomBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(
                  child: OnboardingQuestion(
                    question: AppStrings.height,
                    controlSpacing: 0,
                    child: OnboardingTextField(
                      fieldKey: const ValueKey('onboarding_height'),
                      hintText: '165',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (value) =>
                          vm.setHeight(double.tryParse(value)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OnboardingQuestion(
                    question: AppStrings.weight,
                    controlSpacing: 0,
                    child: OnboardingTextField(
                      fieldKey: const ValueKey('onboarding_weight'),
                      hintText: '60',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (value) =>
                          vm.setWeight(double.tryParse(value)),
                    ),
                  ),
                ),
            ],
          ),
          OnboardingQuestion(
            question: AppStrings.smokingStatus,
            child: OnboardingSingleSelect(
              options: const [
                SmokingStatus.current,
                SmokingStatus.never,
                SmokingStatus.former,
              ],
              selectedValue: _smokingStatus,
              labelBuilder: (value) {
                if (value == SmokingStatus.current) return AppStrings.yes;
                if (value == SmokingStatus.never) return AppStrings.no;
                return 'Bıraktım';
              },
              onChanged: (value) {
                setState(() => _smokingStatus = value);
                vm.setSmokingStatus(value);
              },
              spacing: 6,
              runSpacing: 6,
            ),
          ),
          OnboardingQuestion(
            question: AppStrings.knownConditionQuestion,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                OnboardingMultiSelect(
                    options: vm.knownDiseases
                      .map(AppStrings.localizeStoredValue)
                      .toList(growable: false),
                  selectedValues: vm.knownDiseases
                      .map(AppStrings.localizeStoredValue)
                      .toSet(),
                  onChanged: (next) {
                    final current = vm.knownDiseases
                        .map(AppStrings.localizeStoredValue)
                        .toSet();
                    for (final disease in current.difference(next)) {
                      vm.toggleKnownDisease(disease);
                    }
                    for (final disease in next.difference(current)) {
                      vm.toggleKnownDisease(disease);
                    }
                    setState(() {});
                  },
                  spacing: 6,
                  runSpacing: 6,
                ),
                ActionChip(
                  key: const ValueKey('onboarding_add_known_disease'),
                  avatar: const Icon(Icons.add_rounded, size: 17),
                  label: Text(AppStrings.add),
                  onPressed: widget.onOpenDiseases,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
