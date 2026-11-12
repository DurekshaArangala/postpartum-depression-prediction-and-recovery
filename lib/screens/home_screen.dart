import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'chat_screen.dart';
import 'checkin_screen.dart';
import 'ml_questionnaire_screen.dart';
import 'progress_screen.dart';
import 'support_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _go(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final now = DateTime.now();
    final doneToday = s.checkIns.any((c) => _same(c.date, now));
    final week = List.generate(7, (i) => now.add(Duration(days: i - 3)));
    final initial = s.name.trim().isEmpty ? 'L' : s.name.trim()[0].toUpperCase();

    return Scaffold(
      body: PageBody(
        spacing: 22,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: const TextStyle(
                        fontSize: 17,
                        color: LiyaaColors.plumSoft,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Welcome back, '),
                          TextSpan(
                            text: '${s.name}!',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 31, height: 1.15),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LiyaaColors.pink,
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SectionTitle('How are you feeling today?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FeelingTile(
                label: 'Check-in',
                color: LiyaaColors.pink,
                glyph: 'tile_checkin.png',
                fallback: Icons.favorite_rounded,
                onTap: () => _go(context, const CheckInScreen()),
              ),
              FeelingTile(
                label: 'Breathe',
                color: LiyaaColors.lavender,
                glyph: 'tile_breathe.png',
                fallback: Icons.spa_rounded,
                onTap: () => _go(context, const SupportScreen()),
              ),
              FeelingTile(
                label: 'Talk',
                color: LiyaaColors.orange,
                glyph: 'tile_talk.png',
                fallback: Icons.chat_bubble_rounded,
                onTap: () => _go(context, const ChatScreen()),
              ),
              FeelingTile(
                label: 'Progress',
                color: LiyaaColors.teal,
                glyph: 'tile_progress.png',
                fallback: Icons.insights_rounded,
                onTap: () => _go(context, const ProgressScreen()),
              ),
            ],
          ),

          const SectionTitle('Today’s Task'),
          TaskCard(
            title: doneToday ? 'Daily check-in done' : 'Daily check-in',
            text: doneToday
                ? 'Thank you for caring for yourself today.'
                : 'Log your mood, sleep and energy. It takes one minute.',
            action: doneToday ? 'Add another' : 'Start now',
            color: LiyaaColors.pinkSoft,
            glyph: 'task_checkin.png',
            fallback: Icons.favorite_border_rounded,
            onTap: () => _go(context, const CheckInScreen()),
          ),
          TaskCard(
            title: 'Breathe and reset',
            text: 'A calm minute with a gentle breathing circle.',
            action: 'Begin',
            color: LiyaaColors.peach,
            accent: LiyaaColors.orange,
            glyph: 'task_breathe.png',
            fallback: Icons.spa_outlined,
            onTap: () => _go(context, const SupportScreen()),
          ),
          TaskCard(
            title: 'Talk to Liya',
            text: 'A gentle companion for when you need to talk.',
            action: 'Chat',
            color: LiyaaColors.lavenderSoft,
            accent: LiyaaColors.lavender,
            glyph: 'task_talk.png',
            fallback: Icons.chat_bubble_outline_rounded,
            onTap: () => _go(context, const ChatScreen()),
          ),
          
          const SectionTitle('AI Screening & Explainability'),
          TaskCard(
            title: 'Explore your background assessment',
            text: 'Answer 21 questions about your background '
            'and pregnancy history to explore our '
            'experimental machine-learning screening model. '
            'This is not a medical diagnosis.',
            action: 'Start assessment',
            color: LiyaaColors.lavenderSoft,
            accent: LiyaaColors.plum,
            glyph: 'ill_result.png',
            fallback: Icons.psychology_alt_outlined,
            onTap: () => _go(
              context,
              const MlQuestionnaireScreen(),
              ),
            ),


          // this week
          TintCard(
            color: Colors.white,
            bordered: true,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('This week'),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < week.length; i++)
                      _DayDot(
                        letter: _days[week[i].weekday - 1],
                        day: week[i].day,
                        today: i == 3,
                        done: s.checkIns.any((c) => _same(c.date, week[i])),
                      ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: s.assessed ? 'Done' : 'Not yet',
                        label: 'Questionnaire',
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        value: '${s.checkIns.length}',
                        label: 'Daily check-ins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.letter,
    required this.day,
    required this.today,
    required this.done,
  });

  final String letter;
  final int day;
  final bool today;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final bg = today
        ? LiyaaColors.plum
        : done
            ? LiyaaColors.pink
            : LiyaaColors.blush;
    final fg = (today || done) ? Colors.white : LiyaaColors.plum;
    return Column(
      children: [
        Text(
          letter,
          style: const TextStyle(fontSize: 14, color: LiyaaColors.plumSoft),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            border: Border.all(
              color: (today || done) ? bg : LiyaaColors.line,
              width: 1.2,
            ),
          ),
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: LiyaaColors.plumSoft),
        ),
      ],
    );
  }
}