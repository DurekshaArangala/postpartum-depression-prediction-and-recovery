import 'package:flutter/material.dart';
import 'home_screen.dart';import 'checkin_screen.dart';import 'progress_screen.dart';import 'support_screen.dart';import 'profile_screen.dart';
class MainShell extends StatefulWidget {const MainShell({super.key});@override State<MainShell> createState()=>_MainShellState();}
class _MainShellState extends State<MainShell> {
 int index=0;
 final pages=const [HomeScreen(),CheckInScreen(),ProgressScreen(),SupportScreen(),ProfileScreen()];
 @override Widget build(BuildContext context)=>Scaffold(body:pages[index],bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(i)=>setState(()=>index=i),destinations:const [NavigationDestination(icon:Icon(Icons.home_outlined),label:'Home'),NavigationDestination(icon:Icon(Icons.favorite_outline),label:'Check-in'),NavigationDestination(icon:Icon(Icons.bar_chart),label:'Progress'),NavigationDestination(icon:Icon(Icons.spa_outlined),label:'Support'),NavigationDestination(icon:Icon(Icons.person_outline),label:'Profile')]));
}
