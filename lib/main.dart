import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_time.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/api_service.dart';
import 'data/services/premium_purchase_service.dart';
import 'data/services/sync_service.dart';
import 'views/auth/view/auth_view.dart';
import 'views/auth/viewmodel/auth_view_model.dart';
import 'views/onboarding/view/onboarding_view.dart';
import 'views/onboarding/viewmodel/onboarding_view_model.dart';
import 'views/dashboard/view/dashboard_view.dart';
import 'views/dashboard/viewmodel/dashboard_view_model.dart';
import 'views/insights/view/insights_view.dart';
import 'views/insights/viewmodel/insights_view_model.dart';
import 'views/calendar/viewmodel/calendar_view_model.dart';
import 'views/articles/view/articles_view.dart';
import 'views/profile/view/profile_view.dart';
import 'views/profile/viewmodel/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Telefonun yerel sunucuya bağlanabilmesi için yerel IP adresi tanımlandı:
  ApiService.customBaseUrl = 'http://192.168.1.13:3000';

  await Future.wait([
    initializeDateFormatting('tr_TR', null),
    initializeDateFormatting('en_US', null),
  ]);
  await AppTime.init();

  final storage = LocalStorageService();
  await storage.init();
  final notificationService = NotificationService();
  final reminderPlans = storage.loadMedicationReminderPlans();
  var scheduledDoseIds = <String>{};
  try {
    await notificationService.init();
    final result = await notificationService.rescheduleMedicationReminders(
      plans: reminderPlans,
    );
    scheduledDoseIds = result.scheduledDoses.map((dose) => dose.id).toSet();
  } catch (error) {
    debugPrint('Hatırlatıcılar başlangıçta zamanlanamadı: $error');
  }
  await storage.refreshMedicationDoseRecords(
    plans: reminderPlans,
    notificationScheduledDoseIds: scheduledDoseIds,
  );

  // Not: Test için verileri sıfırlamak isterseniz aşağıdaki satırı açın.
  // await storage.clearAll();

  runApp(MyApp(storage: storage, notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final LocalStorageService storage;
  final NotificationService? notificationService;

  const MyApp({super.key, required this.storage, this.notificationService});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(storage);
    final syncService = SyncService(storage, apiService);
    final reminders = notificationService ?? NotificationService();

    return MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: storage),
        Provider<NotificationService>.value(value: reminders),
        Provider<ApiService>.value(value: apiService),
        Provider<SyncService>.value(value: syncService),
        ChangeNotifierProvider(
          create: (_) =>
              PremiumPurchaseService(storage, apiService)..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(storage, apiService, syncService),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(storage, syncService),
        ),
        ChangeNotifierProvider(create: (_) => DashboardViewModel(storage)),
        ChangeNotifierProvider(create: (_) => InsightsViewModel(storage)),
        ChangeNotifierProvider(create: (_) => CalendarViewModel(storage)),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(storage, syncService),
        ),
      ],
      child: MaterialApp(
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
        localeResolutionCallback: (locale, _) =>
            AppStrings.resolveLocale(locale),
        initialRoute: storage.isOnboardingComplete ? '/home' : '/auth',
        routes: {
          '/auth': (context) => const AuthView(),
          '/onboarding': (context) => const OnboardingView(),
          '/home': (context) => const HomeShell(),
        },
      ),
    );
  }
}

/// Ana kabuk — Ana Sayfa, İçgörüler, Yazılar ve Profil arasında geçiş.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  void _selectPage(int index) {
    if (index == 1) {
      context.read<InsightsViewModel>().loadData();
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardView(onOpenInsights: () => _selectPage(1)),
          const InsightsView(),
          const ArticlesView(),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _selectPage,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_rounded),
              activeIcon: const Icon(Icons.dashboard_rounded),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insights_outlined),
              activeIcon: const Icon(Icons.insights_rounded),
              label: AppStrings.insights,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.article_rounded),
              activeIcon: const Icon(Icons.article_rounded),
              label: AppStrings.articles,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }
}
