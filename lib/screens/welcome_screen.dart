import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiyaaColors.lavender,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 26),
              const Text(
                'It’s okay not\nto be okay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Liyaa is here with you, one gentle day at a time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.35,
                  color: Color(0xE6FFFFFF),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 290,
                          height: 290,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x2EFFFFFF),
                          ),
                        ),
                      ),
                    ),
                    const Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: LiyaaArt(
                          'ill_welcome.png',
                          fallbackIcon: Icons.favorite_rounded,
                          iconSize: 96,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text('Let us help you'),
              ),
              const SizedBox(height: 4),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text('I already have an account'),
              ),
              const Text(
                'Frontend demo  •  Not a medical diagnosis',
                style: TextStyle(fontSize: 13, color: Color(0xCCFFFFFF)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}