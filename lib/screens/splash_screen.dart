import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _tagline;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _tagline = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _c.forward();

    Future.delayed(const Duration(milliseconds: 2600), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // soft corner circles, like the pastel backdrop in the design
          Positioned(
            top: -90,
            right: -70,
            child: _Blob(size: 260, color: LiyaaColors.pinkSoft),
          ),
          Positioned(
            top: 60,
            left: -90,
            child: _Blob(size: 170, color: LiyaaColors.tealSoft),
          ),
          Positioned(
            bottom: -110,
            left: -60,
            child: _Blob(size: 300, color: LiyaaColors.lavenderSoft),
          ),
          Positioned(
            bottom: 90,
            right: -60,
            child: _Blob(size: 150, color: LiyaaColors.peach),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: FractionallySizedBox(
                        widthFactor: 0.78,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Text(
                              'Liyaa',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FadeTransition(
                    opacity: _tagline,
                    child: const Text(
                      'You matter too.',
                      style: TextStyle(
                        fontSize: 20,
                        color: LiyaaColors.plumSoft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _tagline,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 90,
                        height: 4,
                        child: LinearProgressIndicator(
                          backgroundColor: LiyaaColors.pinkSoft,
                          valueColor: const AlwaysStoppedAnimation(
                            LiyaaColors.pink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}