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

    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Profile'),
      body: PageBody(
        children: [
          const LiyaaImage('mom_nursing_dark.jpg', height: 230),
          ScreenTitle(s.name, subtitle: 'Liyaa frontend prototype'),
          SoftCard(
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.assignment_turned_in_outlined,
                  label: 'Questionnaire',
                  value: s.assessed ? 'Completed' : 'Not yet',
                ),
                const Divider(height: 30),
                _InfoRow(
                  icon: Icons.favorite_border_rounded,
                  label: 'Daily check-ins',
                  value: '${s.checkIns.length}',
                ),
              ],
            ),
          ),
          const SoftCard(
            gradient: LiyaaColors.plumGradient,
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 20, color: LiyaaColors.pink),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demo information is stored only while the app is running.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: LiyaaColors.ink,
                    ),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBubble(icon, size: 44),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: LiyaaColors.ink),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: LiyaaColors.pinkSoft,
          ),
        ),
      ],
    );
  }
}