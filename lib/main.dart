
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/liyaa_theme.dart';
import 'widgets/phone_frame.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Read configuration from .env.json
  const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  const supabaseKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  // Temporary checks (do not print actual credentials)
  debugPrint('Supabase URL loaded: ${supabaseUrl.isNotEmpty}');
  debugPrint('Supabase key loaded: ${supabaseKey.isNotEmpty}');

  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    throw StateError(
      'Supabase URL or publishable key is missing.',
    );
  }

  // Initialize Supabase before starting Flutter
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseKey,
  );

  debugPrint('Supabase initialized successfully!');

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
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'Liyaa',
        debugShowCheckedModeBanner: false,
        theme: liyaaTheme(),
        builder: (context, child) =>
            PhoneFrame(child: child!),
        home: const SplashScreen(),
      ),
    );
  }
}
