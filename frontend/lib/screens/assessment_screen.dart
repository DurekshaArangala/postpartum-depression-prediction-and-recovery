
import 'package:flutter/material.dart';

import '../data/assessment_questions.dart';
import '../services/assessment_service.dart';
import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() =>
      _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int index = 0;

  final List<int?> selected = List<int?>.filled(10, null);

  final AssessmentService _assessmentService =
      AssessmentService();

  bool _isSaving = false;
  String? _errorMessage;

  Future<void> _next() async {
    if (_isSaving || selected[index] == null) {
      return;
    }

    if (index < 9) {
      setState(() {
        index++;
        _errorMessage = null;
      });
      return;
    }

    // All 10 questions must be answered.
    if (selected.any((answer) => answer == null)) {
      setState(() {
        _errorMessage =
            'Please answer all 10 questions before submitting.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final answers = selected.cast<int>();

      // Supabase calculates and stores the official
      // EPDS score and completes onboarding.
      final saved = await _assessmentService
          .submitInitialAssessment(answers);

      if (!mounted) return;

      // Use the answers actually saved in Supabase.
      final appState = AppScope.of(context);
      appState.submitAssessment(saved.answers);

      // Verify that Flutter's calculation agrees
      // with the saved server-side result.
      if (appState.score != saved.totalScore ||
          appState.safetyFlag != saved.safetyFlag) {
        throw StateError(
          'The saved assessment could not be verified.',
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ResultScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'We could not finish loading your saved '
            'assessment. Please try again. '
            'Your previous submission will not be duplicated.';
      });

      debugPrint('EPDS submission error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your initial wellbeing assessment'),
      ),
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
                  valueColor: const AlwaysStoppedAnimation(
                    LiyaaColors.pink,
                  ),
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
                    onTap: _isSaving
                        ? () {}
                        : () {
                            setState(() {
                              selected[index] = i;
                              _errorMessage = null;
                            });
                          },
                  ),
                  if (i < 3)
                    const SizedBox(height: 12),
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
                  Icon(
                    Icons.favorite_rounded,
                    size: 22,
                    color: LiyaaColors.alertText,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If you are having thoughts of self-harm, '
                      'please contact a healthcare professional '
                      'or local emergency services now. '
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

          if (_errorMessage != null)
            TintCard(
              color: LiyaaColors.alertBg,
              padding: const EdgeInsets.all(16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 15,
                  color: LiyaaColors.alertText,
                ),
              ),
            ),

          Row(
            children: [
              if (index > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            setState(() {
                              index--;
                              _errorMessage = null;
                            });
                          },
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed:
                      selected[index] == null || _isSaving
                          ? null
                          : _next,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          index == 9
                              ? 'See my result'
                              : 'Next',
                        ),
                ),
              ),
            ],
          ),

          const Text(
            'This is a screening demonstration, not a diagnosis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: LiyaaColors.plumSoft,
            ),
          ),
        ],
      ),
    );
  }
}
