import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiyaaScaffold(
      body: PageBody(
        children: [
          const SizedBox(height: 4),
          const FadeIn(
            child: LiyaaImage(
              'mom_baby_sling.jpg',
              height: 360,
              overlay: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Liyaa',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: LiyaaColors.dark,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'You matter too.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: LiyaaColors.plum,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Eyebrow('Welcome'),
          const ScreenTitle(
            'A gentle space for your motherhood journey.',
            subtitle:
                'Check in with how you feel, one day at a time, with support that is always here.',
          ),
          PillAction(
            label: 'Get started',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text('I already have an account'),
            ),
          ),
          const Text(
            'Frontend demo • Not a medical diagnosis',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: LiyaaColors.inkSoft),
          ),
        ],
      ),
    );
  }
}