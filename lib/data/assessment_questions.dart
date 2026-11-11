
class AssessmentQuestion {
  final String text;
  final List<String> options;

  const AssessmentQuestion(this.text, this.options);
}

/// Edinburgh Postnatal Depression Scale (EPDS)
///
/// Reference:
/// Cox, J. L., Holden, J. M., & Sagovsky, R. (1987).
/// Detection of postnatal depression: Development
/// of the 10-item Edinburgh Postnatal Depression Scale.
/// British Journal of Psychiatry, 150, 782–786.
///
/// The question and response order follows the
/// official English EPDS document supplied.
///
/// Each answer is stored as its selected index (0–3).
/// Scoring is performed separately in AppState.

const questions = <AssessmentQuestion>[
  // Question 1 — scores 0, 1, 2, 3
  AssessmentQuestion(
    'I have been able to laugh and see the funny side of things',
    [
      'As much as I always could',
      'Not quite so much now',
      'Definitely not so much now',
      'Not at all',
    ],
  ),

  // Question 2 — scores 0, 1, 2, 3
  AssessmentQuestion(
    'I have looked forward with enjoyment to things',
    [
      'As much as I ever did',
      'Rather less than I used to',
      'Definitely less than I used to',
      'Hardly at all',
    ],
  ),

  // Question 3 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'I have blamed myself unnecessarily when things went wrong',
    [
      'Yes, most of the time',
      'Yes, some of the time',
      'Not very often',
      'No, never',
    ],
  ),

  // Question 4 — scores 0, 1, 2, 3
  AssessmentQuestion(
    'I have been anxious or worried for no good reason',
    [
      'No, not at all',
      'Hardly ever',
      'Yes, sometimes',
      'Yes, very often',
    ],
  ),

  // Question 5 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'I have felt scared or panicky for no very good reason',
    [
      'Yes, quite a lot',
      'Yes, sometimes',
      'No, not much',
      'No, not at all',
    ],
  ),

  // Question 6 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'Things have been getting on top of me',
    [
      'Yes, most of the time I haven’t been able to cope at all',
      'Yes, sometimes I haven’t been coping as well as usual',
      'No, most of the time I have coped quite well',
      'No, I have been coping as well as ever',
    ],
  ),

  // Question 7 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'I have been so unhappy that I have had difficulty sleeping',
    [
      'Yes, most of the time',
      'Yes, sometimes',
      'Not very often',
      'No, not at all',
    ],
  ),

  // Question 8 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'I have felt sad or miserable',
    [
      'Yes, most of the time',
      'Yes, quite often',
      'Not very often',
      'No, not at all',
    ],
  ),

  // Question 9 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'I have been so unhappy that I have been crying',
    [
      'Yes, most of the time',
      'Yes, quite often',
      'Only occasionally',
      'No, never',
    ],
  ),

  // Question 10 — scores 3, 2, 1, 0
  AssessmentQuestion(
    'The thought of harming myself has occurred to me',
    [
      'Yes, quite often',
      'Sometimes',
      'Hardly ever',
      'Never',
    ],
  ),
];
