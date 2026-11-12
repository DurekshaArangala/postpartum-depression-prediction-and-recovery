   import 'package:flutter/material.dart';
   import 'package:flutter_test/flutter_test.dart';
   import 'package:liyaa_frontend/screens/welcome_screen.dart';
   import 'package:liyaa_frontend/theme/liyaa_theme.dart';

   void main() {
     testWidgets('Welcome screen shows the app name and buttons', (tester) async {
       await tester.pumpWidget(
         MaterialApp(theme: liyaaTheme(), home: const WelcomeScreen()),
       );
       await tester.pumpAndSettle();

       expect(find.text('Liyaa'), findsOneWidget);
       expect(find.text('Get started'), findsOneWidget);
       expect(find.text('I already have an account'), findsOneWidget);
     });
   }
