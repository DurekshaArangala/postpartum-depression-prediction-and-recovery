class AssessmentQuestion {
  final String text;
  final List<String> options;
  const AssessmentQuestion(this.text, this.options);
}
// EPDS-style English wording for frontend demonstration. Before clinical use,
// obtain permission where required and verify wording, translations and scoring
// against an authorized, validated local EPDS form.
const questions = <AssessmentQuestion>[
  AssessmentQuestion('I have been able to laugh and see the funny side of things.', ['As much as I always could', 'Not quite so much now', 'Definitely not so much now', 'Not at all']),
  AssessmentQuestion('I have looked forward with enjoyment to things.', ['As much as I ever did', 'Rather less than I used to', 'Definitely less than I used to', 'Hardly at all']),
  AssessmentQuestion('I have blamed myself unnecessarily when things went wrong.', ['No, never', 'Not very often', 'Yes, some of the time', 'Yes, most of the time']),
  AssessmentQuestion('I have been anxious or worried for no good reason.', ['No, not at all', 'Hardly ever', 'Yes, sometimes', 'Yes, very often']),
  AssessmentQuestion('I have felt scared or panicky for no very good reason.', ['No, not at all', 'No, not much', 'Yes, sometimes', 'Yes, quite a lot']),
  AssessmentQuestion('Things have been getting on top of me.', ['No, I have been coping as well as ever', 'No, most of the time I have coped quite well', 'Yes, sometimes I have not been coping as well as usual', 'Yes, most of the time I have not been able to cope at all']),
  AssessmentQuestion('I have been so unhappy that I have had difficulty sleeping.', ['No, not at all', 'Not very often', 'Yes, sometimes', 'Yes, most of the time']),
  AssessmentQuestion('I have felt sad or miserable.', ['No, not at all', 'Not very often', 'Yes, quite often', 'Yes, most of the time']),
  AssessmentQuestion('I have been so unhappy that I have been crying.', ['No, never', 'Only occasionally', 'Yes, quite often', 'Yes, most of the time']),
  AssessmentQuestion('The thought of harming myself has occurred to me.', ['Never', 'Hardly ever', 'Sometimes', 'Yes, quite often']),
];
