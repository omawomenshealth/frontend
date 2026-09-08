import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/index.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class HealthProfilePage extends StatefulWidget {
  const HealthProfilePage({
    super.key,
    required this.vm,
    required this.onOpenDiseases,
  });

  final OnboardingViewModel vm;
  final VoidCallback onOpenDiseases;

  @override
  State<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  SmokingStatus? _smokingStatus;

  @override
  Widget build(BuildContext context) {
    final healthProfile = context.t.onboarding.health_profile;

    return OnboardingCard(
      label: healthProfile.title,
      children: [
        _BodyMeasurementsField(
          vm: widget.vm,
          healthProfile: healthProfile,
        ),
        _SmokingField(
          value: _smokingStatus,
          healthProfile: healthProfile,
          onChanged: (value) {
            setState(() {
              _smokingStatus = value;
            });

            widget.vm.setSmokingStatus(value);
          },
        ),
        _KnownConditionsField(
          vm: widget.vm,
          healthProfile: healthProfile,
          onOpenDiseases: widget.onOpenDiseases,
        ),
      ],
    );
  }
}

class _BodyMeasurementsField extends StatelessWidget {
  const _BodyMeasurementsField({
    required this.vm,
    required this.healthProfile,
  });

  final OnboardingViewModel vm;
  final dynamic healthProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: OmaField(
            label: healthProfile.height,
            child: OmaInput(
              hintText: '165',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) {
                vm.setHeight(double.tryParse(value));
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OmaField(
            label: healthProfile.weight,
            child: OmaInput(
              hintText: '60',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) {
                vm.setWeight(double.tryParse(value));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SmokingField extends StatelessWidget {
  const _SmokingField({
    required this.value,
    required this.healthProfile,
    required this.onChanged,
  });

  final SmokingStatus? value;
  final dynamic healthProfile;
  final ValueChanged<SmokingStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return OmaField(
      label: healthProfile.smokingStatus,
      child: OmaSingleSelect<SmokingStatus>(
        options: const [
          SmokingStatus.current,
          SmokingStatus.never,
          SmokingStatus.former,
        ],
        selectedValue: value,
        labelBuilder: (value) {
          switch (value) {
            case SmokingStatus.current:
              return healthProfile.smokingCurrent;
            case SmokingStatus.never:
              return healthProfile.smokingNever;
            case SmokingStatus.former:
              return healthProfile.smokingFormer;
          }
        },
        onChanged: onChanged,
      ),
    );
  }
}

class _KnownConditionsField extends StatelessWidget {
  const _KnownConditionsField({
    required this.vm,
    required this.healthProfile,
    required this.onOpenDiseases,
  });

  final OnboardingViewModel vm;
  final dynamic healthProfile;
  final VoidCallback onOpenDiseases;

  @override
  Widget build(BuildContext context) {
    final diseases = vm.knownDiseases
        .map(AppStrings.localizeStoredValue)
        .toList(growable: false);

    final selectedDiseases = diseases.toSet();

    return OmaField(
      label: healthProfile.knownConditions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OmaMultiSelect<String>(
            options: diseases,
            selectedValues: selectedDiseases,
            labelBuilder: (value) => value,
            onChanged: (next) {
              for (final disease in selectedDiseases.difference(next)) {
                vm.toggleKnownDisease(disease);
              }

              for (final disease in next.difference(selectedDiseases)) {
                vm.toggleKnownDisease(disease);
              }
            },
          ),
          const SizedBox(height: 8),
          OmaChip(
            label: healthProfile.addCondition,
            showCheck: false,
            onTap: onOpenDiseases,
          ),
        ],
      ),
    );
  }
}