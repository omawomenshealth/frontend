import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../localization/generated/strings.g.dart';
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
    final introduction = context.t.onboarding.introduction;
    return OnboardingDeckCard(
      eyebrow: introduction.title,
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
    final introduction = context.t.onboarding.introduction;
    return OnboardingQuestion(
      question: introduction.name,
      child: OnboardingTextField(
        fieldKey: const ValueKey('onboarding_name'),
        hintText: introduction.nameHint,
        textCapitalization: TextCapitalization.words,
        onChanged: onChanged,
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
    final introduction = context.t.onboarding.introduction;
    return OnboardingQuestion(
      question: introduction.birthDate,
      helper: introduction.birthDateHelper,
      child: OnboardingTextField(
        key: const ValueKey('onboarding_birth_date'),
        controller: controller,
        hintText: introduction.birthDateHint,
        keyboardType: TextInputType.datetime,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
          LengthLimitingTextInputFormatter(10),
          const OnboardingDateSlashFormatter(),
        ],
        onChanged: onChanged,
        suffixIcon: IconButton(
          key: const ValueKey('onboarding_birth_date_picker'),
          tooltip: introduction.chooseFromCalendar,
          onPressed: onPickBirthDate,
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}