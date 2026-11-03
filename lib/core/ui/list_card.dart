import 'package:flutter/material.dart';

/// A card of a list (trip, parcel, move).
class ListCard extends StatelessWidget {
  const ListCard({
    required this.child,
    this.onTap,
    this.color,
    this.stripe,
    super.key,
  });

  final Widget child;

  /// A warning stripe on the left, e.g. paid storage at Nova Poshta has started.
  final Color? stripe;
  final VoidCallback? onTap;

  /// Background tint, e.g. a parcel whose paid storage has started.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      clipBehavior: Clip.antiAlias,
      color: color,
      child: InkWell(
        onTap: onTap,
        child: stripe == null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 9),
                child: child,
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 5, color: stripe),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 14, 9),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// One line of a card: a small icon and its text.
class CardLine extends StatelessWidget {
  const CardLine(
    this.icon,
    this.text, {
    this.style,
    this.color,
    this.maxLines = 1,
    super.key,
  });

  final IconData icon;
  final String text;
  final TextStyle? style;
  final Color? color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: c),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
                color: color,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small outlined tag at the bottom of a card: «Рейс №1.1», «У плані рейсу №2».
class CardTag extends StatelessWidget {
  const CardTag(this.icon, this.text, {required this.color, super.key});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
