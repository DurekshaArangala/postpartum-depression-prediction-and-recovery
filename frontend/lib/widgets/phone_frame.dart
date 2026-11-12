import 'package:flutter/material.dart';

/// On wide screens (a browser) shows the app inside a rounded phone frame
/// on a soft teal / pink backdrop. On a real phone it does nothing.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.size.width < 640) return child;

    const w = 410.0;
    final h = (mq.size.height - 48).clamp(560.0, 880.0).toDouble();

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC3EEE8), Color(0xFFF9D9EA), Color(0xFFBDEBE5)],
        ),
      ),
      child: Container(
        width: w + 18,
        height: h + 18,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xB3FFFFFF),
          borderRadius: BorderRadius.circular(54),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2A3B1F3D),
              blurRadius: 50,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: MediaQuery(
            data: mq.copyWith(size: Size(w, h)),
            child: child,
          ),
        ),
      ),
    );
  }
}