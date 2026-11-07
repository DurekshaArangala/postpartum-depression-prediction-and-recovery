import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';

/// Dark gradient page. Use instead of Scaffold.
class LiyaaScaffold extends StatelessWidget {
  const LiyaaScaffold({super.key, this.appBar, required this.body});

  final PreferredSizeWidget? appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: LiyaaColors.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }
}

class LiyaaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LiyaaAppBar(this.title, {super.key});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: canPop
                    ? CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Back',
                        onTap: () => Navigator.maybePop(context),
                      )
                    : null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.4,
                      color: LiyaaColors.pinkLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
        ),
      ),
    );
  }
}

/// Round pink gradient button with a dark icon.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LiyaaColors.pinkGradient,
          boxShadow: [
            BoxShadow(
              color: LiyaaColors.glow,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Icon(icon, color: LiyaaColors.dark, size: size * 0.46),
          ),
        ),
      ),
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(22, 8, 22, 32),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView.separated(
            padding: padding,
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (_, i) => children[i],
          ),
        ),
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.text, {super.key, this.subtitle, this.size = 30});

  final String text;
  final String? subtitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            height: 1.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: LiyaaColors.ink,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: LiyaaColors.inkSoft,
            ),
          ),
        ],
      ],
    );
  }
}

/// Small spaced-out caps label in pink.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = LiyaaColors.pink});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
        color: color,
      ),
    );
  }
}

/// Card with the big top-left corner. Plum by default, or a gradient.
/// Text placed on a pink gradient / pink colour should use LiyaaColors.dark.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.color = LiyaaColors.surface,
    this.gradient,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final Color color;
  final LinearGradient? gradient;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final glow = gradient == null
        ? LiyaaColors.shadow
        : gradient!.colors.last.withAlpha(70);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: kCardRadius,
        boxShadow: [
          BoxShadow(color: glow, blurRadius: 26, offset: const Offset(0, 12)),
        ],
      ),
      child: child,
    );
  }
}

/// Illustration in a rounded card. [overlay] sits in the empty half.
/// Overlay text should be dark (images are light/pastel).
class LiyaaImage extends StatelessWidget {
  const LiyaaImage(
    this.name, {
    super.key,
    this.height = 240,
    this.overlay,
  });

  final String name;
  final double height;
  final Widget? overlay;

  static const _figureOnRight = {'mom_baby_right.jpg', 'mom_baby_swaddle.jpg'};
  static const _square = {'mom_nursing_dark.jpg'};

  bool get _right => _figureOnRight.contains(name);

  Alignment get _focus {
    if (_square.contains(name)) return const Alignment(0, -0.3);
    return _right ? const Alignment(0.8, 0) : const Alignment(-0.8, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: kImageRadius,
        boxShadow: [
          BoxShadow(
            color: LiyaaColors.glow,
            blurRadius: 34,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: kImageRadius,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: LiyaaColors.pinkLight),
              Image.asset(
                'assets/images/$name',
                fit: BoxFit.cover,
                alignment: _focus,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: LiyaaColors.pinkSoft),
              ),
              if (overlay != null)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment:
                          _right ? Alignment.centerLeft : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.46,
                        child: overlay,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeIn extends StatelessWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOut,
      child: child,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child),
      ),
    );
  }
}

/// Round icon, pink with a dark glyph by default.
class IconBubble extends StatelessWidget {
  const IconBubble(
    this.icon, {
    super.key,
    this.background = LiyaaColors.pink,
    this.color = LiyaaColors.dark,
    this.size = 48,
  });

  final IconData icon;
  final Color background;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: size * 0.46),
    );
  }
}

/// Pink gradient pill with a dark round arrow button (Shope-style CTA).
class PillAction extends StatelessWidget {
  const PillAction({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LiyaaColors.pinkGradient,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: LiyaaColors.glow,
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: LiyaaColors.dark,
                    ),
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: LiyaaColors.dark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: LiyaaColors.pinkSoft,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? LiyaaColors.dark : LiyaaColors.ink;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? null : LiyaaColors.surface,
        gradient: selected ? LiyaaColors.pinkGradient : null,
        borderRadius: kCardRadius,
        boxShadow: [
          BoxShadow(
            color: selected ? LiyaaColors.glow : LiyaaColors.shadow,
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: kCardRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? LiyaaColors.dark : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? LiyaaColors.dark
                          : const Color(0x99FAD3E4),
                      width: 1.6,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check,
                          size: 16, color: LiyaaColors.pinkSoft)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScaleSelector extends StatelessWidget {
  const ScaleSelector({
    super.key,
    required this.labels,
    required this.value,
    required this.onChanged,
  });

  final List<String> labels;
  final int value; // 1..5
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(labels.length, (i) {
        final selected = value == i + 1;
        return ChoiceChip(
          label: Text(labels[i]),
          selected: selected,
          showCheckmark: false,
          onSelected: (_) => onChanged(i + 1),
          backgroundColor: LiyaaColors.plum,
          selectedColor: LiyaaColors.pink,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? LiyaaColors.dark : LiyaaColors.ink,
          ),
          side: BorderSide.none,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        );
      }),
    );
  }
}