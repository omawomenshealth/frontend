import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../formatters/onboarding_date_slash_formatter.dart';
import '../widgets/index.dart';
import '../../viewmodel/onboarding_view_model.dart';

class MeetYouPage extends StatelessWidget {
  final OnboardingViewModel vm;
  final TextEditingController birthDateController;
  final VoidCallback onPickBirthDate;
  final ValueChanged<String> onBirthDateChanged;

  const MeetYouPage({
    super.key,
    required this.vm,
    required this.birthDateController,
    required this.onPickBirthDate,
    required this.onBirthDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingCard(
      title: AppStrings.meetYouTitle,
      subtitle: AppStrings.meetYouSubtitle,
      accent: AppColors.accent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingFieldLabel(AppStrings.name),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: TextField(
                key: const ValueKey('onboarding_name'),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                onChanged: vm.setUserName,
                decoration: InputDecoration(
                  hintText: AppStrings.nameAddressHint,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          OnboardingFieldLabel(AppStrings.age),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: TextField(
                key: const ValueKey('onboarding_birth_date'),
                controller: birthDateController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(10),
                  const OnboardingDateSlashFormatter(),
                ],
                onChanged: onBirthDateChanged,
                decoration: InputDecoration(
                  hintText: AppStrings.birthDateInputHint,
                  prefixIcon: const Icon(Icons.cake_outlined),
                  suffixIcon: IconButton(
                    key: const ValueKey('onboarding_birth_date_picker'),
                    tooltip: AppStrings.chooseFromCalendar,
                    onPressed: onPickBirthDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: vm.age == null
                ? Text(
                    AppStrings.birthDateManualEntryHint,
                    key: const ValueKey('age_help'),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  )
                : Text(
                    AppStrings.ageYears(vm.age!),
                    key: const ValueKey('age_value'),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}