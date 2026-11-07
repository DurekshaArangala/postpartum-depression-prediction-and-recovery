import 'package:flutter/material.dart';import '../widgets/ui.dart';import 'chat_screen.dart';
class SupportScreen extends StatelessWidget {const SupportScreen({super.key});
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Gentle support')),body:PageBody(children:[
 const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-woman-holding-baby-in-her-arms-happy-mother-s-day-flat-illustration-vector.jpg',height:220),
 const ScreenTitle('You deserve care, too'),
 const SoftCard(child:ListTile(leading:Icon(Icons.bedtime_outlined),title:Text('Rest when you can'),subtitle:Text('Even a short rest may help you recharge. Ask someone you trust to help if possible.'))),
 const SoftCard(child:ListTile(leading:Icon(Icons.people_outline),title:Text('Stay connected'),subtitle:Text('Share how you feel with someone you trust. You do not need to handle everything alone.'))),
 const SoftCard(child:ListTile(leading:Icon(Icons.local_drink_outlined),title:Text('Small moments of care'),subtitle:Text('Have some water, eat regularly, and give yourself permission to take a break.'))),
 const SoftCard(child:Text('If sadness, anxiety, or distress is persistent or worsening, speak with a qualified healthcare professional. For immediate danger or thoughts of self-harm, seek urgent help.')),
 FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ChatScreen())),child:const Text('Talk to Liya (demo)')),
 ]));
}
