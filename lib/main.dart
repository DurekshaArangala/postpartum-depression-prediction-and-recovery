import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'state/app_state.dart';
import 'theme/liyaa_theme.dart';

void main() {
  runApp(const LiyaaApp());
}

class LiyaaApp extends StatefulWidget {
  const LiyaaApp({super.key});

  @override
  State<LiyaaApp> createState() => _LiyaaAppState();
}

class _LiyaaAppState extends State<LiyaaApp> {
  final state = AppState();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'Liyaa',
        debugShowCheckedModeBanner: false,
        theme: LiyaaTheme.dark,
        home: const WelcomeScreen(),
      ),
    );
  }
}