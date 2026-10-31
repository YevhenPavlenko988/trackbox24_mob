import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_model.dart';
import 'package:trackbox24_mob/features/parcels/data/seat_check.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

/// Photos a move's item may have.
const maxSeatPhotos = 3;

/// The items of a move on its card: «Сканувати переїзд» for a stage, then every item with what it is, its code,
/// status and its photos. Without the moves module the card is read-only: no scanning, and item photos can only
/// be added when the photos module is on (the backend accepts them under either).
///
/// A checkbox chooses items to move by hand, without scanning (a torn label): onto a warehouse, or — by a driver,
/// [canDeliver] — handed over.
class MoveSeatsSection extends ConsumerStatefulWidget {
  const MoveSeatsSection({
    required this.parcel,
    required this.canScan,
    this.canDeliver = false,
    super.key,
  });

  final Parcel parcel;
  final bool canScan;
  final bool canDeliver;

  @override
  ConsumerState<MoveSeatsSection> createState() => _MoveSeatsSectionState();
}

class _MoveSeatsSectionState extends ConsumerState<MoveSeatsSection> {
  final _chosen = <int>{};

  Parcel get parcel => widget.parcel;

  void _toggle(int n) => setState(() {
    if (!_chosen.remove(n)) _chosen.add(n);
  });

  Future<void> _move({required bool deliver}) async {
    Warehouse? warehouse;
    if (!deliver) {
      warehouse = await pickWarehouse(context, ref);
      if (warehouse == null || !mounted) return;
    }
    final numbers = _chosen.toList()..sort();
    final left = deliver
        ? parcel.seats
              .where(
                (s) =>
                    s.status != ParcelStatus.DELIVERED_TO_CLIENT &&
                    !_chosen.contains(s.seatNumber),
              )
              .length
        : 0;
    final moved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ManualMoveSheet(
        parcelId: parcel.id,
        seatNumbers: numbers,
        warehouse: warehouse,
        left: left,
      ),
    );
    if (moved == true && mounted) setState(_chosen.clear);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final canScan = widget.canScan;
    final photos =
        ref.watch(parcelPhotosProvider(parcel.id)).value ??
        const <ParcelPhoto>[];
    final bySeat = <int, List<ParcelPhoto>>{};
    for (final ph in photos) {
      if (ph.seatNumber != null) (bySeat[ph.seatNumber!] ??= []).add(ph);
    }
    final finished =
        parcel.status == ParcelStatus.DELIVERED_TO_CLIENT ||
        parcel.status == ParcelStatus.CANCELLED;
    final moves = ref.watch(movesEnabledProvider);
    final scannable = canScan && !finished && moves;
    final photosEditable =
        canScan && !finished && (moves || ref.watch(photosEnabledProvider));
    final choosing = scannable && _chosen.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.move_seats(parcel.seats.length)),
        if (canScan && !finished && !moves)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l.move_moduleOff,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (scannable)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FilledButton.icon(
              onPressed: () => startMoveScan(context, ref, parcel),
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(l.move_scan),
            ),
          ),
        if (choosing)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.move_chosen(_chosen.length),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      IconButton(
                        tooltip: l.move_clearChoice,
                        onPressed: () => setState(_chosen.clear),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () => _move(deliver: false),
                            icon: const Icon(Icons.warehouse_outlined),
                            label: Text(l.move_toWarehouse),
                          ),
                        ),
                        if (widget.canDeliver) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: () => _move(deliver: true),
                              icon: const Icon(Icons.how_to_reg_outlined),
                              label: Text(l.move_deliver),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        for (final s in parcel.seats)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            selected: _chosen.contains(s.seatNumber),
            onTap: scannable ? () => _toggle(s.seatNumber) : null,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (scannable)
                  Checkbox(
                    value: _chosen.contains(s.seatNumber),
                    onChanged: (_) => _toggle(s.seatNumber),
                  ),
                CircleAvatar(radius: 14, child: Text('${s.seatNumber}')),
              ],
            ),
            title: Text(s.description ?? l.move_noDescription),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    [s.barcode ?? '', ?s.warehouseName].join(' · '),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  ParcelStatusChip(s.status),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (photosEditable || bySeat[s.seatNumber] != null)
                  IconButton(
                    tooltip: l.move_seatPhoto(s.seatNumber),
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => _SeatPhotosSheet(
                        parcel: parcel,
                        seat: s,
                        editable: photosEditable,
                      ),
                    ),
                    icon: Badge(
                      isLabelVisible: (bySeat[s.seatNumber]?.length ?? 0) > 0,
                      label: Text('${bySeat[s.seatNumber]?.length ?? 0}'),
                      child: const Icon(Icons.photo_camera_outlined),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Picks the stage (and the trip or the warehouse it needs) and opens the move's scan screen.
Future<void> startMoveScan(
  BuildContext context,
  WidgetRef ref,
  Parcel parcel,
) async {
  final l = AppLocalizations.of(context);
  final stage = await showModalBottomSheet<SeatCheckStage>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l.move_stagePick,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping_outlined),
            title: Text(l.move_stage_LOAD),
            onTap: () => Navigator.pop(ctx, SeatCheckStage.LOAD),
          ),
          ListTile(
            leading: const Icon(Icons.warehouse_outlined),
            title: Text(l.move_stage_WAREHOUSE),
            onTap: () => Navigator.pop(ctx, SeatCheckStage.WAREHOUSE),
          ),
          ListTile(
            leading: const Icon(Icons.how_to_reg_outlined),
            title: Text(l.move_stage_DELIVER),
            onTap: () => Navigator.pop(ctx, SeatCheckStage.DELIVER),
          ),
        ],
      ),
    ),
  );
  if (stage == null || !context.mounted) return;
  final query = <String, String>{'stage': stage.name};
  if (stage == SeatCheckStage.LOAD) {
    final trip = await context.push<Trip>('/trips/pick');
    if (trip == null) return;
    query['tripId'] = '${trip.id}';
  }
  if (stage == SeatCheckStage.WAREHOUSE) {
    if (!context.mounted) return;
    final w = await pickWarehouse(context, ref);
    if (w == null) return;
    query['warehouseId'] = '${w.id}';
    query['warehouseName'] = w.name;
  }
  if (!context.mounted) return;
  await context.push(
    Uri(
      path: '/parcels/${parcel.id}/move-scan',
      queryParameters: query,
    ).toString(),
  );
  ref.invalidate(parcelProvider(parcel.id));
}

/// Up to three photos of one item: thumbnails, and the camera or the gallery for more.
class _SeatPhotosSheet extends ConsumerStatefulWidget {
  const _SeatPhotosSheet({
    required this.parcel,
    required this.seat,
    required this.editable,
  });

  final Parcel parcel;
  final Seat seat;
  final bool editable;

  @override
  ConsumerState<_SeatPhotosSheet> createState() => _SeatPhotosSheetState();
}

class _SeatPhotosSheetState extends ConsumerState<_SeatPhotosSheet> {
  final _picker = ImagePicker();
  bool _uploading = false;

  Future<void> _add(ImageSource source, int left) async {
    final l = AppLocalizations.of(context);
    List<XFile> files;
    try {
      files = source == ImageSource.camera || left == 1
          ? [?await _picker.pickImage(source: source)]
          : await _picker.pickMultiImage(limit: left);
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      return;
    }
    if (files.isEmpty || !mounted) return;
    setState(() => _uploading = true);
    try {
      await ref
          .read(parcelPhotoApiProvider)
          .add(
            widget.parcel.id,
            files.take(left).toList(),
            seatNumber: widget.seat.seatNumber,
          );
      ref.invalidate(parcelPhotosProvider(widget.parcel.id));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.photos_added(files.length))));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final photos =
        (ref.watch(parcelPhotosProvider(widget.parcel.id)).value ??
                const <ParcelPhoto>[])
            .where((p) => p.seatNumber == widget.seat.seatNumber)
            .toList();
    final left = maxSeatPhotos - photos.length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '№${widget.seat.seatNumber} · ${widget.seat.description ?? l.move_noDescription}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (photos.isNotEmpty)
              Row(
                children: [
                  for (final ph in photos)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: ph.thumbnailUrl,
                          cacheKey: 'thumb-${ph.id}',
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            if (widget.editable && left > 0) ...[
              const SizedBox(height: 12),
              if (_uploading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _add(ImageSource.camera, left),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(l.photos_camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _add(ImageSource.gallery, left),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(l.photos_gallery),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// One of the company's active warehouses, from a bottom sheet.
Future<Warehouse?> pickWarehouse(BuildContext context, WidgetRef ref) async {
  final warehouses = await ref.read(activeWarehousesProvider.future);
  if (!context.mounted) return null;
  return await showModalBottomSheet<Warehouse>(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final w in warehouses)
            ListTile(
              leading: const Icon(Icons.warehouse_outlined),
              title: Text(w.name),
              subtitle: w.address == null ? null : Text(w.address!),
              onTap: () => Navigator.of(ctx).pop(w),
            ),
        ],
      ),
    ),
  );
}

/// Confirms a move by hand: onto [warehouse], or handed over when it is null; with [left] items still to hand over
/// the reason is required. Pops true once the backend has moved them.
class ManualMoveSheet extends ConsumerStatefulWidget {
  const ManualMoveSheet({
    required this.parcelId,
    required this.seatNumbers,
    required this.left,
    this.warehouse,
    super.key,
  });

  final int parcelId;
  final List<int> seatNumbers;
  final Warehouse? warehouse;
  final int left;

  @override
  ConsumerState<ManualMoveSheet> createState() => _ManualMoveSheetState();
}

class _ManualMoveSheetState extends ConsumerState<ManualMoveSheet> {
  final _comment = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final comment = _comment.text.trim();
      await ref
          .read(parcelApiProvider)
          .moveSeats(
            widget.parcelId,
            widget.seatNumbers,
            deliver: widget.warehouse == null,
            warehouseId: widget.warehouse?.id,
            comment: comment.isEmpty ? null : comment,
          );
      ref
        ..invalidate(parcelProvider(widget.parcelId))
        ..invalidate(parcelHistoryProvider(widget.parcelId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.move_manualDone(widget.seatNumbers.length))),
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
    final w = widget.warehouse;
    final needsReason = widget.left > 0;
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
          Text(
            w == null
                ? l.move_manualTitleDeliver
                : l.move_manualTitleWarehouse(w.name),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(l.move_manualHint(widget.seatNumbers.length)),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: _comment,
            builder: (context, value, _) {
              final missing = needsReason && value.text.trim().isEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _comment,
                    maxLength: 1000,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l.move_comment,
                      errorText: missing
                          ? l.move_manualLeft(widget.left)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: missing || _saving ? null : _submit,
                    child: Text(l.move_manualSubmit),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
