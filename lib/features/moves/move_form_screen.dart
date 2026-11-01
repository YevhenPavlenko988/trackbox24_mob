import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_list.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

/// «+» on a list or a trip: a parcel or a move, whichever modules the company has; both — the user picks.
/// A move made from a trip is scanned into it after its labels.
Future<void> startNewShipment(
  BuildContext context,
  WidgetRef ref, {
  int? tripId,
}) async {
  final parcels = ref.read(parcelsEnabledProvider);
  final moves = ref.read(movesEnabledProvider);
  final moveRoute = tripId == null ? '/moves/new' : '/moves/new?tripId=$tripId';
  if (!moves) {
    await context.push<void>('/parcels/new');
    return;
  }
  if (!parcels) {
    await context.push<void>(moveRoute);
    return;
  }
  final l = AppLocalizations.of(context);
  final route = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.new_whatTitle, style: Theme.of(ctx).textTheme.titleMedium),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(l.new_parcel),
            onTap: () => Navigator.pop(ctx, '/parcels/new'),
          ),
          ListTile(
            leading: const Icon(Icons.chair_outlined),
            title: Text(l.new_move),
            onTap: () => Navigator.pop(ctx, moveRoute),
          ),
        ],
      ),
    ),
  );
  if (route != null && context.mounted) await context.push<void>(route);
}

/// Items a move may have.
const maxMoveSeats = 500;

/// The items typed one per line; blank lines do not count.
List<String> itemLines(String text) => [
  for (final line in text.split('\n'))
    if (line.trim().isNotEmpty) line.trim(),
];

/// A move made on the spot by the driver (or a representative): the sender and the recipient (both clients, the
/// recipient required), from where to where, the items one per line or just how many. Then its labels are printed and, with [tripId], it is scanned into that trip.
///
/// With [parcel] the same form edits that move: who, from where to where, what; the items are edited on its card.
class MoveFormScreen extends ConsumerStatefulWidget {
  const MoveFormScreen({this.tripId, this.parcel, super.key});

  final int? tripId;
  final Parcel? parcel;

  @override
  ConsumerState<MoveFormScreen> createState() => _MoveFormScreenState();
}

class _MoveFormScreenState extends ConsumerState<MoveFormScreen> {
  final _from = TextEditingController();
  final _to = TextEditingController();
  final _description = TextEditingController();
  final _items = TextEditingController();
  final _count = TextEditingController();
  int? _senderId;
  String? _senderName;
  int? _recipientId;
  String? _recipientName;
  bool _byList = true;
  bool _saving = false;
  bool _tried = false;

  bool get _isEdit => widget.parcel != null;

  @override
  void initState() {
    super.initState();
    final p = widget.parcel;
    if (p != null) {
      _senderId = p.senderClientId;
      _senderName = p.senderName;
      _recipientId = p.clientId;
      _recipientName = p.clientName;
      _from.text = p.senderCity ?? '';
      _to.text = p.deliveryCity ?? '';
      _description.text = p.description ?? '';
    }
  }

  @override
  void dispose() {
    for (final c in [_from, _to, _description, _items, _count]) {
      c.dispose();
    }
    super.dispose();
  }

  int get _seats =>
      _byList ? itemLines(_items.text).length : int.tryParse(_count.text) ?? 0;

  /// Sender or recipient from the clients (or a new one); their city fills «звідки» / «куди» while it is empty.
  Future<void> _pickClient({required bool sender}) async {
    final client = await context.push<Client>('/clients/pick');
    if (client == null || !mounted) return;
    setState(() {
      final city = sender ? _from : _to;
      if (sender) {
        _senderId = client.id;
        _senderName = client.displayName;
      } else {
        _recipientId = client.id;
        _recipientName = client.displayName;
      }
      if (city.text.trim().isEmpty && (client.city ?? '').isNotEmpty) {
        city.text = client.city!;
      }
    });
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    setState(() => _tried = true);
    if (_recipientId == null) return;
    if (_isEdit) return await _update();
    if (_seats < 1 || _seats > maxMoveSeats) return;
    setState(() => _saving = true);
    final from = _from.text.trim();
    final to = _to.text.trim();
    final description = _description.text.trim();
    try {
      final move = await ref.read(parcelApiProvider).create({
        'kind': 'MOVE',
        'clientId': _recipientId,
        // the sender's name, phone and city come from their client card
        if (_senderId != null) 'senderClientId': _senderId,
        if (from.isNotEmpty) 'senderCity': from,
        if (to.isNotEmpty) 'deliveryCity': to,
        'description': description.isNotEmpty
            ? description
            : [
                l.move_badge,
                if (from.isNotEmpty || to.isNotEmpty)
                  '${from.isEmpty ? '—' : from} → ${to.isEmpty ? '—' : to}',
              ].join(' '),
        if (_byList)
          'seatDescriptions': itemLines(_items.text)
        else
          'seatsAmount': _seats,
      });
      ref.invalidate(parcelListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.move_created(move.seats.length))),
      );
      // the card first, then its labels; with a trip the scan into it follows the printing
      final router = GoRouter.of(context);
      unawaited(router.pushReplacement('/parcels/${move.id}'));
      await router.push<void>('/parcels/${move.id}/label');
      // then straight into a car: the trip given, or one the driver picks now (backing out skips it)
      final tripId =
          widget.tripId ??
          (await router.push<Trip>(
            Uri(
              path: '/trips/pick',
              queryParameters: {
                if (from.isNotEmpty) 'from': from,
                if (to.isNotEmpty) 'to': to,
              },
            ).toString(),
          ))?.id;
      if (tripId != null) {
        await router.push<void>(
          '/parcels/${move.id}/move-scan?stage=LOAD&tripId=$tripId',
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Only what changed goes to the server (partial update); a new sender brings their name, phone and city.
  Future<void> _update() async {
    final l = AppLocalizations.of(context);
    final p = widget.parcel!;
    final from = _from.text.trim();
    final to = _to.text.trim();
    final description = _description.text.trim();
    final diff = <String, dynamic>{
      if (_recipientId != p.clientId) 'clientId': _recipientId,
      if (_senderId != null && _senderId != p.senderClientId)
        'senderClientId': _senderId,
      if (from.isNotEmpty && from != (p.senderCity ?? '')) 'senderCity': from,
      if (to.isNotEmpty && to != (p.deliveryCity ?? '')) 'deliveryCity': to,
      if (description.isNotEmpty && description != (p.description ?? ''))
        'description': description,
    };
    if (diff.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(parcelApiProvider).update(p.id, diff);
      ref
        ..invalidate(parcelProvider(p.id))
        ..invalidate(parcelHistoryProvider(p.id))
        ..invalidate(parcelListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.move_saved_edit)));
      Navigator.of(context).pop();
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
    final seats = _seats;
    final seatsError = !_tried
        ? null
        : seats < 1
        ? l.move_itemsNone
        : seats > maxMoveSeats
        ? l.move_itemsTooMany
        : null;
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? l.move_editTitle : l.move_newTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.outbox_outlined),
            title: Text(l.move_sender),
            subtitle: Text(_senderName ?? l.move_senderNotSet),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickClient(sender: true),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_pin_circle_outlined),
            title: Text(l.move_recipient),
            subtitle: Text(
              _recipientName ?? l.parcel_clientNotSet,
              style: _tried && _recipientId == null
                  ? TextStyle(color: theme.colorScheme.error)
                  : null,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickClient(sender: false),
          ),
          if (_tried && _recipientId == null)
            Text(
              l.parcel_clientRequired,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _from,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.move_from),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _to,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.move_to),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _description,
            decoration: InputDecoration(
              labelText: l.move_description,
              helperText: l.move_descriptionHint,
            ),
          ),
          if (_isEdit) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(l.common_save),
            ),
          ] else ...[
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(l.move_byList)),
                ButtonSegment(value: false, label: Text(l.move_byCount)),
              ],
              selected: {_byList},
              onSelectionChanged: (v) => setState(() => _byList = v.first),
            ),
            const SizedBox(height: 8),
            if (_byList)
              TextField(
                controller: _items,
                minLines: 5,
                maxLines: 12,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l.move_items,
                  hintText: l.move_itemsHint,
                  helperText: l.move_itemsWillCreate(seats),
                  errorText: seatsError,
                  alignLabelWithHint: true,
                ),
              )
            else
              TextField(
                controller: _count,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l.move_count,
                  helperText: l.move_countHint,
                  errorText: seatsError,
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.print_outlined),
              label: Text(l.move_createAndPrint),
            ),
          ],
        ],
      ),
    );
  }
}

/// Forgotten items added to a move: one per line or how many; pops the first new item's number.
class AddMoveItemsSheet extends ConsumerStatefulWidget {
  const AddMoveItemsSheet({required this.parcelId, super.key});

  final int parcelId;

  @override
  ConsumerState<AddMoveItemsSheet> createState() => _AddMoveItemsSheetState();
}

class _AddMoveItemsSheetState extends ConsumerState<AddMoveItemsSheet> {
  final _items = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _items.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final lines = itemLines(_items.text);
    if (lines.isEmpty) return;
    setState(() => _saving = true);
    try {
      final move = await ref
          .read(parcelApiProvider)
          .addSeats(widget.parcelId, lines);
      ref.invalidate(parcelProvider(widget.parcelId));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.move_itemsAdded(lines.length))));
      // new items get the numbers after the highest (a deleted item leaves a gap), so the first is that − count + 1
      final last = move.seats.fold<int>(
        0,
        (m, s) => s.seatNumber > m ? s.seatNumber : m,
      );
      Navigator.of(context).pop(last - lines.length + 1);
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
    final count = itemLines(_items.text).length;
    return Padding(
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
          Text(l.move_addItems, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l.move_addItemsHint),
          const SizedBox(height: 12),
          TextField(
            controller: _items,
            autofocus: true,
            minLines: 3,
            maxLines: 8,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l.move_items,
              hintText: l.move_itemsHint,
              helperText: l.move_itemsWillCreate(count),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: count == 0 || _saving ? null : _save,
            child: Text(l.move_addItemsSubmit),
          ),
        ],
      ),
    );
  }
}
