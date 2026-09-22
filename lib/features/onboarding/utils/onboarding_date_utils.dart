class OnboardingDateUtils {
  const OnboardingDateUtils._();

  static DateTime? parseBirthDate(String value) {
    if (value.length != 10) return null;

    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final date = DateTime(year, month, day);
    final now = DateTime.now();
    final isValidDate =
        date.year == year && date.month == month && date.day == day;

    if (!isValidDate || date.isAfter(now)) return null;
    return date;
  }

  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}