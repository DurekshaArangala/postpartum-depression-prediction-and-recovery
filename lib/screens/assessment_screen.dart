import 'package:flutter/material.dart';
import '../data/assessment_questions.dart';
import '../state/app_state.dart';
import '../widgets/ui.dart';
import 'result_screen.dart';
class AssessmentScreen extends StatefulWidget {const AssessmentScreen({super.key}); @override State<AssessmentScreen> createState()=>_AssessmentScreenState();}
class _AssessmentScreenState extends State<AssessmentScreen> {
 int index=0; final List<int?> selected=List.filled(10,null);
 @override Widget build(BuildContext context) { final q=questions[index]; return Scaffold(appBar: AppBar(title: const Text('Your first check-in')), body: PageBody(children: [
 LinearProgressIndicator(value:(index+1)/10, minHeight: 8, borderRadius: BorderRadius.circular(12)),
 Text('Question ${index+1} of 10 • Thinking about the past 7 days'),
 ScreenTitle(q.text),
 ...List.generate(4,(i)=>SoftCard(child: RadioListTile<int>(contentPadding: EdgeInsets.zero, title: Text(q.options[i]), value:i, groupValue:selected[index], onChanged:(v)=>setState(()=>selected[index]=v)))),
 if(index==9) const Text('If you are having thoughts of self-harm, please contact a healthcare professional or local emergency services now. Do not wait for this screening result.', style: TextStyle(color: Color(0xFF9A364C))),
 Row(children:[if(index>0) Expanded(child: OutlinedButton(onPressed:()=>setState(()=>index--), child:const Text('Back'))), if(index>0) const SizedBox(width:12), Expanded(child:FilledButton(onPressed:selected[index]==null?null:(){if(index<9){setState(()=>index++);}else{AppScope.of(context).submitAssessment(selected.cast<int>());Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const ResultScreen()));}}, child:Text(index==9?'See my result':'Next')))]),
 const Text('This is a screening demonstration, not a diagnosis.', textAlign:TextAlign.center),
 ])); }
}
