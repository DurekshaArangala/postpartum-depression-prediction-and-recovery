import 'package:flutter/material.dart';
import '../state/app_state.dart';import '../widgets/ui.dart';
class CheckInScreen extends StatefulWidget {const CheckInScreen({super.key});@override State<CheckInScreen> createState()=>_CheckInScreenState();}
class _CheckInScreenState extends State<CheckInScreen> {
 int mood=3,sleep=3,energy=3;final note=TextEditingController();
 @override void dispose(){note.dispose();super.dispose();}
 Widget choice(String title,List<String> labels,int value,ValueChanged<int> update)=>SoftCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const SizedBox(height:8),...List.generate(5,(i)=>RadioListTile<int>(dense:true,contentPadding:EdgeInsets.zero,title:Text(labels[i]),value:i+1,groupValue:value,onChanged:(v)=>setState(()=>update(v!))))]));
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Daily check-in')),body:PageBody(children:[
 const ScreenTitle('How has today been?'),
 choice('Your mood',['😢 Very low','😔 Low','😐 Okay','🙂 Good','😊 Great'],mood,(v)=>mood=v),
 choice('How did you sleep?',['Very poorly','Poorly','Okay','Well','Very well'],sleep,(v)=>sleep=v),
 choice('How is your energy?',['Exhausted','Low','Moderate','Good','Very energetic'],energy,(v)=>energy=v),
 TextField(controller:note,maxLines:3,decoration:const InputDecoration(labelText:'Anything on your mind? (optional)')),
 FilledButton(onPressed:(){AppScope.of(context).addCheckIn(mood,sleep,energy,note.text);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Today’s check-in saved for this demo 💜')));},child:const Text('Save today’s check-in')),
 ]));
}
