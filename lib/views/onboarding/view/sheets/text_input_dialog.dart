import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

Future<String?> showOnboardingTextInputDialog(
  BuildContext context,
  String title,
) {
  var value = '';
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        maxLength: 80,
        onChanged: (text) => value = text,
        onSubmitted: (text) => Navigator.pop(dialogContext, text.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, value.trim()),
          child: Text(AppStrings.add),
        ),
      ],
    ),
  );
}