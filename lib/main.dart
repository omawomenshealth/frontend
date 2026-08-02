import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/constants/color_constants.dart';
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
import 'views/profile/view/privacy_center_view.dart';
import 'views/profile/viewmodel/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const configuredApiUrl = String.fromEnvironment('OMA_API_BASE_URL');
  if (kReleaseMode && !configuredApiUrl.startsWith('https://')) {
    throw StateError(
      'Release builds require an HTTPS OMA_API_BASE_URL dart-define.',
    );
  }
  ApiService.customBaseUrl = configuredApiUrl;

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
  // Son kanama kaydından sonra gün değişmiş olabilir. Sağlayıcılar ve ekranlar
  // oluşturulmadan önce tamamlanan dönemi ortalamaya dahil et.
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

class MyApp extends StatefulWidget {
  final LocalStorageService storage;
  final NotificationService? notificationService;

  const MyApp({super.key, required this.storage, this.notificationService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _homeShellKey = GlobalKey<_HomeShellState>();
  StreamSubscription<String>? _insightNotificationSubscription;

  @override
  void initState() {
    super.initState();
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
          create: (_) => DashboardViewModel(widget.storage, reminders),
        ),
        ChangeNotifierProvider(
          create: (_) => InsightsViewModel(widget.storage),
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarViewModel(widget.storage),
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
        localeResolutionCallback: (locale, _) =>
            AppStrings.resolveLocale(locale),
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

/// Ana kabuk — Ana Sayfa, Keşfet, İçgörüler ve Profil arasında geçiş.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _currentIndex = 0;

  bool get isHomePageSelected => _currentIndex == 0;

  void showHomePage() {
    if (_currentIndex == 0) return;
    setState(() => _currentIndex = 0);
  }

  void showInsightsPage() => _selectPage(2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifications = context.read<NotificationService>();
      if (notifications.takePendingInsightSelection() != null) {
        showInsightsPage();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    // Uygulama birkaç gün arka planda kaldıysa devam eden dönem bu sırada
    // tamamlanmış olabilir. Ana ekran ve takvim tahminlerini birlikte yenile.
    context.read<DashboardViewModel>().loadData();
    context.read<CalendarViewModel>().loadData();
  }

  void _selectPage(int index) {
    if (index == 2) {
      context.read<InsightsViewModel>().loadData();
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final phaseIndex = context
        .watch<DashboardViewModel>()
        .periodCalculator
        ?.currentPhaseIndex;
    final activeColor = switch (phaseIndex) {
      0 => AppColors.periodPrimary,
      2 => AppColors.ovulation,
      3 => AppColors.lutealDark,
      _ => AppColors.primary,
    };

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardView(onOpenInsights: () => _selectPage(2)),
          const ArticlesView(),
          InsightsView(
            isActive: _currentIndex == 2,
            onClose: () => _selectPage(0),
          ),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: _currentIndex == 2
          ? null
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 70,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF3C322C,
                            ).withValues(alpha: 0.13),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: BottomNavigationBar(
                        currentIndex: _currentIndex,
                        onTap: _selectPage,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: activeColor,
                        unselectedItemColor: AppColors.textSecondary,
                        iconSize: 20,
                        selectedFontSize: 10.5,
                        unselectedFontSize: 10.5,
                        selectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.home_outlined),
                            activeIcon: const Icon(Icons.home_rounded),
                            label: AppStrings.home,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.explore_outlined),
                            activeIcon: const Icon(Icons.explore_rounded),
                            label: AppStrings.explore,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.auto_awesome_outlined),
                            activeIcon: const Icon(Icons.auto_awesome_rounded),
                            label: AppStrings.insights,
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.circle_outlined),
                            activeIcon: const Icon(Icons.circle),
                            label: AppStrings.profile,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Semantics(
                    button: true,
                    label: AppStrings.appName,
                    child: InkWell(
                      onTap: () => _showOmaSheet(context, activeColor),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF3C322C,
                              ).withValues(alpha: 0.13),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomPaint(
                            size: const Size.square(35),
                            painter: _SunburstPainter(color: activeColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showOmaSheet(BuildContext context, Color accent) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomPaint(
                    size: const Size.square(34),
                    painter: _SunburstPainter(color: accent),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'CormorantGaramond',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                AppStrings.omaTalkPrompt,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  for (final label in [
                    AppStrings.energyLevel,
                    AppStrings.sleep,
                    AppStrings.mood,
                    AppStrings.nutrition,
                  ])
                    ActionChip(
                      label: Text(label),
                      onPressed: () => Navigator.pop(context),
                      side: BorderSide(color: accent.withValues(alpha: 0.3)),
                      backgroundColor: Color.lerp(accent, Colors.white, 0.9),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SunburstPainter extends CustomPainter {
  final Color color;

  const _SunburstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2;
    final inner = outer * 0.42;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 24; index++) {
      final angle = index * math.pi * 2 / 24;
      canvas.drawLine(
        Offset(
          center.dx + inner * math.cos(angle),
          center.dy + inner * math.sin(angle),
        ),
        Offset(
          center.dx + outer * math.cos(angle),
          center.dy + outer * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SunburstPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
