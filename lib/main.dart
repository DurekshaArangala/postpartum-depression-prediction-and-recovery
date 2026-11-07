import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'screens/welcome_screen.dart';

void main() { runApp(const LiyaaApp()); }
class LiyaaApp extends StatefulWidget {
  const LiyaaApp({super.key});
  @override State<LiyaaApp> createState() => _LiyaaAppState();
}
class _LiyaaAppState extends State<LiyaaApp> {
  final state = AppState();
  @override Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Liyaa', debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF9F6FC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8064B0)),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF9F6FC), centerTitle: true),
        inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
      ), home: const WelcomeScreen(),
    ),
  );
}
