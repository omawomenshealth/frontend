enum NotificationEntryType { app, log }

class PeriodNotificationDetails {
  const PeriodNotificationDetails({
    required this.date,
    this.flow,
    this.symptoms = const [],
  });

  final DateTime date;
  final String? flow;
  final List<String> symptoms;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'flow': flow,
    'symptoms': symptoms,
  };

  static PeriodNotificationDetails? fromJson(Map<String, dynamic> json) {
    final date = DateTime.tryParse(json['date']?.toString() ?? '');
    if (date == null) return null;
    return PeriodNotificationDetails(
      date: date,
      flow: json['flow'] is String ? json['flow'] as String : null,
      symptoms: (json['symptoms'] is List)
          ? (json['symptoms'] as List).whereType<String>().toList()
          : const [],
    );
  }
}

class NotificationEntry {
  const NotificationEntry({
    required this.type,
    required this.title,
    required this.createdAt,
    this.description,
    this.periodDetails,
  });

  final NotificationEntryType type;
  final String title;
  final String? description;
  final PeriodNotificationDetails? periodDetails;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'title': title,
    'description': description,
    if (periodDetails != null) 'periodDetails': periodDetails!.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };

  static NotificationEntry? fromJson(Map<String, dynamic> json) {
    final type = NotificationEntryType.values
        .where((value) => value.name == json['type'])
        .firstOrNull;
    final title = json['title'];
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');
    if (type == null || title is! String || createdAt == null) return null;
    return NotificationEntry(
      type: type,
      title: title,
      description: json['description'] is String
          ? json['description'] as String
          : null,
      periodDetails: json['periodDetails'] is Map<String, dynamic>
          ? PeriodNotificationDetails.fromJson(
              json['periodDetails'] as Map<String, dynamic>,
            )
          : null,
      createdAt: createdAt,
    );
  }
}
