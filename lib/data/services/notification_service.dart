import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../../core/constants/app_strings.dart';
import '../models/medication_reminder_model.dart';

class ReminderScheduleResult {
  final bool supported;
  final int scheduledCount;
  final List<PlannedMedicationDose> scheduledDoses;

  const ReminderScheduleResult({
    required this.supported,
    required this.scheduledCount,
    required this.scheduledDoses,
  });
}

/// Telefonun yerel bildirim sistemiyle ilaç/takviye planlarını eşitler.
///
/// İşletim sistemleri bildirimin kullanıcıya gerçekten gösterildiğini güvenilir
/// biçimde raporlamaz. Bu servis yalnızca "planlandı" bilgisini üretir;
/// "alındı/atlandı" yanıtı [MedicationDoseRecord] üzerinde ayrıca kaydedilir.
class NotificationService {
  static const _payloadPrefix = 'oma_medication_dose:';
  static const _channelId = 'oma_medication_reminders_v1';
  static const _maxPendingMedicationNotifications = 50;

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (!isSupported || _initialized) return;

    timezone_data.initializeTimeZones();
    final deviceTimezone = await FlutterTimezone.getLocalTimezone();
    timezone.setLocalLocation(timezone.getLocation(deviceTimezone.identifier));

    const android = AndroidInitializationSettings('ic_notification');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  /// Bu çağrı yalnızca kullanıcının "hatırlatıcı kaydet" eyleminden sonra
  /// yapılmalıdır; iOS ve Android 13+ izin ekranını o anda gösterir.
  Future<bool> requestPermissions() async {
    if (!isSupported) return false;
    await init();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission();
      if (granted ?? true) {
        await android?.requestExactAlarmsPermission();
      }
      return granted ?? true;
    }

    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return granted ?? false;
  }

  /// Tüm OMA ilaç/takviye bildirimlerini yeniden üretir.
  ///
  /// iOS'un bekleyen bildirim sınırı nedeniyle gelecekteki en yakın 50 doz
  /// planlanır. Uygulama her açıldığında ve plan değiştiğinde pencere yenilenir.
  Future<ReminderScheduleResult> rescheduleMedicationReminders({
    required Iterable<MedicationReminderPlan> plans,
    DateTime? now,
  }) async {
    if (!isSupported) {
      return const ReminderScheduleResult(
        supported: false,
        scheduledCount: 0,
        scheduledDoses: [],
      );
    }
    await init();
    await _cancelMedicationReminders();

    final start = now ?? DateTime.now();
    var androidScheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final canScheduleExactly = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.canScheduleExactNotifications();
      if (canScheduleExactly ?? false) {
        androidScheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
      }
    }
    final doses = MedicationScheduleCalculator.upcoming(
      plans: plans.where((plan) => plan.enabled),
      from: start,
      limit: _maxPendingMedicationNotifications,
    );

    var count = 0;
    for (final dose in doses) {
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          AppStrings.reminderChannelName,
          channelDescription: AppStrings.reminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(
          threadIdentifier: 'oma_medication_reminders',
        ),
      );
      await _plugin.zonedSchedule(
        id: _notificationId(dose.id),
        title: AppStrings.reminderNotificationTitle(dose.plan.itemName),
        body: AppStrings.reminderNotificationBody(dose.plan.dosage),
        scheduledDate: timezone.TZDateTime.from(
          dose.scheduledAt,
          timezone.local,
        ),
        notificationDetails: details,
        androidScheduleMode: androidScheduleMode,
        payload: '$_payloadPrefix${dose.id}',
      );
      count++;
    }

    return ReminderScheduleResult(
      supported: true,
      scheduledCount: count,
      scheduledDoses: doses,
    );
  }

  Future<void> _cancelMedicationReminders() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final notification in pending) {
      if (notification.payload?.startsWith(_payloadPrefix) ?? false) {
        await _plugin.cancel(id: notification.id);
      }
    }
  }

  /// FNV-1a ile süreçler arasında kararlı, pozitif 31 bit bildirim kimliği.
  int _notificationId(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }

  Future<void> cancelAll() async {
    if (!isSupported) return;
    await init();
    await _plugin.cancelAll();
  }
}
