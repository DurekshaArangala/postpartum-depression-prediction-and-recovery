import 'package:flutter/material.dart';
class LiyaaImage extends StatelessWidget {
 final String image; final double height;
 const LiyaaImage(this.image, {super.key, this.height = 220});
 @override Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/$image', height: height, width: double.infinity, fit: BoxFit.cover, alignment: Alignment.center));
}
class SoftCard extends StatelessWidget {
 final Widget child; const SoftCard({super.key, required this.child});
 @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.deepPurple.withValues(alpha: .07), blurRadius: 16, offset: const Offset(0,5))]), child: child);
}
class PageBody extends StatelessWidget {
 final List<Widget> children; const PageBody({super.key, required this.children});
 @override Widget build(BuildContext context) => SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [ ...children.map((w) => Padding(padding: const EdgeInsets.only(bottom: 16), child: w)) ])));
}
class ScreenTitle extends StatelessWidget {
 final String text; const ScreenTitle(this.text,{super.key});
 @override Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF443457)));
}
