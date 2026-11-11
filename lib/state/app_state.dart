
import 'package:flutter/material.dart';

class CheckIn {
  final DateTime date;
  final int mood;
  final int sleep;
  final int energy;
  final String note;

  CheckIn(
    this.date,
    this.mood,
    this.sleep,
    this.energy,
    this.note,
  );
}

class AppState extends ChangeNotifier {
  String name = 'Mama';

  bool assessed = false;

  // Stores selected answer positions (0, 1, 2, 3).
  List<int> answers = [];

  final List<CheckIn> checkIns = [];

  /// All 10 questions must be answered.
  bool get hasValidAssessment =>
      answers.length == 10 &&
      answers.every((answer) => answer >= 0 && answer <= 3);

  /// Official Edinburgh Postnatal Depression Scale scoring.
  ///
  /// Questions 1, 2, 4:
  ///   Option indices 0,1,2,3 score 0,1,2,3.
  ///
  /// Questions 3, 5, 6, 7, 8, 9, 10:
  ///   Option indices 0,1,2,3 score 3,2,1,0.
  ///
  /// Possible total: 0–30.
  int get score {
    if (!hasValidAssessment) return 0;

    int total = 0;

    for (int i = 0; i < 10; i++) {
      final answer = answers[i];

      if (i == 0 || i == 1 || i == 3) {
        total += answer;
      } else {
        total += 3 - answer;
      }
    }

    return total;
  }

  /// Screening threshold specified in the supplied
  /// EPDS reference document.
  /// This is NOT a diagnosis.
  bool get possibleDepression =>
      hasValidAssessment && score >= 10;

  /// EPDS Question 10:
  /// 0 = Yes, quite often (score 3)
  /// 1 = Sometimes        (score 2)
  /// 2 = Hardly ever      (score 1)
  /// 3 = Never            (score 0)
  ///
  /// Any answer other than Never requires
  /// the predefined safety-support pathway.
  bool get safetyFlag =>
      hasValidAssessment && answers[9] != 3;

  void register(String value) {
    name = value.trim().isEmpty ? 'Mama' : value.trim();
    notifyListeners();
  }

  void submitAssessment(List<int> value) {
    if (value.length != 10 ||
        value.any((answer) => answer < 0 || answer > 3)) {
      throw ArgumentError(
        'EPDS requires exactly 10 answers, each from 0 to 3.',
      );
    }

    answers = List<int>.of(value);
    assessed = true;

    notifyListeners();
  }

  void addCheckIn(
    int mood,
    int sleep,
    int energy,
    String note,
  ) {
    checkIns.removeWhere(
      (checkIn) =>
          DateUtils.isSameDay(checkIn.date, DateTime.now()),
    );

    checkIns.add(
      CheckIn(
        DateTime.now(),
        mood,
        sleep,
        energy,
        note,
      ),
    );

    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AppScope>()!
          .notifier!;
}
