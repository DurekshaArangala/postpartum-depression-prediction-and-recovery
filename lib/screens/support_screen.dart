import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import '../widgets/breathing_circle.dart';
import '../widgets/ui.dart';
import 'chat_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Gentle support'),
      body: PageBody(
        children: [
          const LiyaaImage(
            'pregnant_side.jpg',
            height: 230,
            overlay: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Be gentle with yourself',
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: LiyaaColors.dark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A few small things that may help today.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: LiyaaColors.plum,
                  ),
                ),
              ],
            ),
          ),
          const SoftCard(
            child: Column(
              children: [
                Eyebrow('Take a minute to breathe'),
                SizedBox(height: 6),
                Text(
                  'Follow the circle. Slowly in, slowly out.',
                  style: TextStyle(fontSize: 13, color: LiyaaColors.inkSoft),
                ),
                SizedBox(height: 24),
                BreathingCircle(),
                SizedBox(height: 8),
              ],
            ),
          ),
          const _TipCard(
            icon: Icons.bedtime_outlined,
            title: 'Rest when you can',
            text:
                'Even a short rest may help you recharge. Ask someone you trust to help if possible.',
          ),
          const _TipCard(
            icon: Icons.people_outline_rounded,
            title: 'Stay connected',
            text:
                'Share how you feel with someone you trust. You do not need to handle everything alone.',
          ),
          const _TipCard(
            icon: Icons.local_drink_outlined,
            title: 'Small moments of care',
            text:
                'Have some water, eat regularly, and give yourself permission to take a break.',
          ),
          const SoftCard(
            color: LiyaaColors.alert,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'If you need help right now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: LiyaaColors.alertText,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'If sadness, anxiety, or distress is persistent or worsening, speak '
                  'with a qualified healthcare professional. For immediate danger or '
                  'thoughts of self-harm, seek urgent help.\n\n'
                  'National Mental Health Helpline (Sri Lanka): 1926\n'
                  'Emergency ambulance: 1990',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: LiyaaColors.alertText,
                  ),
                ),
              ],
            ),
          ),
          PillAction(
            label: 'Talk to Liya (demo)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBubble(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LiyaaColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: LiyaaColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}