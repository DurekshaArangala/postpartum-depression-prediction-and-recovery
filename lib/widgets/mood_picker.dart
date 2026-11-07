import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';

const List<String> moodEmojis = ['😢', '😔', '😐', '🙂', '😊'];
const List<String> moodLabels = ['Very low', 'Low', 'Okay', 'Good', 'Great'];

String moodEmoji(int mood) => moodEmojis[(mood.clamp(1, 5)) - 1];

class MoodPicker extends StatelessWidget {
  const MoodPicker({super.key, required this.value, required this.onChanged});

  final int value; // 1..5
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
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: selected ? 62 : 50,
                  height: selected ? 62 : 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? null : LiyaaColors.plum,
                    gradient: selected ? LiyaaColors.pinkGradient : null,
                    boxShadow: [
                      BoxShadow(
                        color: selected ? LiyaaColors.glow : LiyaaColors.shadow,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    moodEmojis[i],
                    style: TextStyle(fontSize: selected ? 31 : 25),
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
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: LiyaaColors.pinkLight,
          ),
        ),
      ],
    );
  }
}