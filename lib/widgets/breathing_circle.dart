import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key, this.size = 200});

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
    _scale = Tween<double>(begin: 0.6, end: 1).animate(
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // outer guide ring
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x66F695C5), width: 1.5),
            ),
          ),
          // breathing circle
          AnimatedBuilder(
            animation: _scale,
            builder: (context, _) => Transform.scale(
              scale: _scale.value,
              child: Container(
                width: widget.size * 0.92,
                height: widget.size * 0.92,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      LiyaaColors.pinkLight,
                      LiyaaColors.pinkSoft,
                      LiyaaColors.pink,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: LiyaaColors.glow,
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // label (dark text so it reads on the pink circle)
          Text(
            _inhale ? 'Breathe in' : 'Breathe out',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: LiyaaColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}