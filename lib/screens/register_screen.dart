import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/ui.dart';
import 'assessment_screen.dart';
class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState() => _RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen> {
 final name=TextEditingController();
 @override void dispose(){name.dispose();super.dispose();}
 @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Create your space')), body: PageBody(children: [
 const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-african-american-woman-is-holding-newborn-baby-family-concept-health-happy-mother-s-day-flat-illustration-vector.jpg'),
 const ScreenTitle('A little about you'),
 TextField(controller: name, decoration: const InputDecoration(labelText: 'What should we call you?')),
 const Text('Next, we will ask about your feelings over the past seven days.'),
 FilledButton(onPressed: () {AppScope.of(context).register(name.text); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AssessmentScreen()), (_) => false);}, child: const Text('Continue to assessment')),
 ]));
}
