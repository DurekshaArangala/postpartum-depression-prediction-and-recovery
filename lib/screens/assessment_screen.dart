import 'package:flutter/material.dart';

import '../data/assessment_questions.dart';
import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int index = 0;
  final List<int?> selected = List.filled(10, null);

  void _next() {
    if (index < 9) {
      setState(() => index++);
    } else {
      AppScope.of(context).submitAssessment(selected.cast<int>());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];

    return Scaffold(
      appBar: AppBar(title: const Text('Your first check-in')),
      body: PageBody(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (index + 1) / 10,
                  minHeight: 8,
                  backgroundColor: LiyaaColors.pinkSoft,
                  valueColor: const AlwaysStoppedAnimation(LiyaaColors.pink),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Question ${index + 1} of 10  •  the past 7 days',
                style: const TextStyle(
                  fontSize: 15,
                  color: LiyaaColors.plumSoft,
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: Column(
              key: ValueKey(index),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenTitle(q.text, size: 26),
                const SizedBox(height: 22),
                for (var i = 0; i < 4; i++) ...[
                  OptionTile(
                    text: q.options[i],
                    selected: selected[index] == i,
                    onTap: () => setState(() => selected[index] = i),
                  ),
                  if (i < 3) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          if (index == 9)
            const TintCard(
              color: LiyaaColors.alertBg,
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.favorite_rounded,
                      size: 22, color: LiyaaColors.alertText),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If you are having thoughts of self-harm, please contact a '
                      'healthcare professional or local emergency services now. '
                      'Do not wait for this screening result.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: LiyaaColors.alertText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              if (index > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => index--),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: selected[index] == null ? null : _next,
                  child: Text(index == 9 ? 'See my result' : 'Next'),
                ),
              ),
            ],
          ),
          const Text(
            'This is a screening demonstration, not a diagnosis.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: LiyaaColors.plumSoft),
          ),
        ],
      ),
    );
  }
}