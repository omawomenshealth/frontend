import 'package:flutter/material.dart';

import '../../core/theme/oma_theme.dart';
import '../../core/widgets/oma_sunburst.dart';

class OmaBottomNavigation extends StatelessWidget {
  const OmaBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onOmaTap,
    required this.activeColor,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onOmaTap;
  final Color activeColor;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;
    final surfaceColor =
        Color.lerp(theme.surface, activeColor, 0.06) ?? theme.surface;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, OmaSpacing.none, 14, OmaSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              height: 70,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: surfaceColor.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(30),
                boxShadow: context.omaTheme.softShadow,
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTap,
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: activeColor,
                unselectedItemColor: theme.muted,
                iconSize: 20,
                selectedFontSize: 10.5,
                unselectedFontSize: 10.5,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                items: items,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Semantics(
            button: true,
            child: InkWell(
              onTap: onOmaTap,
              customBorder: const CircleBorder(),
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: surfaceColor.withValues(alpha: 0.96),
                  shape: BoxShape.circle,
                  boxShadow: context.omaTheme.softShadow,
                ),
                child: Center(child: OmaSunburst(size: 34, color: activeColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
