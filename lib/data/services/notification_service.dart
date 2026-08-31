import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../../core/constants/app_strings.dart';
import '../../core/utils/period_calculator.dart';
import '../models/medication_reminder_model.dart';
import '../models/user_settings_model.dart';

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
  static const _insightPayloadPrefix = 'oma_insight:';
  static const _channelId = 'oma_medication_reminders_v1';
  static const _insightChannelId = 'oma_personal_insights_v1';
  static const _fertilityInsightIdPrefix = 'fertile_window_focus_';
  static const _maxPendingMedicationNotifications = 50;

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _insightSelections =
      StreamController<String>.broadcast();
  bool _initialized = false;
  String? _pendingInsightSelection;

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  Stream<String> get insightSelections => _insightSelections.stream;

  String? takePendingInsightSelection() {
    final value = _pendingInsightSelection;
    _pendingInsightSelection = null;
    return value;
  }

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

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final launchPayload = launchDetails?.notificationResponse?.payload;
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _captureInsightSelection(launchPayload);
    }
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

  Future<bool> requestInsightPermissions() async {
    if (!isSupported) return false;
    await init();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? true;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  }

  Future<bool> scheduleInsightReady({
    required String insightId,
    DateTime? deliverAt,
  }) async {
    if (!isSupported) return false;
    await init();

    final scheduledAt =
        deliverAt ?? DateTime.now().add(const Duration(seconds: 45));
    final notificationId = _notificationId('insight:$insightId');
    await _plugin.cancel(id: notificationId);
    await _plugin.zonedSchedule(
      id: notificationId,
      title: AppStrings.insightNotificationTitle,
      body: AppStrings.insightNotificationBody,
      scheduledDate: timezone.TZDateTime.from(scheduledAt, timezone.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _insightChannelId,
          AppStrings.insightNotificationChannelName,
          channelDescription: AppStrings.insightNotificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.status,
          visibility: NotificationVisibility.secret,
        ),
        iOS: const DarwinNotificationDetails(
          threadIdentifier: 'oma_personal_insights',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: '$_insightPayloadPrefix$insightId',
    );
    return true;
  }

  /// Hamile kal modunda, içinde bulunulan ve sıradaki verimli pencerenin ilk
  /// gününe birer genel OMA bildirimi planlar. Bildirim gövdesi hassas sağlık
  /// bilgisini kilit ekranına yazmaz; Android tarafında ayrıca `secret`tır.
  Future<int> rescheduleFertilityInsights({
    required UserSettings settings,
    DateTime? now,
  }) async {
    if (!isSupported) return 0;
    await init();
    await _cancelFertilityInsights();
    final lastPeriod = settings.lastPeriodDate;
    if (settings.trackingMode != TrackingMode.tryingToConceive ||
        !settings.notificationsEnabled ||
        lastPeriod == null) {
      return 0;
    }

    final current = now ?? DateTime.now();
    final start = DateTime(current.year, current.month, current.day);
    final calculator = PeriodCalculator(
      lastPeriodDate: lastPeriod,
      cycleLength: settings.averageCycleLength,
      periodLength: settings.averagePeriodLength,
    );
    final windowStarts = <DateTime>[];
    var previousWasFertile = false;
    for (
      var offset = 0;
      offset <= settings.averageCycleLength * 2 && windowStarts.length < 2;
      offset++
    ) {
      final day = start.add(Duration(days: offset));
      final isFertile = calculator.isInFertileWindow(day);
      if (isFertile && !previousWasFertile) windowStarts.add(day);
      previousWasFertile = isFertile;
    }

    var scheduledCount = 0;
    for (final day in windowStarts) {
      var delivery = DateTime(day.year, day.month, day.day, 10);
      if (!delivery.isAfter(current)) {
        delivery = current.add(const Duration(minutes: 2));
      }
      final id = '$_fertilityInsightIdPrefix${day.toIso8601String()}';
      if (await scheduleInsightReady(insightId: id, deliverAt: delivery)) {
        scheduledCount++;
      }
    }
    return scheduledCount;
  }

  Future<void> _cancelFertilityInsights() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final notification in pending) {
      final payload = notification.payload;
      if (payload?.startsWith(
            '$_insightPayloadPrefix$_fertilityInsightIdPrefix',
          ) ??
          false) {
        await _plugin.cancel(id: notification.id);
      }
    }
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
          visibility: NotificationVisibility.secret,
        ),
        iOS: const DarwinNotificationDetails(
          threadIdentifier: 'oma_medication_reminders',
        ),
      );
      await _plugin.zonedSchedule(
        id: _notificationId(dose.id),
        title: AppStrings.privateReminderNotificationTitle,
        body: AppStrings.privateReminderNotificationBody,
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

  void _handleNotificationResponse(NotificationResponse response) {
    _captureInsightSelection(response.payload);
  }

  void _captureInsightSelection(String? payload) {
    if (payload == null || !payload.startsWith(_insightPayloadPrefix)) return;
    final insightId = payload.substring(_insightPayloadPrefix.length);
    if (insightId.isEmpty) return;
    _pendingInsightSelection = insightId;
    _insightSelections.add(insightId);
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
