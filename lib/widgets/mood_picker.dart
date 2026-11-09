
import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import 'ui.dart';

const List<String> moodLabels = [
  'Very low',
  'Low',
  'Okay',
  'Good',
  'Great',
];

const List<IconData> _moodFallbacks = [
  Icons.sentiment_very_dissatisfied_rounded,
  Icons.sentiment_dissatisfied_rounded,
  Icons.sentiment_neutral_rounded,
  Icons.sentiment_satisfied_rounded,
  Icons.sentiment_very_satisfied_rounded,
];

/// Mood face from assets/icons/mood_1.png … mood_5.png.
class MoodFace extends StatelessWidget {
  const MoodFace(this.mood, {super.key, this.size = 32});

  final int mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    final m = mood.clamp(1, 5).toInt();

    return LiyaaGlyph(
      'mood_$m.png',
      fallback: _moodFallbacks[m - 1],
      size: size,
      color: LiyaaColors.pink,
    );
  }
}

class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            final selected = value == i + 1;

            return Semantics(
              button: true,
              selected: selected,
              label: moodLabels[i],
              child: GestureDetector(
                onTap: () => onChanged(i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? LiyaaColors.pinkSoft
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? LiyaaColors.pink
                          : LiyaaColors.line,
                      width: selected ? 2 : 1.2,
                    ),
                  ),
                  child: MoodFace(
                    i + 1,
                    size: selected ? 36 : 30,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        Text(
          moodLabels[value - 1],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: LiyaaColors.plum,
          ),
        ),
      ],
    );
  }
}
