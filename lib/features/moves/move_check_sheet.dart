import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/seat_check.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';

/// «Закінчили сканування»: how many of all, the missing items with where they are now, and a comment — required
/// when the recipient got not everything. Saving writes the result into the move's history. Pops `true` once saved.
class MoveCheckSheet extends ConsumerStatefulWidget {
  const MoveCheckSheet({
    required this.parcelId,
    required this.check,
    this.warehouseId,
    this.offline = false,
    super.key,
  });

  final int parcelId;
  final SeatCheck check;
  final int? warehouseId;

  /// No connection: the summary is what this phone scanned; it cannot be saved now.
  final bool offline;

  @override
  ConsumerState<MoveCheckSheet> createState() => _MoveCheckSheetState();
}

class _MoveCheckSheetState extends ConsumerState<MoveCheckSheet> {
  final _comment = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  bool get _needsComment =>
      widget.check.stage == SeatCheckStage.DELIVER && !widget.check.complete;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(parcelApiProvider)
          .finishSeatCheck(
            widget.parcelId,
            widget.check.stage,
            warehouseId: widget.warehouseId,
            comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).move_saved)),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final c = widget.check;
    final color = c.complete ? Colors.green : Colors.orange.shade800;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.move_summary, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l.move_progress(c.done, c.total),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: c.total == 0 ? 0 : c.done / c.total,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
            const SizedBox(height: 12),
            if (c.complete)
              Text(
                l.move_allHere,
                style: theme.textTheme.titleMedium?.copyWith(color: color),
              )
            else ...[
              Text(
                l.move_missing(c.missing.length),
                style: theme.textTheme.titleSmall,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.3,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final s in c.missing)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 14,
                          child: Text('${s.seatNumber}'),
                        ),
                        title: Text(s.description ?? l.move_noDescription),
                        subtitle: Text(
                          [
                            parcelStatusLabel(l, s.status),
                            ?s.warehouseName,
                          ].join(' · '),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (widget.offline) ...[
              const SizedBox(height: 8),
              Text(
                l.move_offlineSummary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              TextField(
                controller: _comment,
                maxLength: 1000,
                minLines: 1,
                maxLines: 3,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: _needsComment
                      ? l.move_commentRequired
                      : l.move_comment,
                ),
              ),
            ],
            const SizedBox(height: 8),
            FilledButton(
              onPressed:
                  widget.offline ||
                      _saving ||
                      (_needsComment && _comment.text.trim().isEmpty)
                  ? null
                  : _save,
              child: Text(l.move_save),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.move_continue),
            ),
          ],
        ),
      ),
    );
  }
}
