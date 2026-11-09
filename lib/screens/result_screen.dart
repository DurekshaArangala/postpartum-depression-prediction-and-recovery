import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/score_ring.dart';
import '../widgets/ui.dart';
import 'main_shell.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your summary')),
      body: PageBody(
        children: [
          const ArtCard(
            'ill_result.png',
            height: 200,
            color: LiyaaColors.lavenderSoft,
          ),
          const ScreenTitle(
            'Thank you for sharing',
            subtitle: 'It takes courage to look at how you are really feeling.',
          ),
          TintCard(
            color: Colors.white,
            bordered: true,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
            child: Column(
              children: [
                const SectionTitle('Your questionnaire score'),
                const SizedBox(height: 20),
                ScoreRing(score: s.score, max: 30),
                const SizedBox(height: 18),
                const Text(
                  'A screening score is not a diagnosis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: LiyaaColors.plumSoft),
                ),
              ],
            ),
          ),
          if (s.safetyFlag)
            const TintCard(
              color: LiyaaColors.alertBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite_rounded, color: LiyaaColors.alertText),
                      SizedBox(width: 10),
                      Text(
                        'Please reach out today',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: LiyaaColors.alertText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You indicated thoughts of self-harm. Please seek prompt help '
                    'from a healthcare professional or local emergency service, '
                    'regardless of your total score.\n\n'
                    'Sri Lanka National Mental Health Helpline: 1926\n'
                    'Emergency ambulance: 1990',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: LiyaaColors.alertText,
                    ),
                  ),
                ],
              ),
            )
          else
            const TintCard(
              color: LiyaaColors.lavenderSoft,
              child: Text(
                'Your answers may help you start a conversation with a healthcare '
                'professional. Please seek professional advice if you are worried '
                'about your wellbeing.',
                style: TextStyle(fontSize: 17, height: 1.4),
              ),
            ),
          const Text(
            'Risk bands and ML predictions are intentionally not shown: they '
            'require validated clinical rules and testing.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: LiyaaColors.plumSoft),
          ),
          FilledButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainShell()),
              (_) => false,
            ),
            child: const Text('Go to my home'),
          ),
        ],
      ),
    );
  }
}