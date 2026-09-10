import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/constants/color_constants.dart';
import '../data/services/notification_service.dart';
import '../views/articles/view/articles_view.dart';
import '../views/calendar/viewmodel/calendar_view_model.dart';
import '../views/dashboard/view/dashboard_view.dart';
import '../views/dashboard/viewmodel/dashboard_view_model.dart';
import '../views/insights/view/insights_view.dart';
import '../views/insights/viewmodel/insights_view_model.dart';
import '../views/profile/view/profile_view.dart';
import 'widgets/oma_bottom_navigation.dart';
import 'widgets/oma_chat_preview.dart';


class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
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
      bottomNavigationBar: _buildBottomNavigation(activeColor),
    );
  }

  List<BottomNavigationBarItem> get _navigationItems => [
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
      ];

  Widget? _buildBottomNavigation(Color activeColor) {
    if (_currentIndex == 2) return null;

    return OmaBottomNavigation(
      currentIndex: _currentIndex,
      onTap: _selectPage,
      activeColor: activeColor,
      onOmaTap: () => _showOmaSheet(context, activeColor),
      items: _navigationItems,
    );
  }

  void _showOmaSheet(BuildContext context, Color accent) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => OmaTalkPreview(
        accent: accent,
      ),
    );
  }
}