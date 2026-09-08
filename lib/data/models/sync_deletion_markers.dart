/// Device-local deletion intent. Kept across successful and failed merges so
/// an old backup cannot resurrect records. An explicit restore may reset it.
class SyncDeletionMarkers {
  final Set<String> logs;
  final Set<String> periods;
  final Set<String> reminderPlans;

  const SyncDeletionMarkers({
    this.logs = const {},
    this.periods = const {},
    this.reminderPlans = const {},
  });

  factory SyncDeletionMarkers.fromJson(Map<String, dynamic> json) =>
      SyncDeletionMarkers(
        logs: Set<String>.from(json['logs'] as List),
        periods: Set<String>.from(json['periods'] as List),
        reminderPlans: Set<String>.from(json['reminderPlans'] as List),
      );

  Map<String, dynamic> toJson() => {
    'logs': logs.toList(),
    'periods': periods.toList(),
    'reminderPlans': reminderPlans.toList(),
  };
}
