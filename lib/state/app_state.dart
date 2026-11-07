import 'package:flutter/material.dart';
class CheckIn {
  final DateTime date;
  final int mood, sleep, energy;
  final String note;
  CheckIn(this.date, this.mood, this.sleep, this.energy, this.note);
}
class AppState extends ChangeNotifier {
  String name = 'Mama';
  bool assessed = false;
  List<int> answers = [];
  final List<CheckIn> checkIns = [];
  int get score {
    if (answers.length != 10) return 0;
    return List.generate(10, (i) => (i == 0 || i == 1 || i == 3) ? 3 - answers[i] : answers[i]).reduce((a,b) => a+b);
  }
  bool get safetyFlag => answers.length == 10 && answers[9] > 0;
  void register(String value) { name = value.trim().isEmpty ? 'Mama' : value.trim(); notifyListeners(); }
  void submitAssessment(List<int> value) { answers = List.of(value); assessed = true; notifyListeners(); }
  void addCheckIn(int mood, int sleep, int energy, String note) {
    checkIns.removeWhere((c) => DateUtils.isSameDay(c.date, DateTime.now()));
    checkIns.add(CheckIn(DateTime.now(), mood, sleep, energy, note)); notifyListeners();
  }
}
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);
  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
