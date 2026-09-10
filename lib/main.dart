import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'application/cycle_prediction/cycle_prediction_coordinator.dart';
import 'core/config/app_environment.dart';
import 'core/constants/app_strings.dart';
import 'core/localization/catalog_localizer.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_time.dart';
import 'data/services/api_service.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/premium_purchase_service.dart';
import 'data/services/sync_service.dart';
import 'localization/generated/strings.g.dart';
import 'shell/home_shell.dart';
import 'views/auth/view/auth_view.dart';
import 'views/auth/viewmodel/auth_view_model.dart';
import 'views/calendar/viewmodel/calendar_view_model.dart';
import 'views/dashboard/viewmodel/dashboard_view_model.dart';
import 'views/insights/viewmodel/insights_view_model.dart';
import 'views/onboarding/view/onboarding_view.dart';
import 'views/onboarding/viewmodel/onboarding_view_model.dart';
import 'views/profile/view/privacy_center_view.dart';
import 'views/profile/viewmodel/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocaleSettings.useDeviceLocale();
  await CatalogLocalizer.initialize();

  try {
    await AppEnvironment.load();
  } catch (error) {
    debugPrint('AppEnvironment başlatma uyarısı: $error');
  }

  await Future.wait([
    initializeDateFormatting('tr_TR', null),
    initializeDateFormatting('en_US', null),
  ]);

  final storage = LocalStorageService();
  await storage.init();
  await AppTime.init(
    initialOffsetDays: storage.virtualDaysOffset,
    persistOffset: storage.setVirtualDaysOffset,
  );

  await storage.refreshCycleStatistics();
  final notificationService = NotificationService();
  final reminderPlans = storage.loadMedicationReminderPlans();
  var scheduledDoseIds = <String>{};

  try {
    await notificationService.init();
    final result = await notificationService.rescheduleMedicationReminders(
      plans: reminderPlans,
    );
    scheduledDoseIds = result.scheduledDoses.map((dose) => dose.id).toSet();
    final settings = storage.loadSettings();
    if (settings != null) {
      await notificationService.rescheduleFertilityInsights(settings: settings);
    }
  } catch (error) {
    debugPrint('Hatırlatıcılar başlangıçta zamanlanamadı: $error');
  }

  await storage.refreshMedicationDoseRecords(
    plans: reminderPlans,
    notificationScheduledDoseIds: scheduledDoseIds,
  );

  runApp(
    TranslationProvider(
      child: MyApp(storage: storage, notificationService: notificationService),
    ),
  );
}

class MyApp extends StatefulWidget {
  final LocalStorageService storage;
  final NotificationService? notificationService;

  const MyApp({super.key, required this.storage, this.notificationService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _homeShellKey = GlobalKey<HomeShellState>();
  StreamSubscription<String>? _insightNotificationSubscription;
  late final CyclePredictionCoordinator _cyclePredictions;

  @override
  void initState() {
    super.initState();
    _cyclePredictions = CyclePredictionCoordinator(widget.storage);
    WidgetsBinding.instance.addObserver(this);
    _insightNotificationSubscription = widget
        .notificationService
        ?.insightSelections
        .listen((_) => _showInsightsFromNotification());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _insightNotificationSubscription?.cancel();
    _cyclePredictions.dispose();
    super.dispose();
  }

  void _showInsightsFromNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = _navigatorKey.currentState;
      final homeShell = _homeShellKey.currentState;
      if (navigator == null || homeShell == null || !homeShell.mounted) return;
      widget.notificationService?.takePendingInsightSelection();
      navigator.popUntil(
        (route) => route.settings.name == '/home' || route.isFirst,
      );
      homeShell.showInsightsPage();
    });
  }

  @override
  Future<bool> didPopRoute() async {
    final navigator = _navigatorKey.currentState;
    final homeShell = _homeShellKey.currentState;
    if (navigator == null || homeShell == null || !homeShell.mounted) {
      return false;
    }

    final homeRouteIsCurrent =
        ModalRoute.of(homeShell.context)?.isCurrent ?? false;
    if (homeRouteIsCurrent && homeShell.isHomePageSelected) {
      return false;
    }

    navigator.popUntil(
      (route) => route.settings.name == '/home' || route.isFirst,
    );
    homeShell.showHomePage();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(widget.storage);
    final reminders = widget.notificationService ?? NotificationService();
    final syncService = SyncService(widget.storage, apiService, reminders);

    return MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: widget.storage),
        Provider<NotificationService>.value(value: reminders),
        Provider<ApiService>.value(value: apiService),
        Provider<SyncService>.value(value: syncService),
        ChangeNotifierProvider<CyclePredictionCoordinator>.value(
          value: _cyclePredictions,
        ),
        ChangeNotifierProvider(
          create: (_) =>
              PremiumPurchaseService(widget.storage, apiService)..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(widget.storage, apiService, syncService),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(widget.storage, syncService),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            widget.storage,
            reminders,
            _cyclePredictions,
            syncService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InsightsViewModel(widget.storage),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CalendarViewModel(widget.storage, _cyclePredictions, syncService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(
            widget.storage,
            syncService,
            apiService,
            reminders,
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        onGenerateTitle: (_) => AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          AppStrings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppStrings.supportedLocales,
        localeResolutionCallback: (locale, _) {
          final resolved = AppStrings.resolveLocale(locale);
          unawaited(LocaleSettings.setLocaleRaw(resolved.languageCode));
          return resolved;
        },
        initialRoute: widget.storage.isOnboardingComplete ? '/home' : '/auth',
        routes: {
          '/auth': (context) => const AuthView(),
          '/onboarding': (context) => const OnboardingView(),
          '/home': (context) => HomeShell(key: _homeShellKey),
          '/privacy': (context) => const PrivacyCenterView(),
        },
      ),
    );
  }
}