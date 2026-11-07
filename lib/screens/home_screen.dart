import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'chat_screen.dart';
import 'checkin_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final now = DateTime.now();
    final doneToday = s.checkIns.any((c) => _same(c.date, now));
    final week = List.generate(7, (i) => now.add(Duration(days: i - 3)));
    final initial = s.name.trim().isEmpty ? '💜' : s.name.trim()[0].toUpperCase();

    return LiyaaScaffold(
      body: PageBody(
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(_greeting()),
                    const SizedBox(height: 6),
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontSize: 36,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        color: LiyaaColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Time to reconnect with yourself',
                      style: TextStyle(fontSize: 14, color: LiyaaColors.inkSoft),
                    ),
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LiyaaColors.pinkGradient,
                  boxShadow: [
                    BoxShadow(
                      color: LiyaaColors.glow,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: LiyaaColors.dark,
                  ),
                ),
              ),
            ],
          ),

          // week strip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < week.length; i++)
                _DayChip(
                  letter: _days[week[i].weekday - 1],
                  day: week[i].day,
                  today: i == 3,
                  done: s.checkIns.any((c) => _same(c.date, week[i])),
                ),
            ],
          ),

          // hero
          FadeIn(
            child: LiyaaImage(
              'mom_nursing.jpg',
              height: 260,
              overlay: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doneToday ? 'You checked in today' : 'How are you today?',
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: LiyaaColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doneToday
                        ? 'Thank you for caring for yourself.'
                        : 'A one-minute check-in.',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: LiyaaColors.plum,
                    ),
                  ),
                  if (!doneToday) ...[
                    const SizedBox(height: 14),
                    _MiniButton(
                      label: 'Check in',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckInScreen()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.assignment_turned_in_outlined,
                  value: s.assessed ? 'Done' : 'Not yet',
                  label: 'Questionnaire',
                  gradient: LiyaaColors.pinkGradient,
                  dark: true,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.favorite_border_rounded,
                  value: '${s.checkIns.length}',
                  label: 'Daily check-ins',
                  gradient: LiyaaColors.plumGradient,
                  dark: false,
                ),
              ),
            ],
          ),

          // chat
          SoftCard(
            child: Row(
              children: [
                const IconBubble(Icons.chat_bubble_outline_rounded, size: 54),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need a moment to talk?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: LiyaaColors.ink,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Liya is here to listen.',
                        style: TextStyle(
                          fontSize: 13,
                          color: LiyaaColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleIconButton(
                  icon: Icons.arrow_forward_rounded,
                  size: 48,
                  tooltip: 'Open Liya chatbot demo',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
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
    return Container(
      width: 44,
      height: 78,
      decoration: BoxDecoration(
        color: today ? null : LiyaaColors.surface,
        gradient: today ? LiyaaColors.pinkGradient : null,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: today ? LiyaaColors.glow : LiyaaColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontSize: 12,
              color: today ? LiyaaColors.plum : LiyaaColors.inkSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$day',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: today ? LiyaaColors.dark : LiyaaColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? (today ? LiyaaColors.dark : LiyaaColors.pink)
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    required this.dark,
  });

  final IconData icon;
  final String value;
  final String label;
  final LinearGradient gradient;
  final bool dark; // true → dark text (on pink), false → light text

  @override
  Widget build(BuildContext context) {
    final fg = dark ? LiyaaColors.dark : LiyaaColors.ink;
    return SoftCard(
      padding: const EdgeInsets.all(18),
      gradient: gradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: dark ? LiyaaColors.dark : LiyaaColors.pink, size: 24),
          const SizedBox(height: 22),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 13, color: fg)),
        ],
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LiyaaColors.dark,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: LiyaaColors.pinkSoft,
            ),
          ),
        ),
      ),
    );
  }
}