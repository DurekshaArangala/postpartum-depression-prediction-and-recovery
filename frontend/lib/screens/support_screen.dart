import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import '../widgets/breathing_circle.dart';
import '../widgets/ui.dart';
import 'chat_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gentle support')),
      body: PageBody(
        children: [
          const ArtCard('ill_support.png', height: 230),
          const ScreenTitle(
            'Be gentle with yourself',
            subtitle: 'A few small things that may help today.',
            center: true,
          ),
          const TintCard(
            color: Colors.white,
            bordered: true,
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(
              children: [
                SectionTitle('Take a minute to breathe'),
                SizedBox(height: 4),
                Text(
                  'Follow the circle. Slowly in, slowly out.',
                  style: TextStyle(fontSize: 15, color: LiyaaColors.plumSoft),
                ),
                SizedBox(height: 22),
                BreathingCircle(),
                SizedBox(height: 6),
              ],
            ),
          ),
          const _TipCard(
            icon: Icons.bedtime_rounded,
            glyph: 'tip_rest.png',
            color: LiyaaColors.lavender,
            title: 'Rest when you can',
            text:
                'Even a short rest may help you recharge. Ask someone you trust to help if possible.',
          ),
          const _TipCard(
            icon: Icons.people_rounded,
            glyph: 'tip_connect.png',
            color: LiyaaColors.pink,
            title: 'Stay connected',
            text:
                'Share how you feel with someone you trust. You do not need to handle everything alone.',
          ),
          const _TipCard(
            icon: Icons.local_drink_rounded,
            glyph: 'tip_care.png',
            color: LiyaaColors.orange,
            title: 'Small moments of care',
            text:
                'Have some water, eat regularly, and give yourself permission to take a break.',
          ),
          const TintCard(
            color: LiyaaColors.alertBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'If you need help right now',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
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
                    fontSize: 16,
                    height: 1.45,
                    color: LiyaaColors.alertText,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
            child: const Text('Talk to Liya (demo)'),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.icon,
    required this.glyph,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String glyph;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TintCard(
      color: LiyaaColors.blush,
      bordered: true,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlyphTile(color: color, glyph: glyph, fallback: icon, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.35,
                    color: LiyaaColors.plumSoft,
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