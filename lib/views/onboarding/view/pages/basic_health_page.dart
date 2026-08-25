import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../widgets/index.dart';
import '../../viewmodel/onboarding_view_model.dart';

class BasicHealthPage extends StatelessWidget {
  final OnboardingViewModel vm;

  const BasicHealthPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return OnboardingCard(
      title: AppStrings.basicHealthInformationTitle,
      subtitle: AppStrings.basicHealthInformationSubtitle,
      accent: AppColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _SmokingSection(vm: vm),
          _RelationshipStatusSection(vm: vm),
          _BodyMetricsRow(vm: vm),
        ],
      ),
    );
  }
}

class _SmokingSection extends StatelessWidget {
  final OnboardingViewModel vm;

  const _SmokingSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestion(
      question: AppStrings.smokingUsage,
      child: OnboardingBinaryChoice(
        value: vm.isSmoker,
        onChanged: vm.setIsSmoker,
      ),
    );
  }
}

class _RelationshipStatusSection extends StatelessWidget {
  final OnboardingViewModel vm;

  const _RelationshipStatusSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestion(
      question: AppStrings.relationshipStatus,
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: [
          for (final status in AppStrings.relationshipStatusOptions)
            ChoiceChip(
              label: Text(status),
              selected:
                  AppStrings.localizeStoredValue(vm.relationshipStatus) ==
                  status,
              selectedColor: AppColors.primary.withValues(alpha: 0.14),
              visualDensity: VisualDensity.compact,
              onSelected: (_) => vm.setRelationshipStatus(status),
            ),
        ],
      ),
    );
  }
}

class _BodyMetricsRow extends StatelessWidget {
  final OnboardingViewModel vm;

  const _BodyMetricsRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestion(
      question: AppStrings.weightHeight,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const ValueKey('onboarding_height'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) => vm.setHeight(double.tryParse(value)),
              decoration: InputDecoration(
                labelText: AppStrings.height,
                suffixText: AppStrings.centimeterUnit,
                prefixIcon: const Icon(Icons.height_rounded, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              key: const ValueKey('onboarding_weight'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) => vm.setWeight(double.tryParse(value)),
              decoration: InputDecoration(
                labelText: AppStrings.weight,
                suffixText: AppStrings.kilogramUnit,
                prefixIcon: const Icon(
                  Icons.monitor_weight_outlined,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}