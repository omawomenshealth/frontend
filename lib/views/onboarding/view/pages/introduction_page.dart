import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../formatters/onboarding_date_slash_formatter.dart';
import '../widgets/index.dart';
import '../../viewmodel/onboarding_view_model.dart';

class IntroductionPage extends StatelessWidget {
  final OnboardingViewModel vm;
  final TextEditingController birthDateController;
  final VoidCallback onPickBirthDate;
  final ValueChanged<String> onBirthDateChanged;

  const IntroductionPage({
    super.key,
    required this.vm,
    required this.birthDateController,
    required this.onPickBirthDate,
    required this.onBirthDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingDeckCard(
      eyebrow: AppStrings.meetYouTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NameField(onChanged: vm.setUserName),
          const SizedBox(height: 22),
          _BirthDateField(
            controller: birthDateController,
            onChanged: onBirthDateChanged,
            onPickBirthDate: onPickBirthDate,
          ),
          const SizedBox(height: 8),
          _AgeIndicator(age: vm.age),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _NameField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return OnboardingInputSection(
      label: AppStrings.name,
      crossAxisAlignment: CrossAxisAlignment.start,
      maxWidth: double.infinity,
      height: 54,
      labelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      child: TextField(
        key: const ValueKey('onboarding_name'),
        textAlign: TextAlign.start,
        textCapitalization: TextCapitalization.words,
        onChanged: onChanged,
        decoration: onboardingInputDecoration(hintText: AppStrings.nameAddressHint).copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFFE3DFD7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFFE3DFD7), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFF78904F), width: 1.5),
          ),
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _BirthDateField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onPickBirthDate;

  const _BirthDateField({
    required this.controller,
    required this.onChanged,
    required this.onPickBirthDate,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingInputSection(
      label: AppStrings.selectBirthDate,
      crossAxisAlignment: CrossAxisAlignment.start,
      maxWidth: double.infinity,
      height: 54,
      helperText: 'Hormon ve döngü yorumlarım yaşına göre değişiyor.',
      labelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      helperStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.35,
      ),
      child: TextField(
        key: const ValueKey('onboarding_birth_date'),
        controller: controller,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.datetime,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
          LengthLimitingTextInputFormatter(10),
          const OnboardingDateSlashFormatter(),
        ],
        onChanged: onChanged,
        decoration: onboardingInputDecoration(
          hintText: 'mm/dd/yyyy',
          suffixIcon: IconButton(
            key: const ValueKey('onboarding_birth_date_picker'),
            tooltip: AppStrings.chooseFromCalendar,
            onPressed: onPickBirthDate,
            icon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ).copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFFE3DFD7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFFE3DFD7), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0xFF78904F), width: 1.5),
          ),
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _AgeIndicator extends StatelessWidget {
  final int? age;

  const _AgeIndicator({required this.age});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: age == null
          ? const SizedBox.shrink(key: ValueKey('age_help'))
          : Text(
              AppStrings.ageYears(age!),
              key: const ValueKey('age_value'),
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}