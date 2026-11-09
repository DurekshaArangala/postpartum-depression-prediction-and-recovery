import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/liyaa_theme.dart';
import 'widgets/phone_frame.dart';

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
        theme: liyaaTheme(),
        builder: (context, child) => PhoneFrame(child: child!),
        home: const SplashScreen(),
      ),
    );
  }
}