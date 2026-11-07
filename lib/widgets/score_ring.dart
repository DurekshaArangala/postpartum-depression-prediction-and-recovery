import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.score,
    required this.max,
    this.size = 180,
  });

  final int score;
  final int max;
  final double size;

  @override
  Widget build(BuildContext context) {
    final target = max == 0 ? 0.0 : (score / max).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: target),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(size: Size.square(size), painter: _RingPainter(value)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 54,
                    height: 1.1,
                    fontWeight: FontWeight.w300,
                    color: LiyaaColors.ink,
                  ),
                ),
                Text(
                  'out of $max',
                  style: const TextStyle(
                    fontSize: 14,
                    color: LiyaaColors.inkSoft,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 15.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);

    canvas.drawArc(
      arcRect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = LiyaaColors.plum,
    );

    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: math.pi * 3 / 2,
          colors: [
            LiyaaColors.pinkLight,
            LiyaaColors.pinkSoft,
            LiyaaColors.pink,
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}