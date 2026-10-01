import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue_worker.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// Offline scans: what is waiting, what failed (with the backend's reason), what went through.
class QueueScreen extends ConsumerStatefulWidget {
  const QueueScreen({super.key});

  @override
  ConsumerState<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends ConsumerState<QueueScreen> {
  bool _syncing = false;

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final l = AppLocalizations.of(context);
    final result = await ref.read(scanQueueWorkerProvider).run();
    if (!mounted) return;
    setState(() => _syncing = false);
    final text = result.stoppedByTransport
        ? l.queue_syncOffline
        : result.stoppedByAuth
        ? l.error_unauthorized
        : l.queue_syncDone(result.sent, result.failed);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = ref.watch(queueItemsProvider);
    final pendingCount = ref.watch(pendingCountProvider).value ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.nav_queue),
        actions: [
          TextButton.icon(
            onPressed: _syncing || pendingCount == 0 ? null : _sync,
            icon: _syncing
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: Text(l.queue_sync),
          ),
        ],
      ),
      body: switch (items) {
        AsyncData(:final value) when value.isEmpty => EmptyView(
          text: l.queue_empty,
          icon: Icons.cloud_done_outlined,
        ),
        AsyncData(:final value) => ListView.separated(
          itemCount: value.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _QueueTile(item: value[i]),
        ),
        AsyncError(:final error) => ErrorView(error: error),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _QueueTile extends ConsumerWidget {
  const _QueueTile({required this.item});

  final ScanQueueItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (icon, color, label) = switch (item.status) {
      QueueStatus.pending => (
        Icons.schedule,
        theme.colorScheme.tertiary,
        l.queue_pending,
      ),
      QueueStatus.sending => (
        Icons.sync,
        theme.colorScheme.primary,
        l.queue_sending,
      ),
      QueueStatus.sent => (
        Icons.check_circle_outline,
        Colors.green.shade700,
        l.queue_sent,
      ),
      QueueStatus.failed => (
        Icons.error_outline,
        theme.colorScheme.error,
        l.queue_failed,
      ),
    };
    final queue = ref.read(scanQueueProvider);
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: ColoredBox(
        color: theme.colorScheme.errorContainer,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 24),
            child: Icon(Icons.delete_outline),
          ),
        ),
      ),
      confirmDismiss: (_) async => item.status != QueueStatus.sending,
      onDismissed: (_) => unawaited(queue.remove(item.id)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_modeLabel(l, modeOf(item))}'
              '${item.tripId != null ? ' · ${l.trip_one(item.tripId!)}' : ''}'
              '${item.paymentReceived ?? false ? ' · ${l.scan_paymentReceived}' : ''}'
              ' · ${formatDateTime(item.createdAt)}',
            ),
            if (item.lastError != null)
              Text(
                item.lastError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            if (item.attempts > 0 && item.status == QueueStatus.pending)
              Text(
                l.queue_attempts(item.attempts),
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
        trailing: item.status == QueueStatus.failed
            ? IconButton(
                tooltip: l.common_retry,
                icon: const Icon(Icons.refresh),
                onPressed: () => queue.retry(item.id),
              )
            : null,
      ),
    );
  }

  String _modeLabel(AppLocalizations l, ScanMode m) => switch (m) {
    ScanMode.lookup => l.scan_mode_lookup,
    ScanMode.receive => l.scan_mode_receive,
    ScanMode.load => l.scan_mode_load,
    ScanMode.deliver => l.scan_mode_deliver,
    ScanMode.toWarehouse => l.scan_mode_toWarehouse,
  };
}
