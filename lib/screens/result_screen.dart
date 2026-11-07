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

    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Your summary'),
      body: PageBody(
        children: [
          const FadeIn(child: LiyaaImage('mom_baby_swaddle.jpg', height: 220)),
          const ScreenTitle(
            'Thank you for sharing 💜',
            subtitle: 'It takes courage to look at how you are really feeling.',
          ),
          SoftCard(
            child: Column(
              children: [
                const Eyebrow('Your questionnaire score'),
                const SizedBox(height: 20),
                ScoreRing(score: s.score, max: 30),
                const SizedBox(height: 20),
                const Text(
                  'A screening score is not a diagnosis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: LiyaaColors.inkSoft),
                ),
              ],
            ),
          ),
          if (s.safetyFlag)
            const SoftCard(
              color: LiyaaColors.alert,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
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
                      fontSize: 14,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                      color: LiyaaColors.alertText,
                    ),
                  ),
                ],
              ),
            )
          else
            const SoftCard(
              gradient: LiyaaColors.plumGradient,
              child: Text(
                'Your answers may help you start a conversation with a healthcare '
                'professional. Please seek professional advice if you are worried '
                'about your wellbeing.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.55,
                  color: LiyaaColors.ink,
                ),
              ),
            ),
          const Text(
            'Risk bands and ML predictions are intentionally not shown: they '
            'require validated clinical rules and testing.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.5, color: LiyaaColors.inkSoft),
          ),
          PillAction(
            label: 'Go to my home',
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainShell()),
              (_) => false,
            ),
          ),
        ],
      ),
    );
  }
}