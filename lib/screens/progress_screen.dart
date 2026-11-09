import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/mood_picker.dart';
import '../widgets/ui.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final all = AppScope.of(context).checkIns.toList(); // oldest → newest
    final recent = all.length > 7 ? all.sublist(all.length - 7) : all;
    final newestFirst = all.reversed.toList();

    final average = recent.isEmpty
        ? 0.0
        : recent.map((c) => c.mood).reduce((a, b) => a + b) / recent.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
      body: PageBody(
        children: [
          const ArtCard(
            'ill_progress.png',
            height: 190,
            color: LiyaaColors.tealSoft,
          ),
          const ScreenTitle(
            'One day at a time',
            subtitle: 'Small steps still count.',
          ),
          if (all.isEmpty)
            const TintCard(
              color: LiyaaColors.blush,
              bordered: true,
              child: Text(
                'Your daily check-ins will appear here. Start by recording how you feel today.',
                style: TextStyle(fontSize: 17, height: 1.4),
              ),
            )
          else ...[
            TintCard(
              color: LiyaaColors.pinkSoft,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionTitle('Your mood this week'),
                      Text(
                        '${average.toStringAsFixed(1)} / 5',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: LiyaaColors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final c in recent)
                          _MoodBar(
                            mood: c.mood,
                            label: _weekdays[c.date.weekday - 1],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            for (final c in newestFirst)
              TintCard(
                color: Colors.white,
                bordered: true,
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: LiyaaColors.pinkSoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: MoodFace(c.mood, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${c.date.day}/${c.date.month}/${c.date.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mood ${c.mood}/5  •  Sleep ${c.sleep}/5  •  Energy ${c.energy}/5',
                            style: const TextStyle(
                              fontSize: 15,
                              color: LiyaaColors.plumSoft,
                            ),
                          ),
                          if (c.note.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              c.note,
                              style: const TextStyle(fontSize: 16, height: 1.35),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const Text(
            'These are self-reported wellness check-ins, not medical recovery measurements.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.4, color: LiyaaColors.plumSoft),
          ),
        ],
      ),
    );
  }
}

class _MoodBar extends StatelessWidget {
  const _MoodBar({required this.mood, required this.label});

  final int mood;
  final String label;

  @override
  Widget build(BuildContext context) {
    final barHeight = 14 + (mood / 5) * 60;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MoodFace(mood, size: 22),
        const SizedBox(height: 6),
        Container(
          width: 22,
          height: barHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [LiyaaColors.pink, LiyaaColors.lavender],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: LiyaaColors.plumSoft),
        ),
      ],
    );
  }
}