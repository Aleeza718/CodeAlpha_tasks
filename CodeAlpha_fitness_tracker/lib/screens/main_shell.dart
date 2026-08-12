import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../animations/page_transitions.dart';
import '../providers/app_provider.dart';
import '../screens/add_activity_screen.dart';
import '../screens/activity_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/floating_bottom_nav.dart';

/// Main shell with bottom navigation and screen switching.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    ActivityScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: provider.currentNavIndex,
            children: _screens,
          ),
          // false (the default) so Scaffold reserves the nav bar's
          // full height out of the body's own layout area — content
          // can then never scroll to a position behind the nav, at
          // rest or mid-scroll. `true` let content draw full-screen
          // underneath the (visually) floating nav, which is why the
          // Units row on Profile could pass behind it while scrolling.
          // The nav's rounded, floating card look is unchanged — this
          // only changes what content is allowed to occupy that area.
          extendBody: false,
          bottomNavigationBar: FloatingBottomNav(
            currentIndex: provider.currentNavIndex,
            onTap: provider.setNavIndex,
            onFabTap: () async {
              await Navigator.of(context).push(
                FadeSlidePageRoute(page: const AddActivityScreen()),
              );
            },
          ),
        );
      },
    );
  }
}