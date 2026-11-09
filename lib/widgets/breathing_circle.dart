import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key, this.size = 190});

  final double size;

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool _inhale = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scale = Tween<double>(begin: 0.62, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.addStatusListener((status) {
      if (!mounted) return;
      if (status == AnimationStatus.forward) setState(() => _inhale = true);
      if (status == AnimationStatus.reverse) setState(() => _inhale = false);
    });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LiyaaColors.pinkLight, width: 2),
            ),
          ),
          AnimatedBuilder(
            animation: _scale,
            builder: (context, _) => Transform.scale(
              scale: _scale.value,
              child: Container(
                width: s * 0.88,
                height: s * 0.88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: LiyaaColors.pinkSoft,
                  border: Border.all(color: LiyaaColors.pink, width: 3.5),
                ),
              ),
            ),
          ),
          Text(
            _inhale ? 'Breathe in' : 'Breathe out',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: LiyaaColors.plum,
            ),
          ),
        ],
      ),
    );
  }
}