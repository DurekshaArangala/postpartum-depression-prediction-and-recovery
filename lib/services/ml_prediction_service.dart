import 'dart:convert';

import 'package:http/http.dart' as http;

class MlShapFactor {
  final String feature;
  final dynamic answer;
  final double shapValue;
  final String direction;

  const MlShapFactor({
    required this.feature,
    required this.answer,
    required this.shapValue,
    required this.direction,
  });

  factory MlShapFactor.fromJson(Map<String, dynamic> json) {
    return MlShapFactor(
      feature: json['feature'] as String,
      answer: json['answer'],
      shapValue: (json['shap_value'] as num).toDouble(),
      direction: json['direction'] as String,
    );
  }
}

class MlShapExplanation {
  final String targetClass;
  final double baseProbability;
  final double predictedProbability;
  final double reconstructedProbability;
  final String method;
  final List<MlShapFactor> factors;
  final List<MlShapFactor> topFactors;

  const MlShapExplanation({
    required this.targetClass,
    required this.baseProbability,
    required this.predictedProbability,
    required this.reconstructedProbability,
    required this.method,
    required this.factors,
    required this.topFactors,
  });

  factory MlShapExplanation.fromJson(Map<String, dynamic> json) {
    List<MlShapFactor> parseFactors(dynamic raw) {
      return (raw as List<dynamic>)
          .map(
            (item) => MlShapFactor.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    return MlShapExplanation(
      targetClass: json['target_class'] as String,
      baseProbability: (json['base_probability'] as num).toDouble(),
      predictedProbability: (json['predicted_probability'] as num).toDouble(),
      reconstructedProbability:
          (json['reconstructed_probability'] as num).toDouble(),
      method: json['method'] as String,
      factors: parseFactors(json['factors']),
      topFactors: parseFactors(json['top_factors']),
    );
  }
}

class MlPredictionResult {
  final String model;
  final String predictedClass;
  final double probabilityHigh;
  final Map<String, double> probabilities;
  final MlShapExplanation? explanation;
  final String? disclaimer;

  const MlPredictionResult({
    required this.model,
    required this.predictedClass,
    required this.probabilityHigh,
    required this.probabilities,
    this.explanation,
    this.disclaimer,
  });

  factory MlPredictionResult.fromJson(Map<String, dynamic> json) {
    // Supports the combined SHAP response and
    // the original prediction-only response.
    final prediction = json['prediction'] is Map
        ? Map<String, dynamic>.from(json['prediction'] as Map)
        : json;

    final rawProbabilities = Map<String, dynamic>.from(
      prediction['class_probabilities'] as Map,
    );

    final rawExplanation = json['explanation'];

    return MlPredictionResult(
      model: prediction['model'] as String,
      predictedClass: prediction['predicted_screening_class'] as String,
      probabilityHigh: (prediction['probability_high'] as num).toDouble(),
      probabilities: rawProbabilities.map(
        (key, value) => MapEntry(
          key,
          (value as num).toDouble(),
        ),
      ),
      explanation: rawExplanation is Map
          ? MlShapExplanation.fromJson(
              Map<String, dynamic>.from(rawExplanation),
            )
          : null,
      disclaimer: json['disclaimer'] as String?,
    );
  }
}

class MlPredictionService {
  static const String _baseUrl = String.fromEnvironment(
    'ML_API_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  Future<MlPredictionResult> predict(
    Map<String, dynamic> questionnaire,
  ) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/predict-with-explanation'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'questionnaire': questionnaire,
          }),
        )
        .timeout(const Duration(seconds: 180));

    if (response.statusCode != 200) {
      throw Exception(
        'Prediction and explanation failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(
      response.body,
    ) as Map<String, dynamic>;

    return MlPredictionResult.fromJson(data);
  }
}
