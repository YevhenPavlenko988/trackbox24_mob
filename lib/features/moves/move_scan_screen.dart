import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/scan_code.dart';
import 'package:trackbox24_mob/features/moves/move_check_sheet.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/seat_check.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue_worker.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_result_card.dart';
import 'package:trackbox24_mob/features/scan/ui/scanner_view.dart';

/// The scan mode of a stage: into the car, onto a warehouse, to the recipient.
ScanMode scanModeOf(SeatCheckStage stage) => switch (stage) {
  SeatCheckStage.LOAD => ScanMode.load,
  SeatCheckStage.WAREHOUSE => ScanMode.toWarehouse,
  SeatCheckStage.DELIVER => ScanMode.deliver,
};

/// Whether the item is already where the stage puts it.
bool seatDone(Seat s, SeatCheckStage stage, {int? warehouseId}) =>
    switch (stage) {
      SeatCheckStage.LOAD => s.status == ParcelStatus.IN_CAR,
      SeatCheckStage.WAREHOUSE =>
        s.status == ParcelStatus.AT_WAREHOUSE &&
            (warehouseId == null || s.warehouseId == warehouseId),
      SeatCheckStage.DELIVER => s.status == ParcelStatus.DELIVERED_TO_CLIENT,
    };

/// Outcome of one scan on this screen, shown under the camera.
sealed class _Feedback {
  const _Feedback();
}

class _Ok extends _Feedback {
  const _Ok(this.seat, {this.queued = false});
  final Seat seat;
  final bool queued;
}

class _Warn extends _Feedback {
  const _Warn(this.text);
  final String text;
}

/// Scanning the items of one move for one stage, in any order: no question per label, a running «X з N», what is
/// still left, and «Закінчили сканування», which shows what is missing and writes the result into the history.
/// Scans without a connection go to the offline queue like any other scan.
class MoveScanScreen extends ConsumerStatefulWidget {
  const MoveScanScreen({
    required this.parcelId,
    required this.stage,
    this.tripId,
    this.warehouseId,
    this.warehouseName,
    super.key,
  });

  final int parcelId;
  final SeatCheckStage stage;
  final int? tripId;
  final int? warehouseId;
  final String? warehouseName;

  @override
  ConsumerState<MoveScanScreen> createState() => _MoveScanScreenState();
}

class _MoveScanScreenState extends ConsumerState<MoveScanScreen> {
  /// Seats scanned (or queued) on this screen; the ones already done come from the parcel.
  final _scanned = <int>{};
  bool _busy = false;
  _Feedback? _last;

  /// The move as the backend answered the last warehouse scan: once all of it is unloaded, where it goes next.
  Parcel? _unloaded;

  Future<void> _onCode(Parcel move, String raw) async {
    if (_busy) return;
    final l = AppLocalizations.of(context);
    final code = normalizeScanCode(raw);
    if (parcelCodeOf(code) != move.barcode) {
      return await _show(_Warn(l.move_foreign), error: true);
    }
    final number = seatNumberOf(code);
    final seat = number == null
        ? null
        : move.seats.where((s) => s.seatNumber == number).firstOrNull;
    if (seat == null) return await _show(_Warn(l.move_notSeat), error: true);
    if (_scanned.contains(number) || _alreadyDone(seat)) {
      return await _show(_Warn(l.move_already(number!)));
    }
    setState(() => _busy = true);
    final outcome = await ref
        .read(scanServiceProvider)
        .perform(
          scanModeOf(widget.stage),
          code,
          params: ScanParams(
            tripId: widget.tripId,
            warehouseId: widget.warehouseId,
          ),
        );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (outcome) {
      case ScanSuccess(:final parcel):
        _scanned.add(number!);
        if (widget.stage == SeatCheckStage.WAREHOUSE) _unloaded = parcel;
        unawaited(ref.read(scanQueueWorkerProvider).run());
        await _show(_Ok(seat));
      case ScanQueued():
        _scanned.add(number!);
        await _show(_Ok(seat, queued: true));
      case ScanFailure(:final error):
        await _show(_Warn(describeError(context, error)), error: true);
      case ScanRejected(:final reason):
        await _show(
          _Warn(
            reason == ScanRejectReason.alreadyQueued
                ? l.move_already(number!)
                : l.move_notSeat,
          ),
          error: true,
        );
    }
  }

  bool _alreadyDone(Seat s) =>
      seatDone(s, widget.stage, warehouseId: widget.warehouseId);

  Future<void> _show(_Feedback feedback, {bool error = false}) async {
    await (error
        ? HapticFeedback.heavyImpact()
        : HapticFeedback.mediumImpact());
    if (mounted) setState(() => _last = feedback);
  }

  Future<void> _finish(Parcel move) async {
    final api = ref.read(parcelApiProvider);
    SeatCheck? check;
    var offline = false;
    try {
      check = await api.seatCheck(
        move.id,
        widget.stage,
        warehouseId: widget.warehouseId,
      );
    } on ApiException catch (e) {
      if (!e.isTransport || !mounted) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(describeError(context, e))));
        }
        return;
      }
      // Without a connection the phone still knows what it scanned.
      offline = true;
      final missing = [
        for (final s in move.seats)
          if (!_alreadyDone(s) && !_scanned.contains(s.seatNumber)) s,
      ];
      check = SeatCheck(
        stage: widget.stage,
        total: move.seats.length,
        done: move.seats.length - missing.length,
        missing: missing,
      );
    }
    if (!mounted) return;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => MoveCheckSheet(
        parcelId: move.id,
        check: check!,
        warehouseId: widget.warehouseId,
        offline: offline,
      ),
    );
    if (saved == true && mounted) {
      ref.invalidate(parcelProvider(move.id));
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final parcel = ref.watch(parcelProvider(widget.parcelId));
    final stageLabel = switch (widget.stage) {
      SeatCheckStage.LOAD => l.move_stage_LOAD,
      SeatCheckStage.WAREHOUSE => l.move_stage_WAREHOUSE,
      SeatCheckStage.DELIVER => l.move_stage_DELIVER,
    };
    final move = parcel.value;
    if (move == null) {
      return Scaffold(
        appBar: AppBar(title: Text(stageLabel)),
        body: Center(
          child: parcel.hasError
              ? Text(describeError(context, parcel.error!))
              : const CircularProgressIndicator(),
        ),
      );
    }
    final remaining = [
      for (final s in move.seats)
        if (!_alreadyDone(s) && !_scanned.contains(s.seatNumber)) s,
    ];
    final total = move.seats.length;
    final done = total - remaining.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(stageLabel),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Text(
                  l.move_progress(done, total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done / total,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    color: remaining.isEmpty ? Colors.green : null,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  move.code,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.32,
            child: Stack(
              children: [
                ScannerView(
                  onCode: (code) => _onCode(move, code),
                  enabled: !_busy,
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 12,
                  child: Text(
                    widget.warehouseName == null
                        ? l.move_scanHint
                        : '${l.move_scanHint} · ${widget.warehouseName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                if (_busy) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          if (_last != null) _FeedbackBanner(_last!),
          // a transfer of a route: all unloaded, the next leg (or that there is none yet)
          if (_unloaded case final p?
              when p.plannedRouteId != null &&
                  p.status == ParcelStatus.AT_WAREHOUSE)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: NextLegHint(p),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                remaining.isEmpty
                    ? l.move_allHere
                    : l.move_remaining(remaining.length),
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: remaining.length,
              itemBuilder: (_, i) {
                final s = remaining[i];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    child: Text('${s.seatNumber}'),
                  ),
                  title: Text(s.description ?? l.move_noDescription),
                  subtitle: Text(
                    s.barcode ?? '',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _busy ? null : () => _finish(move),
            icon: const Icon(Icons.fact_check_outlined),
            label: Text(l.move_finish),
          ),
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner(this.feedback);

  final _Feedback feedback;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (color, icon, text) = switch (feedback) {
      _Ok(:final seat, :final queued) => (
        queued ? Colors.orange : Colors.green,
        queued ? Icons.cloud_off : Icons.check_circle,
        queued
            ? l.move_queued(seat.seatNumber)
            : l.move_scanned(
                seat.seatNumber,
                seat.description ?? l.move_noDescription,
              ),
      ),
      _Warn(:final text) => (Colors.red, Icons.error_outline, text),
    };
    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
