import 'package:flutter/material.dart';
import '../widgets/ui.dart';
import 'login_screen.dart';
import 'register_screen.dart';
class WelcomeScreen extends StatelessWidget {
 const WelcomeScreen({super.key});
 @override Widget build(BuildContext context) => Scaffold(body: PageBody(children: [
 const SizedBox(height: 26), const Center(child: Text('Liyaa 🌷', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF8064B0)))),
 const Center(child: Text('A gentle space for your motherhood journey', textAlign: TextAlign.center)),
 const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-mom-and-newborn-baby-family-concept-health-happy-mother-s-day-flat-illustration-vector.jpg', height: 300),
 const Text('Your feelings matter. Take a moment for yourself, one day at a time.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
 FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Get started')),
 OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('I already have an account')),
 const Text('Frontend demo • Not a medical diagnosis', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
 ]));
}
