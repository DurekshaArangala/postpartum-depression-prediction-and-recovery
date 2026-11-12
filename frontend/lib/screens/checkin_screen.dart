import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/mood_picker.dart';
import '../widgets/ui.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int mood = 3;
  int sleep = 3;
  int energy = 3;
  final note = TextEditingController();

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  void _save() {
    AppScope.of(context).addCheckIn(mood, sleep, energy, note.text.trim());
    FocusScope.of(context).unfocus();
    setState(() {
      mood = 3;
      sleep = 3;
      energy = 3;
      note.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Today’s check-in saved for this demo.')),
    );
  }

  Widget _section(String title, Widget child) {
    return TintCard(
      color: LiyaaColors.blush,
      bordered: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily check-in')),
      body: PageBody(
        children: [
          const ScreenTitle(
            'How has today been?',
            subtitle:
                'There are no right or wrong answers. Just be honest with yourself.',
          ),
          _section(
            'Your mood',
            MoodPicker(value: mood, onChanged: (v) => setState(() => mood = v)),
          ),
          _section(
            'How did you sleep?',
            ScaleSelector(
              labels: const ['Very poorly', 'Poorly', 'Okay', 'Well', 'Very well'],
              value: sleep,
              onChanged: (v) => setState(() => sleep = v),
            ),
          ),
          _section(
            'How is your energy?',
            ScaleSelector(
              labels: const ['Exhausted', 'Low', 'Moderate', 'Good', 'Energetic'],
              value: energy,
              onChanged: (v) => setState(() => energy = v),
            ),
          ),
          TextField(
            controller: note,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Anything on your mind? (optional)',
              alignLabelWithHint: true,
            ),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Save today’s check-in'),
          ),
          const Text(
            'Your check-ins are self-reported wellness notes, not medical measurements.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: LiyaaColors.plumSoft),
          ),
        ],
      ),
    );
  }
}