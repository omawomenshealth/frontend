import 'dart:convert';

import 'medication_identity_model.dart';

void _rejectUnknownFields(
  Map<String, dynamic> json,
  Set<String> allowed,
  String model,
) {
  final unknown = json.keys.where((key) => !allowed.contains(key)).toList();
  if (unknown.isNotEmpty) {
    throw FormatException(
      '$model desteklenmeyen alan içeriyor: ${unknown.join(', ')}',
    );
  }
}

const _clockFields = {'hour', 'minute'};
const _planFields = {
  'id',
  'itemType',
  ...MedicationIdentity.jsonFields,
  'dosage',
  'times',
  'frequency',
  'weekdays',
  'startDate',
  'endDate',
  'enabled',
  'createdAt',
  'updatedAt',
};
const _doseRecordFields = {
  'id',
  'planId',
  'itemType',
  ...MedicationIdentity.jsonFields,
  'dosage',
  'scheduledAt',
  'notificationScheduled',
  'notificationScheduledAt',
  'status',
  'respondedAt',
};

enum MedicationPlanItemType { medication, supplement, skincare }

enum MedicationPlanFrequency { everyDay, selectedWeekdays }

enum MedicationDoseResponseStatus { taken, skipped }

/// Saat ve dakikayı tarihten bağımsız, serileştirilebilir biçimde tutar.
class ReminderClockTime {
  final int hour;
  final int minute;

  const ReminderClockTime({required this.hour, required this.minute})
    : assert(hour >= 0 && hour <= 23),
      assert(minute >= 0 && minute <= 59);

  Map<String, dynamic> toJson() => {'hour': hour, 'minute': minute};

  factory ReminderClockTime.fromJson(Map<String, dynamic> json) {
    _rejectUnknownFields(json, _clockFields, 'ReminderClockTime');
    return ReminderClockTime(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }
}

/// Kullanıcının oluşturduğu ilaç/takviye hatırlatıcı planı.
class MedicationReminderPlan {
  final String id;
  final MedicationPlanItemType itemType;
  final String displayName;
  final String mainGroup;
  final String? activeIngredient;
  final String dosage;
  final List<ReminderClockTime> times;
  final MedicationPlanFrequency frequency;

  /// DateTime.weekday biçiminde 1 (Pazartesi) - 7 (Pazar).
  final Set<int> weekdays;
  final DateTime startDate;
  final DateTime? endDate;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicationReminderPlan({
    required this.id,
    required this.itemType,
    required this.displayName,
    required this.mainGroup,
    required this.activeIngredient,
    required this.dosage,
    required List<ReminderClockTime> times,
    required this.frequency,
    required Set<int> weekdays,
    required this.startDate,
    required this.endDate,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(times.isNotEmpty),
       times = List.unmodifiable(_normalizeTimes(times)),
       weekdays = Set.unmodifiable(weekdays);

  bool isScheduledOn(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final firstDay = DateTime(startDate.year, startDate.month, startDate.day);
    final lastDay = endDate == null
        ? null
        : DateTime(endDate!.year, endDate!.month, endDate!.day);

    if (!enabled || day.isBefore(firstDay)) return false;
    if (lastDay != null && day.isAfter(lastDay)) return false;
    return frequency == MedicationPlanFrequency.everyDay ||
        weekdays.contains(day.weekday);
  }

  MedicationReminderPlan copyWith({
    String? displayName,
    String? mainGroup,
    String? activeIngredient,
    String? dosage,
    List<ReminderClockTime>? times,
    MedicationPlanFrequency? frequency,
    Set<int>? weekdays,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    bool? enabled,
    DateTime? updatedAt,
  }) {
    return MedicationReminderPlan(
      id: id,
      itemType: itemType,
      displayName: displayName ?? this.displayName,
      mainGroup: mainGroup ?? this.mainGroup,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      dosage: dosage ?? this.dosage,
      times: times ?? this.times,
      frequency: frequency ?? this.frequency,
      weekdays: weekdays ?? this.weekdays,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemType': itemType.name,
    'displayName': displayName,
    'mainGroup': mainGroup,
    'activeIngredient': activeIngredient,
    'dosage': dosage,
    'times': times.map((value) => value.toJson()).toList(),
    'frequency': frequency.name,
    'weekdays': weekdays.toList()..sort(),
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'enabled': enabled,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory MedicationReminderPlan.fromJson(Map<String, dynamic> json) {
    _rejectUnknownFields(json, _planFields, 'MedicationReminderPlan');
    return MedicationReminderPlan(
      id: json['id'] as String,
      itemType: MedicationPlanItemType.values.byName(
        json['itemType'] as String,
      ),
      displayName: json['displayName'] as String,
      mainGroup: json['mainGroup'] as String,
      activeIngredient: json['activeIngredient'] as String?,
      dosage: json['dosage'] as String,
      times: (json['times'] as List)
          .map(
            (value) => ReminderClockTime.fromJson(
              Map<String, dynamic>.from(value as Map),
            ),
          )
          .toList(),
      frequency: MedicationPlanFrequency.values.byName(
        json['frequency'] as String,
      ),
      weekdays: Set<int>.from(json['weekdays'] as List? ?? const <int>[]),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      enabled: json['enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static List<ReminderClockTime> _normalizeTimes(
    Iterable<ReminderClockTime> values,
  ) {
    final unique = <int, ReminderClockTime>{};
    for (final value in values) {
      unique[value.hour * 60 + value.minute] = value;
    }
    final sorted = unique.values.toList()
      ..sort((left, right) {
        final leftMinutes = left.hour * 60 + left.minute;
        final rightMinutes = right.hour * 60 + right.minute;
        return leftMinutes.compareTo(rightMinutes);
      });
    return sorted.take(12).toList(growable: false);
  }
}

/// Planlanan tek bir dozun kalıcı takip kaydı.
///
/// [notificationScheduled] bildirimin işletim sistemine planlandığını söyler;
/// teslim edildiği anlamına gelmez. [status] yalnızca kullanıcı yanıt verince
/// `taken` veya `skipped` olur. Yanıtsız geçmiş kayıtlar arayüzde
/// "cevaplanmadı" olarak türetilir.
class MedicationDoseRecord {
  final String id;
  final String planId;
  final MedicationPlanItemType itemType;
  final String displayName;
  final String mainGroup;
  final String? activeIngredient;
  final String dosage;
  final DateTime scheduledAt;
  final bool notificationScheduled;
  final DateTime? notificationScheduledAt;
  final MedicationDoseResponseStatus? status;
  final DateTime? respondedAt;

  const MedicationDoseRecord({
    required this.id,
    required this.planId,
    required this.itemType,
    required this.displayName,
    required this.mainGroup,
    required this.activeIngredient,
    required this.dosage,
    required this.scheduledAt,
    required this.notificationScheduled,
    required this.notificationScheduledAt,
    required this.status,
    required this.respondedAt,
  });

  MedicationDoseRecord copyWith({
    bool? notificationScheduled,
    DateTime? notificationScheduledAt,
    MedicationDoseResponseStatus? status,
    DateTime? respondedAt,
  }) {
    return MedicationDoseRecord(
      id: id,
      planId: planId,
      itemType: itemType,
      displayName: displayName,
      mainGroup: mainGroup,
      activeIngredient: activeIngredient,
      dosage: dosage,
      scheduledAt: scheduledAt,
      notificationScheduled:
          notificationScheduled ?? this.notificationScheduled,
      notificationScheduledAt:
          notificationScheduledAt ?? this.notificationScheduledAt,
      status: status ?? this.status,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  factory MedicationDoseRecord.fromPlannedDose(
    PlannedMedicationDose dose, {
    required bool notificationScheduled,
    DateTime? notificationScheduledAt,
  }) {
    return MedicationDoseRecord(
      id: dose.id,
      planId: dose.plan.id,
      itemType: dose.plan.itemType,
      displayName: dose.plan.displayName,
      mainGroup: dose.plan.mainGroup,
      activeIngredient: dose.plan.activeIngredient,
      dosage: dose.plan.dosage,
      scheduledAt: dose.scheduledAt,
      notificationScheduled: notificationScheduled,
      notificationScheduledAt: notificationScheduledAt,
      status: null,
      respondedAt: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'planId': planId,
    'itemType': itemType.name,
    'displayName': displayName,
    'mainGroup': mainGroup,
    'activeIngredient': activeIngredient,
    'dosage': dosage,
    'scheduledAt': scheduledAt.toIso8601String(),
    'notificationScheduled': notificationScheduled,
    'notificationScheduledAt': notificationScheduledAt?.toIso8601String(),
    'status': status?.name,
    'respondedAt': respondedAt?.toIso8601String(),
  };

  factory MedicationDoseRecord.fromJson(Map<String, dynamic> json) {
    _rejectUnknownFields(json, _doseRecordFields, 'MedicationDoseRecord');
    return MedicationDoseRecord(
      id: json['id'] as String,
      planId: json['planId'] as String,
      itemType: MedicationPlanItemType.values.byName(
        json['itemType'] as String,
      ),
      displayName: json['displayName'] as String,
      mainGroup: json['mainGroup'] as String,
      activeIngredient: json['activeIngredient'] as String?,
      dosage: json['dosage'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      notificationScheduled: json['notificationScheduled'] as bool? ?? false,
      notificationScheduledAt: json['notificationScheduledAt'] == null
          ? null
          : DateTime.parse(json['notificationScheduledAt'] as String),
      status: json['status'] == null
          ? null
          : MedicationDoseResponseStatus.values.byName(
              json['status'] as String,
            ),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );
  }
}

/// Bir plandan hesaplanan, değiştirilemez planlı doz örneği.
class PlannedMedicationDose {
  final String id;
  final MedicationReminderPlan plan;
  final DateTime scheduledAt;

  const PlannedMedicationDose({
    required this.id,
    required this.plan,
    required this.scheduledAt,
  });
}

/// Planlardan doz örnekleri üretir. Bildirim ve arayüz aynı hesabı kullanır.
class MedicationScheduleCalculator {
  const MedicationScheduleCalculator._();

  /// Gelecekteki en yakın [limit] dozu üretir. Uzak bir başlangıç tarihi olan
  /// planların da kurulabilmesi için en çok [maxSearchDays] gün ileri bakar.
  static List<PlannedMedicationDose> upcoming({
    required Iterable<MedicationReminderPlan> plans,
    required DateTime from,
    required int limit,
    int maxSearchDays = 3660,
  }) {
    if (limit <= 0) return const [];
    final planList = plans.toList(growable: false);
    final doses = <PlannedMedicationDose>[];
    var day = DateTime(from.year, from.month, from.day);

    for (var offset = 0; offset <= maxSearchDays; offset++) {
      for (final plan in planList) {
        if (!plan.isScheduledOn(day)) continue;
        for (final time in plan.times) {
          final scheduledAt = DateTime(
            day.year,
            day.month,
            day.day,
            time.hour,
            time.minute,
          );
          if (scheduledAt.isBefore(from)) continue;
          doses.add(
            PlannedMedicationDose(
              id: doseId(plan.id, scheduledAt),
              plan: plan,
              scheduledAt: scheduledAt,
            ),
          );
        }
      }
      if (doses.length >= limit) break;
      day = day.add(const Duration(days: 1));
    }

    doses.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return doses.take(limit).toList(growable: false);
  }

  static List<PlannedMedicationDose> between({
    required Iterable<MedicationReminderPlan> plans,
    required DateTime from,
    required DateTime through,
  }) {
    if (through.isBefore(from)) return const [];

    final doses = <PlannedMedicationDose>[];
    var day = DateTime(from.year, from.month, from.day);
    final lastDay = DateTime(through.year, through.month, through.day);

    while (!day.isAfter(lastDay)) {
      for (final plan in plans) {
        if (!plan.isScheduledOn(day)) continue;
        for (final time in plan.times) {
          final scheduledAt = DateTime(
            day.year,
            day.month,
            day.day,
            time.hour,
            time.minute,
          );
          if (scheduledAt.isBefore(from) || scheduledAt.isAfter(through)) {
            continue;
          }
          doses.add(
            PlannedMedicationDose(
              id: doseId(plan.id, scheduledAt),
              plan: plan,
              scheduledAt: scheduledAt,
            ),
          );
        }
      }
      day = day.add(const Duration(days: 1));
    }

    doses.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return doses;
  }

  static String doseId(String planId, DateTime scheduledAt) =>
      '$planId@${scheduledAt.toIso8601String()}';
}
