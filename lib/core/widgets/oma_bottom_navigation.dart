import 'package:flutter/material.dart';

import 'oma_theme.dart';
import 'oma_sunburst.dart';

class OmaBottomNavigation extends StatelessWidget {
  const OmaBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
    required this.onOmaTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;
  final VoidCallback onOmaTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                color: OmaColors.card.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(30),
                boxShadow: OmaShadows.soft,
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTap,
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: activeColor,
                unselectedItemColor: OmaColors.muted,
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
                  color: OmaColors.card.withValues(alpha: 0.96),
                  shape: BoxShape.circle,
                  boxShadow: OmaShadows.soft,
                ),
                child: const Center(
                  child: OmaSunburst(size: 34),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}