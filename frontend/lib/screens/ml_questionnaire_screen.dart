import 'package:flutter/material.dart';

import '../data/ml_questions.dart';
import '../services/ml_prediction_service.dart';

class MlQuestionnaireScreen extends StatefulWidget {
  const MlQuestionnaireScreen({super.key});

  @override
  State<MlQuestionnaireScreen> createState() => _MlQuestionnaireScreenState();
}

class _MlQuestionnaireScreenState extends State<MlQuestionnaireScreen> {
  final Map<String, dynamic> _answers = {};
  final MlPredictionService _service = MlPredictionService();

  static const Color primaryPink = Color(0xFFC45D83);
  static const Color lightPink = Color(0xFFF9DCE7);
  static const Color backgroundColor = Color(0xFFFFFAFC);
  static const Color decreaseColor = Color(0xFF438E80);

  int _index = 0;
  bool _loading = false;
  String? _error;
  MlPredictionResult? _result;

  Future<void> _next() async {
    if (_loading) return;

    final question = mlQuestions[_index];

    if (!_answers.containsKey(question.feature) ||
        _answers[question.feature] == null) {
      setState(() {
        _error = 'Please select or enter an answer.';
      });
      return;
    }

    setState(() {
      _error = null;
    });

    if (_index < mlQuestions.length - 1) {
      setState(() {
        _index++;
      });
      return;
    }

    if (_answers.length != mlQuestions.length) {
      setState(() {
        _error = 'Please complete all questions before submitting.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _service.predict(
        Map<String, dynamic>.from(_answers),
      );

      if (!mounted) return;

      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = 'Unable to get prediction and explanation. '
            'Please check your backend connection. $error';
        _loading = false;
      });
    }
  }

  void _previous() {
    if (_loading || _index == 0) return;

    setState(() {
      _index--;
      _error = null;
    });
  }

  void _selectAnswer(String feature, dynamic value) {
    setState(() {
      _answers[feature] = value;
      _error = null;
    });
  }

  Widget _buildNumericQuestion(
    MlQuestion question,
    dynamic selected,
  ) {
    return ListView(
      children: [
        DropdownButtonFormField<int>(
          key: ValueKey(question.feature),
          initialValue: selected as int?,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Select your answer',
            filled: true,
            fillColor: lightPink.withValues(alpha: 0.25),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: primaryPink,
                width: 2,
              ),
            ),
          ),
          items: [
            for (int value = question.minimum!;
                value <= question.maximum!;
                value++)
              DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              ),
          ],
          onChanged: _loading
              ? null
              : (value) {
                  if (value == null) return;
                  _selectAnswer(question.feature, value);
                },
        ),
      ],
    );
  }

  Widget _buildCategoricalQuestion(
    MlQuestion question,
    dynamic selected,
  ) {
    return RadioGroup<String>(
      groupValue: selected as String?,
      onChanged: (String? value) {
        if (_loading || value == null) return;
        _selectAnswer(question.feature, value);
      },
      child: ListView(
        children: [
          for (final option in question.options!)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: selected == option ? 2 : 0,
                color: selected == option ? lightPink : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color:
                        selected == option ? primaryPink : Colors.grey.shade300,
                    width: selected == option ? 1.5 : 1,
                  ),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontWeight: selected == option
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  value: option,
                  activeColor: primaryPink,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionnaire() {
    final question = mlQuestions[_index];
    final selected = _answers[question.feature];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Liyaa - Background Assessment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: lightPink,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_index + 1) / mlQuestions.length,
                color: primaryPink,
                backgroundColor: lightPink,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 24),
              Text(
                'Question ${_index + 1} of ${mlQuestions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please select the answer that best describes you.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: question.isNumeric
                    ? _buildNumericQuestion(
                        question,
                        selected,
                      )
                    : _buildCategoricalQuestion(
                        question,
                        selected,
                      ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  if (_index > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _loading ? null : _previous,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryPink,
                          side: const BorderSide(
                            color: primaryPink,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loading ? null : _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _index == mlQuestions.length - 1
                                  ? 'View My Wellbeing Insights'
                                  : 'Next',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProbabilityRow(
    String label,
    double probability,
  ) {
    final value = probability.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(value * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            color: primaryPink,
            backgroundColor: lightPink,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildShapSection(
    MlPredictionResult result,
  ) {
    final explanation = result.explanation;

    if (explanation == null) {
      return const SizedBox.shrink();
    }

    final factors = explanation.topFactors;

    double maxMagnitude = 0;

    for (final factor in factors) {
      final magnitude = factor.shapValue.abs();

      if (magnitude > maxMagnitude) {
        maxMagnitude = magnitude;
      }
    }

    if (maxMagnitude == 0) {
      maxMagnitude = 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SHAP Model Explanation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SHAP explains how questionnaire features '
          'contributed to the model\'s estimated '
          'probability of the High screening class.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: lightPink.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'High-Class Probability Explanation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 18),
              _buildExplanationMetric(
                'Background reference probability',
                explanation.baseProbability,
              ),
              const SizedBox(height: 12),
              _buildExplanationMetric(
                'Model-estimated probability',
                explanation.predictedProbability,
              ),
              const SizedBox(height: 12),
              const Text(
                'SHAP contributions explain the difference '
                'between these two model probabilities.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Top Contributing Factors',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pink: increases the model\'s High-class estimate.\n'
          'Green: decreases the model\'s High-class estimate.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        for (final factor in factors)
          _buildShapFactor(
            factor,
            maxMagnitude,
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'SHAP values describe how the AI model '
            'uses questionnaire answers. They do not '
            'establish medical causation or prove '
            'that a factor prevents depression.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationMetric(
    String label,
    double value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(value * 100).toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: primaryPink,
          ),
        ),
      ],
    );
  }

  Widget _buildShapFactor(
    MlShapFactor factor,
    double maxMagnitude,
  ) {
    final isIncrease = factor.shapValue > 0;
    final isDecrease = factor.shapValue < 0;

    final color = isIncrease
        ? primaryPink
        : isDecrease
            ? decreaseColor
            : Colors.grey;

    final percentagePoints = factor.shapValue * 100;

    final magnitude = (factor.shapValue.abs() / maxMagnitude).clamp(0.0, 1.0);

    final sign = percentagePoints > 0 ? '+' : '';

    final answer =
        factor.answer == null ? 'Not provided' : factor.answer.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              factor.feature,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Answer: $answer',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: magnitude,
              color: color,
              backgroundColor: Colors.grey.shade100,
              minHeight: 9,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isIncrease
                        ? 'Increases High-class estimate'
                        : isDecrease
                            ? 'Decreases High-class estimate'
                            : 'No measured contribution',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$sign${percentagePoints.toStringAsFixed(2)} pp',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotherFactorCard(
    MlShapFactor factor,
  ) {
    final isIncrease = factor.shapValue > 0;
    final isDecrease = factor.shapValue < 0;

    final color = isIncrease
        ? primaryPink
        : isDecrease
            ? decreaseColor
            : Colors.grey;

    final directionText = isIncrease
        ? 'Raised the model estimate'
        : isDecrease
            ? 'Lowered the model estimate'
            : 'Little measured influence';

    final answer =
        factor.answer == null ? 'Not provided' : factor.answer.toString();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isIncrease
                ? Icons.trending_up
                : isDecrease
                    ? Icons.trending_down
                    : Icons.remove,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.feature,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your answer: $answer',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  directionText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lightPink,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: lightPink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryPink,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final result = _result!;
    final explanation = result.explanation;

    final factors = explanation?.topFactors ?? <MlShapFactor>[];
    final visibleFactors = factors.take(3).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Your Wellbeing Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: lightPink,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: lightPink,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.favorite_outline,
                    color: primaryPink,
                    size: 52,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Thank You for Sharing With Liyaa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF71354F),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Your answers help Liyaa understand '
                    'more about your background and identify '
                    'topics that may be useful to explore.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF6F4D5D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Understanding Your Results',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Liyaa analyzed your background questionnaire '
              'using an experimental AI model. Its findings '
              'are estimates, not a diagnosis. They cannot '
              'determine whether you have postpartum depression.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: lightPink,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        color: primaryPink,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'What Influenced the AI Estimate?',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The AI considered different aspects '
                    'of your pregnancy and personal background. '
                    'These are some answers that influenced '
                    'its High-class estimate.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (visibleFactors.isEmpty)
                    const Text(
                      'A detailed explanation is not '
                      'available at the moment.',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  for (final factor in visibleFactors)
                    _buildMotherFactorCard(factor),
                  const SizedBox(height: 8),
                  const Text(
                    'These findings describe the AI model, '
                    'not confirmed medical causes or '
                    'protective factors.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'How Liyaa Can Support You',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Everyone experiences motherhood differently. '
              'You can choose the support that feels '
              'most useful to you.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 18),
            _buildSupportCard(
              icon: Icons.chat_bubble_outline,
              title: 'Talk About Your Feelings',
              description: 'Use Liyaa\'s conversational support '
                  'features to reflect on how you feel.',
            ),
            _buildSupportCard(
              icon: Icons.edit_calendar_outlined,
              title: 'Daily Wellbeing Check-In',
              description: 'Track your mood, sleep and recovery '
                  'experiences over time.',
            ),
            _buildSupportCard(
              icon: Icons.spa_outlined,
              title: 'Explore Supportive Activities',
              description: 'Discover gentle wellbeing resources '
                  'and practical self-care ideas.',
            ),
            _buildSupportCard(
              icon: Icons.medical_services_outlined,
              title: 'Professional Support',
              description: 'A qualified healthcare professional '
                  'can help you understand your symptoms '
                  'and decide what support you need.',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.health_and_safety_outlined,
                        color: Color(0xFF9B5D2F),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your Safety Matters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF754321),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'This AI assessment does not replace '
                    'your EPDS screening or advice from '
                    'a healthcare professional.\n\n'
                    'If you are experiencing distressing '
                    'symptoms, please speak with a qualified '
                    'healthcare professional, regardless '
                    'of your AI result.\n\n'
                    'If you feel at risk of harming yourself '
                    'or someone else, seek immediate '
                    'emergency medical assistance.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFF754321),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              childrenPadding: const EdgeInsets.all(14),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              leading: const Icon(
                Icons.analytics_outlined,
                color: primaryPink,
              ),
              title: const Text(
                'Technical Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'For research and model transparency',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              children: [
                Text(
                  'Model: ${result.model}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Predicted model class: '
                  '${result.predictedClass}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Class Probabilities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                for (final label in ['Low', 'Medium', 'High'])
                  _buildProbabilityRow(
                    label,
                    result.probabilities[label] ?? 0,
                  ),
                if (explanation != null) ...[
                  const Divider(height: 32),
                  _buildShapSection(result),
                ],
                const SizedBox(height: 12),
                const Text(
                  'These values describe an experimental '
                  'model. They are not validated clinical '
                  'risk probabilities or a diagnosis.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue to My Dashboard',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return _buildResult();
    }

    return _buildQuestionnaire();
  }
}
