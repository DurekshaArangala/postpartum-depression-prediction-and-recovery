import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'assessment_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void _continue() {
    final typed = name.text.trim();
    AppScope.of(context).register(typed.isEmpty ? 'Friend' : typed);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AssessmentScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Create account'),
      body: PageBody(
        children: [
          const FadeIn(child: LiyaaImage('mom_baby_dark.jpg', height: 230)),
          const ScreenTitle(
            'A little about you.',
            subtitle: 'We would love to know what to call you.',
          ),
          TextField(
            controller: name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _continue(),
            decoration: const InputDecoration(
              labelText: 'What should we call you?',
              prefixIcon: Icon(Icons.favorite_border_rounded),
            ),
          ),
          const SoftCard(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 20, color: LiyaaColors.pink),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Next, we will ask ten short questions about how you have '
                    'felt over the past seven days. It takes about two minutes.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: LiyaaColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PillAction(label: 'Continue to questions', onTap: _continue),
        ],
      ),
    );
  }
}