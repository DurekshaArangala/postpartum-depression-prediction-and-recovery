import 'package:flutter/material.dart';import '../state/app_state.dart';import '../widgets/ui.dart';import 'welcome_screen.dart';
class ProfileScreen extends StatelessWidget {const ProfileScreen({super.key});
 @override Widget build(BuildContext context){final s=AppScope.of(context);return Scaffold(appBar:AppBar(title:const Text('Profile')),body:PageBody(children:[
 const LiyaaImage('breastfeeding-black-woman-feeding-a-baby-family-health-maternity-concept-happy-mother-s-day-flat-illustration-vector.jpg',height:190),
 ScreenTitle(s.name),const Text('Liyaa frontend prototype'),
 SoftCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Assessment completed: ${s.assessed ? 'Yes' : 'No'}'),Text('Daily check-ins: ${s.checkIns.length}'),const SizedBox(height:12),const Text('Demo information is stored only while the app is running.') ])),
 OutlinedButton(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const WelcomeScreen()),(_)=>false),child:const Text('Back to welcome screen')),
 ]));}
}
