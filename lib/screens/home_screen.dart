import 'package:flutter/material.dart';
import '../state/app_state.dart';import '../widgets/ui.dart';import 'chat_screen.dart';
class HomeScreen extends StatelessWidget {const HomeScreen({super.key});
 @override Widget build(BuildContext context){final s=AppScope.of(context);return Scaffold(body:PageBody(children:[
 const SizedBox(height:18),ScreenTitle('Hello, ${s.name} 🌷'),const Text('How are you feeling today?'),
 const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-mom-and-newborn-baby-family-concept-health-happy-mother-s-day-flat-illustration-vector.jpg',height:240),
 SoftCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Your journey',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:8),Text('Initial questionnaire: ${s.assessed ? 'Completed' : 'Not completed'}'),Text('Daily check-ins: ${s.checkIns.length}'),const Text('You deserve support, every day.') ])),
 SoftCard(child:Column(children:[const Text('Need a moment to talk?'),const SizedBox(height:10),FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ChatScreen())),child:const Text('Open Liya chatbot demo'))])),
 ]));}
}
