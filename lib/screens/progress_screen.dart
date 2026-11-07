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

    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Your progress'),
      body: PageBody(
        children: [
          const ScreenTitle(
            'One day at a time.',
            subtitle: 'Small steps still count. 🌿',
          ),
          const LiyaaImage('pregnant_front.jpg', height: 190),
          if (all.isEmpty)
            const SoftCard(
              child: Text(
                'Your daily check-ins will appear here. Start by recording how you feel today.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: LiyaaColors.inkSoft,
                ),
              ),
            )
          else ...[
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Eyebrow('Your mood this week'),
                      Text(
                        '${average.toStringAsFixed(1)} / 5',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: LiyaaColors.pinkSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 130,
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
              SoftCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LiyaaColors.pinkGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        moodEmoji(c.mood),
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${c.date.day}/${c.date.month}/${c.date.year}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: LiyaaColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mood ${c.mood}/5  •  Sleep ${c.sleep}/5  •  Energy ${c.energy}/5',
                            style: const TextStyle(
                              fontSize: 13,
                              color: LiyaaColors.inkSoft,
                            ),
                          ),
                          if (c.note.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              c.note,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.45,
                                color: LiyaaColors.ink,
                              ),
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
            style: TextStyle(fontSize: 12, height: 1.5, color: LiyaaColors.inkSoft),
          ),
          const SizedBox(height: 8),
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
    final barHeight = 14 + (mood / 5) * 62;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(moodEmoji(mood), style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        Container(
          width: 20,
          height: barHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [LiyaaColors.pinkSoft, LiyaaColors.pink],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: LiyaaColors.inkSoft),
        ),
      ],
    );
  }
}