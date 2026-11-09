import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';

/// Illustration from assets/images. Shows a soft icon if the file is missing.
class LiyaaArt extends StatelessWidget {
  const LiyaaArt(
    this.file, {
    super.key,
    this.height,
    this.fit = BoxFit.contain,
    this.fallbackIcon = Icons.favorite_rounded,
    this.iconSize = 56,
  });

  final String file;
  final double? height;
  final BoxFit fit;
  final IconData fallbackIcon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        'assets/images/$file',
        fit: fit,
        errorBuilder: (_, __, ___) => Center(
          child: Icon(
            fallbackIcon,
            size: iconSize,
            color: LiyaaColors.pink.withAlpha(150),
          ),
        ),
      ),
    );
  }
}

/// Small icon from assets/icons. Falls back to a Material icon if missing.
class LiyaaGlyph extends StatelessWidget {
  const LiyaaGlyph(
    this.file, {
    super.key,
    required this.fallback,
    this.size = 28,
    this.color = Colors.white,
  });

  final String file;
  final IconData fallback;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$file',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(fallback, size: size, color: color),
    );
  }
}

/// Rounded pastel card that holds an illustration.
class ArtCard extends StatelessWidget {
  const ArtCard(
    this.file, {
    super.key,
    this.height = 220,
    this.color = LiyaaColors.pinkSoft,
    this.fallbackIcon = Icons.favorite_rounded,
  });

  final String file;
  final double height;
  final Color color;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: LiyaaArt(file, fallbackIcon: fallbackIcon),
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(24, 8, 24, 32),
    this.spacing = 18,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: padding,
        itemCount: children.length,
        separatorBuilder: (_, __) => SizedBox(height: spacing),
        itemBuilder: (_, i) => children[i],
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(
    this.text, {
    super.key,
    this.subtitle,
    this.size = 30,
    this.center = false,
  });

  final String text;
  final String? subtitle;
  final double size;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          text,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: size,
            height: 1.15,
            fontWeight: FontWeight.w700,
            color: LiyaaColors.plum,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 17,
              height: 1.4,
              color: LiyaaColors.plumSoft,
            ),
          ),
        ],
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: LiyaaColors.plum,
      ),
    );
  }
}

/// Flat pastel card.
class TintCard extends StatelessWidget {
  const TintCard({
    super.key,
    required this.child,
    this.color = LiyaaColors.pinkSoft,
    this.padding = const EdgeInsets.all(18),
    this.bordered = false,
  });

  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: bordered ? Border.all(color: LiyaaColors.line, width: 1.2) : null,
      ),
      child: child,
    );
  }
}

/// Coloured square with a white glyph (like Happy / Calm / Relax).
class GlyphTile extends StatelessWidget {
  const GlyphTile({
    super.key,
    required this.color,
    required this.glyph,
    required this.fallback,
    this.size = 48,
  });

  final Color color;
  final String glyph;
  final IconData fallback;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: LiyaaGlyph(glyph, fallback: fallback, size: size * 0.52),
    );
  }
}

/// Tappable tile with a label underneath.
class FeelingTile extends StatelessWidget {
  const FeelingTile({
    super.key,
    required this.label,
    required this.color,
    required this.glyph,
    required this.fallback,
    required this.onTap,
  });

  final String label;
  final Color color;
  final String glyph;
  final IconData fallback;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Material(
            color: color,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onTap,
              child: SizedBox(
                width: 68,
                height: 68,
                child: Center(
                  child: LiyaaGlyph(glyph, fallback: fallback, size: 34),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: LiyaaColors.plum),
          ),
        ],
      ),
    );
  }
}

/// Card like "Peer Group Meetup": title, text, pink action, icon on the right.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.text,
    required this.action,
    required this.onTap,
    required this.color,
    required this.glyph,
    required this.fallback,
    this.accent = LiyaaColors.pink,
  });

  final String title;
  final String text;
  final String action;
  final VoidCallback onTap;
  final Color color;
  final String glyph;
  final IconData fallback;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        color: LiyaaColors.plumSoft,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(
                          action,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: LiyaaColors.pink,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 20,
                          color: LiyaaColors.pink,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              LiyaaGlyph(glyph, fallback: fallback, size: 72, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? LiyaaColors.pinkSoft : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? LiyaaColors.pink : LiyaaColors.line,
          width: selected ? 1.8 : 1.2,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? LiyaaColors.pink : Colors.transparent,
                    border: Border.all(
                      color: selected ? LiyaaColors.pink : LiyaaColors.pinkLight,
                      width: 1.6,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 18, height: 1.3),
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
          backgroundColor: Colors.white,
          selectedColor: LiyaaColors.pink,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : LiyaaColors.plum,
          ),
          side: BorderSide(
            color: selected ? LiyaaColors.pink : LiyaaColors.line,
            width: 1.2,
          ),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        );
      }),
    );
  }
}