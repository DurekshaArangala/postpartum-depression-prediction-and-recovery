import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: PageBody(
        children: [
          const ArtCard(
            'ill_profile.png',
            height: 220,
            color: LiyaaColors.lavenderSoft,
          ),
          ScreenTitle(s.name, subtitle: 'Liyaa frontend prototype'),
          TintCard(
            color: Colors.white,
            bordered: true,
            child: Column(
              children: [
                _InfoRow(
                  color: LiyaaColors.pink,
                  icon: Icons.assignment_turned_in_rounded,
                  label: 'Questionnaire',
                  value: s.assessed ? 'Completed' : 'Not yet',
                ),
                const Divider(height: 30),
                _InfoRow(
                  color: LiyaaColors.teal,
                  icon: Icons.favorite_rounded,
                  label: 'Daily check-ins',
                  value: '${s.checkIns.length}',
                ),
              ],
            ),
          ),
          const TintCard(
            color: LiyaaColors.tealSoft,
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 22, color: LiyaaColors.plum),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demo information is stored only while the app is running.',
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (_) => false,
            ),
            child: const Text('Back to welcome screen'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 18))),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}