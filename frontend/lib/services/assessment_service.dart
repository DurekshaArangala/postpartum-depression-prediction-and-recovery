
import 'package:supabase_flutter/supabase_flutter.dart';

class AssessmentSaveResult {
  final List<int> answers;
  final int totalScore;
  final bool safetyFlag;

  const AssessmentSaveResult({
    required this.answers,
    required this.totalScore,
    required this.safetyFlag,
  });
}

class AssessmentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AssessmentSaveResult> submitInitialAssessment(
    List<int> answers,
  ) async {
    if (answers.length != 10 ||
        answers.any((answer) => answer < 0 || answer > 3)) {
      throw ArgumentError(
        'Please answer all 10 EPDS questions.',
      );
    }

    if (_supabase.auth.currentUser == null) {
      throw StateError(
        'Your session has expired. Please log in again.',
      );
    }

    final response = await _supabase.rpc(
      'complete_initial_assessment',
      params: {
        'p_answers': answers,
      },
    );

    final data = Map<String, dynamic>.from(response as Map);

    final savedAnswers = (data['answers'] as List)
        .map((answer) => (answer as num).toInt())
        .toList();

    return AssessmentSaveResult(
      answers: savedAnswers,
      totalScore: (data['total_score'] as num).toInt(),
      safetyFlag: data['safety_flag'] as bool,
    );
  }
}
