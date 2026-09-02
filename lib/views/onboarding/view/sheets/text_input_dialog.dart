import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../widgets/onboarding_typography.dart';

Future<String?> showOnboardingTextInputDialog(
  BuildContext context,
  String title,
) {
  var value = '';
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title, style: OnboardingTypography.displayHeading),
      content: TextField(
        autofocus: true,
        maxLength: 80,
        style: OnboardingTypography.input,
        onChanged: (text) => value = text,
        onSubmitted: (text) => Navigator.pop(dialogContext, text.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: TextButton.styleFrom(
            textStyle: OnboardingTypography.secondaryButton,
          ),
          child: Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, value.trim()),
          style: FilledButton.styleFrom(textStyle: OnboardingTypography.button),
          child: Text(AppStrings.add),
        ),
      ],
    ),
  );
}