import 'package:flutter/material.dart';import '../state/app_state.dart';import '../widgets/ui.dart';
class ProgressScreen extends StatelessWidget {const ProgressScreen({super.key});
 @override Widget build(BuildContext context){final items=AppScope.of(context).checkIns.reversed.toList();return Scaffold(appBar:AppBar(title:const Text('Your progress')),body:PageBody(children:[
 const ScreenTitle('One day at a time 🌿'),const LiyaaImage('banner-about-pregnancy-and-motherhood-with-place-for-text-pregnant-woman-future-mom-hugging-belly-with-arms-happy-mother-s-day-flat-illustration-vector.jpg',height:170),
 if(items.isEmpty) const SoftCard(child:Text('Your daily check-ins will appear here. Start by recording how you feel today.')),
 ...items.map((c)=>SoftCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('${c.date.day}/${c.date.month}/${c.date.year}',style:const TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:8),Text('Mood ${c.mood}/5  •  Sleep ${c.sleep}/5  •  Energy ${c.energy}/5'),const SizedBox(height:8),LinearProgressIndicator(value:c.mood/5),if(c.note.isNotEmpty)Padding(padding:const EdgeInsets.only(top:8),child:Text(c.note))]))),
 const Text('These are self-reported wellness check-ins, not medical recovery measurements.'),
 ]));}
}
