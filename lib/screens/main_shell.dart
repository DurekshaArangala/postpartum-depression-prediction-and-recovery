import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import 'checkin_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'support_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  static const _pages = [
    HomeScreen(),
    CheckInScreen(),
    ProgressScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];

  static const _icons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.insights_rounded,
    Icons.spa_rounded,
    Icons.person_rounded,
  ];

  static const _labels = ['Home', 'Check-in', 'Progress', 'Support', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A3B1F3D),
              blurRadius: 24,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < _icons.length; i++)
                  Semantics(
                    button: true,
                    selected: index == i,
                    label: _labels[i],
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => index = i),
                      child: SizedBox(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _icons[i],
                              size: 28,
                              color: index == i
                                  ? LiyaaColors.plum
                                  : LiyaaColors.pinkLight,
                            ),
                            const SizedBox(height: 5),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == i
                                    ? LiyaaColors.pink
                                    : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}