
import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/score_ring.dart';
import '../widgets/ui.dart';

import 'main_shell.dart';
import 'ml_questionnaire_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your EPDS summary'),
      ),
      body: PageBody(
        children: [
          const ArtCard(
            'ill_result.png',
            height: 200,
            color: LiyaaColors.lavenderSoft,
          ),

          const ScreenTitle(
            'Thank you for sharing',
            subtitle:
                'It takes courage to look at how you are really feeling.',
          ),

          TintCard(
            color: Colors.white,
            bordered: true,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 18,
            ),
            child: Column(
              children: [
                const SectionTitle(
                  'Your EPDS questionnaire score',
                ),
                const SizedBox(height: 20),

                ScoreRing(
                  score: s.score,
                  max: 30,
                ),

                const SizedBox(height: 18),

                const Text(
                  'Your score is based on how you felt '
                  'during the past 7 days.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: LiyaaColors.plumSoft,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'The EPDS is a screening tool, '
                  'not a medical diagnosis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: LiyaaColors.plumSoft,
                  ),
                ),
              ],
            ),
          ),

          if (s.possibleDepression)
            const TintCard(
              color: LiyaaColors.lavenderSoft,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'A conversation with a healthcare '
                    'professional is recommended',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your screening score is at or above '
                    'the reference threshold for possible '
                    'depression. This does not mean you '
                    'have been diagnosed with depression. '
                    'Please discuss your results with a '
                    'qualified healthcare professional.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

          if (s.safetyFlag)
            const TintCard(
              color: LiyaaColors.alertBg,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: LiyaaColors.alertText,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Please reach out today',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: LiyaaColors.alertText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You indicated thoughts of self-harm. '
                    'Please seek prompt help from a '
                    'healthcare professional, regardless '
                    'of your total EPDS score.\n\n'
                    'If you may act on these thoughts '
                    'or are in immediate danger, '
                    'contact emergency services now '
                    'and stay with someone you trust.\n\n'
                    'Sri Lanka National Mental Health '
                    'Helpline: 1926\n'
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
          else if (!s.possibleDepression)
            const TintCard(
              color: LiyaaColors.lavenderSoft,
              padding: EdgeInsets.all(16),
              child: Text(
                'Your screening score is below the '
                'reference threshold for possible '
                'depression. This does not rule out '
                'depression or other mental health '
                'concerns. Please seek professional '
                'advice if you are worried about '
                'your wellbeing.',
                style: TextStyle(
                  fontSize: 17,
                  height: 1.4,
                ),
              ),
            ),

          const Text(
            'EPDS scores support screening and '
            'discussion with a healthcare professional. '
            'The optional ML assessment is experimental '
            'and has not been clinically validated.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: LiyaaColors.plumSoft,
            ),
          ),

          // Do not place an optional questionnaire ahead
          // of urgent support guidance when Q10 is flagged.
          if (!s.safetyFlag) ...[
            const SizedBox(height: 8),

            TintCard(
              color: LiyaaColors.lavenderSoft,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Optional Background Assessment',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Answer 21 questions about your '
                    'background and pregnancy history '
                    'to explore how our experimental '
                    'machine-learning model works.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'This prediction is for research '
                    'demonstration only. It cannot '
                    'diagnose postpartum depression '
                    'or replace professional advice.',
                    style: TextStyle(
                      fontSize: 13,
                      color: LiyaaColors.plumSoft,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const MlQuestionnaireScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Explore ML assessment',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          FilledButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainShell(),
                ),
                (_) => false,
              );
            },
            child: const Text('Go to my home'),
          ),
        ],
      ),
    );
  }
}
