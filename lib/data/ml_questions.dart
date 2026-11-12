
class MlQuestion {
  final String feature;
  final String question;
  final List<String>? options;
  final int? minimum;
  final int? maximum;

  const MlQuestion({
    required this.feature,
    required this.question,
    this.options,
    this.minimum,
    this.maximum,
  });

  bool get isNumeric => minimum != null;
}

const List<MlQuestion> mlQuestions = [
  MlQuestion(
    feature: 'Age',
    question: 'What is your age?',
    minimum: 13,
    maximum: 45,
  ),
  MlQuestion(
    feature: 'Number of the latest pregnancy',
    question: 'Which number pregnancy was your most recent pregnancy?',
    minimum: 1,
    maximum: 7,
  ),
  MlQuestion(
    feature: 'Residence',
    question: 'Where do you live?',
    options: ['city', 'village'],
  ),
  MlQuestion(
    feature: 'Education Level',
    question: 'What is your highest education level?',
    options: [
      'college',
      'high school',
      'none',
      'primary school',
      'university',
    ],
  ),
  MlQuestion(
    feature: 'Marital status',
    question: 'What is your marital status?',
    options: ['divorced', 'married'],
  ),
  MlQuestion(
    feature: 'Occupation before latest pregnancy',
    question: 'What was your occupation before your latest pregnancy?',
    options: [
      'business',
      'doctor',
      'housewife',
      'other',
      'service',
      'student',
      'teacher',
    ],
  ),
  MlQuestion(
    feature: 'Monthly income before latest pregnancy',
    question: 'What was your monthly income before pregnancy?',
    options: [
      '10000 to 20000',
      '20000 to 30000',
      '5000 to 10000',
      'less than 5000',
      'more than 30000',
      'none',
    ],
  ),
  MlQuestion(
    feature: "Husband's education level",
    question: 'What is your husband’s highest education level?',
    options: [
      'college',
      'high school',
      'none',
      'primary school',
      'university',
    ],
  ),
  MlQuestion(
    feature: 'Disease before pregnancy',
    question: 'Did you have any diseases before pregnancy?',
    options: [
      'chronic disease',
      'non-chronic disease',
      'none',
    ],
  ),
  MlQuestion(
    feature: 'History of pregnancy loss',
    question: 'Have you experienced a pregnancy loss?',
    options: [
      'miscarriage',
      'none',
      'still-born delivery',
    ],
  ),
  MlQuestion(
    feature: 'Family type',
    question: 'What type of family do you live in?',
    options: ['joint', 'nuclear'],
  ),
  MlQuestion(
    feature: 'Number of household members',
    question: 'How many people live in your household?',
    options: ['2 to 5', '6 to 8', '9 or more'],
  ),
  MlQuestion(
    feature: 'Major changes or losses during pregnancy',
    question: 'Did you experience major changes or losses during pregnancy?',
    options: ['no', 'yes'],
  ),
  MlQuestion(
    feature: 'Pregnancy length',
    question: 'How long did your latest pregnancy last?',
    options: [
      '10 months',
      '6 months',
      '7 months',
      '8 months',
      '9 months',
      'less than 5 months',
    ],
  ),
  MlQuestion(
    feature: 'Pregnancy plan',
    question: 'Was your latest pregnancy planned?',
    options: ['no', 'yes'],
  ),
  MlQuestion(
    feature: 'Regular checkups',
    question: 'Did you attend regular pregnancy checkups?',
    options: ['no', 'yes'],
  ),
  MlQuestion(
    feature: 'Fear of pregnancy',
    question: 'Did you experience fear related to pregnancy?',
    options: ['no', 'yes'],
  ),
  MlQuestion(
    feature: 'Diseases during pregnancy',
    question: 'Did you experience any diseases during pregnancy?',
    options: [
      'chronic disease',
      'non-chronic disease',
      'none',
    ],
  ),
  MlQuestion(
    feature: 'Mode of delivery',
    question: 'What was your mode of delivery?',
    options: ['caesarean section', 'normal delivery'],
  ),
  MlQuestion(
    feature: 'Depression before pregnancy',
    question: 'Did you experience depression before pregnancy?',
    options: ['negative', 'positive'],
  ),
  MlQuestion(
    feature: 'Depression during pregnancy',
    question: 'Did you experience depression during pregnancy?',
    options: ['negative', 'positive'],
  ),
];
