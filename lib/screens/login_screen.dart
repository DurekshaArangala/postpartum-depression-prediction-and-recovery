import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/ui.dart';
import 'assessment_screen.dart';
import 'main_shell.dart';
class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
 final name = TextEditingController();
 @override void dispose() { name.dispose(); super.dispose(); }
 @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Welcome back')), body: PageBody(children: [
 const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-woman-holding-baby-in-her-arms-happy-mother-s-day-flat-illustration-vector.jpg'),
 const ScreenTitle('Hello again 💜'),
 TextField(controller: name, decoration: const InputDecoration(labelText: 'Your name (demo login)')),
 const Text('No password is needed in this frontend-only prototype.'),
 FilledButton(onPressed: () { final state=AppScope.of(context); state.register(name.text); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => state.assessed ? const MainShell() : const AssessmentScreen()), (_) => false); }, child: const Text('Continue')),
 ]));
}
