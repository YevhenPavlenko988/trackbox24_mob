import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';

/// Full-area error state with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(describeError(context, error), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onRetry, child: Text(l.common_retry)),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({this.text, this.icon = Icons.inbox_outlined, super.key});

  final String? text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            text ?? AppLocalizations.of(context).common_empty,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Label/value row used on detail screens; hidden when the value is empty.
class KvRow extends StatelessWidget {
  const KvRow(this.label, this.value, {this.onTap, super.key});

  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final v = value;
    if (v == null || v.isEmpty || v == '—') return const SizedBox.shrink();
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(label, style: theme.textTheme.bodySmall),
            ),
            Expanded(
              child: Text(
                v,
                style: onTap == null
                    ? null
                    : TextStyle(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {this.trailing, super.key});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.titleMedium),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
