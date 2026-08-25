List<String> uniqueOnboardingLabels(Iterable<String> values) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in values) {
    final value = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty) continue;
    final normalized = value.replaceAll(RegExp('[İIı]'), 'i').toLowerCase();
    if (seen.add(normalized)) result.add(value);
  }
  return result;
}