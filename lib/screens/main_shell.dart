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
    Icons.bar_chart_rounded,
    Icons.spa_rounded,
    Icons.person_rounded,
  ];

  static const _labels = ['Home', 'Check-in', 'Progress', 'Support', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiyaaColors.bgBottom,
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LiyaaColors.navBar,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x33F695C5),
              blurRadius: 30,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 76,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < _icons.length; i++)
                  Semantics(
                    button: true,
                    selected: index == i,
                    label: _labels[i],
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => index = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: index == i ? 16 : 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient:
                              index == i ? LiyaaColors.pinkGradient : null,
                          boxShadow: index == i
                              ? const [
                                  BoxShadow(
                                    color: LiyaaColors.glow,
                                    blurRadius: 16,
                                    offset: Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icons[i],
                              size: 22,
                              color: index == i
                                  ? LiyaaColors.dark
                                  : LiyaaColors.inkSoft,
                            ),
                            if (index == i) ...[
                              const SizedBox(width: 6),
                              Text(
                                _labels[i],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: LiyaaColors.dark,
                                ),
                              ),
                            ],
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