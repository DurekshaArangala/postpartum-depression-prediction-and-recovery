import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'assessment_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final name = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void _continue() {
    final state = AppScope.of(context);
    final typed = name.text.trim();
    state.register(typed.isEmpty ? 'Friend' : typed);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            state.assessed ? const MainShell() : const AssessmentScreen(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Log in'),
      body: PageBody(
        children: [
          const FadeIn(child: LiyaaImage('mom_baby_right.jpg', height: 240)),
          const ScreenTitle(
            'Welcome back.\nLog in to continue.',
            subtitle: 'It is good to see you.',
          ),
          TextField(
            controller: name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _continue(),
            decoration: const InputDecoration(
              labelText: 'Your name (demo login)',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const Text(
            'No password is needed in this frontend-only prototype.',
            style: TextStyle(fontSize: 13, color: LiyaaColors.inkSoft),
          ),
          PillAction(label: 'Continue', onTap: _continue),
        ],
      ),
    );
  }
}