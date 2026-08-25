import 'package:flutter/services.dart';

class OnboardingDateSlashFormatter extends TextInputFormatter {
  const OnboardingDateSlashFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length && index < 8; index++) {
      if (index == 2 || index == 4) buffer.write('/');
      buffer.write(digits[index]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}