import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/ui.dart';
import 'main_shell.dart';
class ResultScreen extends StatelessWidget {const ResultScreen({super.key});
 @override Widget build(BuildContext context) {final s=AppScope.of(context); return Scaffold(appBar: AppBar(title: const Text('Your screening summary')), body:PageBody(children:[
 const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-woman-holding-baby-in-her-arms-happy-mother-s-day-flat-illustration-vector (1).jpg',height:190),
 const ScreenTitle('Thank you for sharing 💜'),
 SoftCard(child:Column(children:[const Text('Your questionnaire score'), Text('${s.score} / 30',style:const TextStyle(fontSize:44,fontWeight:FontWeight.bold,color:Color(0xFF8064B0))),const Text('A screening score is not a diagnosis.') ])),
 SoftCard(child:Text(s.safetyFlag ? 'You indicated thoughts of self-harm. Please seek prompt help from a healthcare professional or local emergency service, regardless of your total score.' : 'Your answers may help you start a conversation with a healthcare professional. Please seek professional advice if you are worried about your wellbeing.')),
 const Text('Risk bands and ML predictions are intentionally not shown: they require validated clinical rules and testing.'),
 FilledButton(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const MainShell()),(_)=>false),child:const Text('Go to my home')),
 ])); }
}
