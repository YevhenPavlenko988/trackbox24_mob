import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/moves/move_form_screen.dart';
import 'package:trackbox24_mob/features/moves/move_quick_add.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_model.dart';
import 'package:trackbox24_mob/features/parcels/data/seat_check.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';
import 'package:trackbox24_mob/features/warehouses/new_warehouse.dart';

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
  bool _sharing = false;

  /// The register (XLSX) to the customer through any messenger: saved to a temporary file, then the share sheet.
  Future<void> _shareRegister(BuildContext button) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // the share sheet on an iPad anchors to the button that opened it
    final box = button.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    setState(() => _sharing = true);
    try {
      final bytes = await ref.read(parcelApiProvider).seatRegister(parcel.id);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${parcel.code}-seats.xlsx');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: xlsxMimeType)],
          text: l.move_registerText(parcel.code),
          sharePositionOrigin: origin,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(describeError(context, e))),
      );
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l.move_registerFailed)));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Parcel get parcel => widget.parcel;

  void _toggle(int n) => setState(() {
    if (!_chosen.remove(n)) _chosen.add(n);
  });

  /// Forgotten items, then the labels of just those.
  Future<void> _addItems() async {
    final first = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddMoveItemsSheet(parcelId: parcel.id),
    );
    if (first == null || !mounted) return;
    await context.push<void>('/parcels/${parcel.id}/label?from=$first');
  }

  void _refresh() => ref
    ..invalidate(parcelProvider(parcel.id))
    ..invalidate(parcelHistoryProvider(parcel.id))
    ..invalidate(parcelPhotosProvider(parcel.id));

  /// What the item is: «Диван», «Коробка — посуд»; empty clears it.
  Future<void> _editDescription(Seat seat) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _SeatDescriptionDialog(seat: seat),
    );
    if (text == null || text.trim() == (seat.description ?? '')) return;
    try {
      await ref
          .read(parcelApiProvider)
          .describeSeat(parcel.id, seat.seatNumber, text.trim());
      _refresh();
      messenger.showSnackBar(
        SnackBar(content: Text(l.move_seatDescriptionSaved)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(describeError(context, e))),
      );
    }
  }

  /// An item entered by mistake goes with its photos; the others keep their numbers and labels.
  Future<void> _deleteSeat(Seat seat) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.move_seatDeleteTitle(seat.seatNumber)),
        content: Text(
          [
            if (seat.description != null) '«${seat.description}»',
            l.move_seatDeleteBody,
          ].join('\n\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.common_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.move_seatDeleteConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(parcelApiProvider).deleteSeat(parcel.id, seat.seatNumber);
      if (mounted) setState(() => _chosen.remove(seat.seatNumber));
      _refresh();
      messenger.showSnackBar(
        SnackBar(content: Text(l.move_seatDeleted(seat.seatNumber))),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(describeError(context, e))),
      );
    }
  }

  /// The trip the move is planned on (the next leg after a warehouse), as people name it; null — none planned.
  ({int id, String label})? get _plannedTrip {
    final id = parcel.plannedTripId;
    if (id == null || parcel.tripId != null) return null;
    return (
      id: id,
      label: legNo(parcel.plannedTripNumber ?? id, parcel.tripLegNumber),
    );
  }

  /// Chosen items into a car by hand: the trip the move is planned on, or one picked now.
  Future<void> _load() async {
    var trip = _plannedTrip;
    if (trip == null) {
      final picked = await context.push<Trip>('/trips/pick');
      if (picked == null || !mounted) return;
      trip = (id: picked.id, label: picked.shownNumber);
    }
    final numbers = _chosen.toList()..sort();
    final moved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ManualMoveSheet(
        parcelId: parcel.id,
        seatNumbers: numbers,
        left: 0,
        tripId: trip!.id,
        tripLabel: trip.label,
      ),
    );
    if (moved == true && mounted) setState(_chosen.clear);
  }

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
    // Only what the backend allows for every chosen item and this user (the same rules as a scan there).
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final chosenSeats = parcel.seats.where(
      (s) => _chosen.contains(s.seatNumber),
    );
    final toWarehouse =
        chosenSeats.isNotEmpty &&
        chosenSeats.every((s) => canMoveToWarehouse(s.status, user));
    final toClient =
        widget.canDeliver &&
        chosenSeats.isNotEmpty &&
        chosenSeats.every((s) => canHandOver(s.status, user));
    final toCar =
        chosenSeats.isNotEmpty &&
        chosenSeats.every((s) => canLoadByHand(s.status, user));
    final allAtWarehouse =
        chosenSeats.isNotEmpty &&
        chosenSeats.every((s) => s.status == ParcelStatus.AT_WAREHOUSE);
    // As the backend: an item is deleted before loading only (every item still with us), never the only one.
    const withUs = {
      ParcelStatus.RECEIVED_BY_REPRESENTATIVE,
      ParcelStatus.ACCEPTED_BY_DRIVER,
      ParcelStatus.AT_WAREHOUSE,
    };
    final deletable =
        scannable &&
        parcel.seats.length > 1 &&
        parcel.seats.every(
          (s) => s.status == parcel.status && withUs.contains(s.status),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SectionTitle(l.move_seats(parcel.seats.length))),
            Builder(
              builder: (button) => TextButton.icon(
                onPressed: _sharing ? null : () => _shareRegister(button),
                icon: _sharing
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.ios_share),
                label: Text(l.move_register),
              ),
            ),
          ],
        ),
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
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => startQuickAdd(context, ref, parcel.id),
                    icon: const Icon(Icons.print_outlined),
                    label: Text(l.move_quickAdd),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addItems,
                    icon: const Icon(Icons.playlist_add),
                    label: Text(l.move_addItems),
                  ),
                ),
              ],
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
                  if (!toWarehouse && !toClient && !toCar)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        l.move_noManualAction,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // from the warehouse the usual next step: into the car of the next leg
                          if (toCar)
                            FilledButton.icon(
                              onPressed: _load,
                              icon: const Icon(Icons.local_shipping_outlined),
                              label: Text(
                                _plannedTrip == null
                                    ? l.move_toCar
                                    : l.move_toCarOf(_plannedTrip!.label),
                              ),
                            ),
                          if (toWarehouse)
                            FilledButton.tonalIcon(
                              onPressed: () => _move(deliver: false),
                              icon: const Icon(Icons.warehouse_outlined),
                              label: Text(
                                allAtWarehouse
                                    ? l.move_toOtherWarehouse
                                    : l.move_toWarehouse,
                              ),
                            ),
                          if (toClient)
                            FilledButton.tonalIcon(
                              onPressed: () => _move(deliver: true),
                              icon: const Icon(Icons.how_to_reg_outlined),
                              label: Text(l.move_deliver),
                            ),
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
                if (scannable)
                  PopupMenuButton<bool>(
                    tooltip: l.move_seatActions(s.seatNumber),
                    onSelected: (delete) =>
                        delete ? _deleteSeat(s) : _editDescription(s),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: false,
                        child: ListTile(
                          leading: const Icon(Icons.edit_outlined),
                          title: Text(l.move_seatEditDescription),
                        ),
                      ),
                      if (deletable)
                        PopupMenuItem(
                          value: true,
                          child: ListTile(
                            leading: const Icon(Icons.delete_outline),
                            title: Text(l.move_seatDelete),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Picks the stage (and the trip or the warehouse it needs) and opens the move's scan screen.
///
/// From a scanner: [initialCode] is the item just scanned (it counts on the move's screen), and a known [tripId]
/// (a leg being loaded) means loading into it, with nothing to ask.
Future<void> startMoveScan(
  BuildContext context,
  WidgetRef ref,
  Parcel parcel, {
  String? initialCode,
  int? tripId,
}) async {
  final l = AppLocalizations.of(context);
  final stage = tripId != null
      ? SeatCheckStage.LOAD
      : await showModalBottomSheet<SeatCheckStage>(
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
  if (initialCode != null) query['code'] = initialCode;
  if (stage == SeatCheckStage.LOAD) {
    final id = tripId ?? (await context.push<Trip>('/trips/pick'))?.id;
    if (id == null) return;
    query['tripId'] = '$id';
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
  refreshWarehouses(ref);
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
          ListTile(
            leading: const Icon(Icons.add_business_outlined),
            title: Text(AppLocalizations.of(ctx).warehouse_new),
            onTap: () async {
              final created = await createWarehouse(ctx, ref);
              if (created != null && ctx.mounted) {
                Navigator.of(ctx).pop(created);
              }
            },
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
    this.tripId,
    this.tripLabel,
    super.key,
  });

  final int parcelId;
  final List<int> seatNumbers;
  final Warehouse? warehouse;
  final int left;

  /// Loading into this trip's car instead («14.2» as people name it).
  final int? tripId;
  final String? tripLabel;

  @override
  ConsumerState<ManualMoveSheet> createState() => _ManualMoveSheetState();
}

class _ManualMoveSheetState extends ConsumerState<ManualMoveSheet> {
  final _comment = TextEditingController();
  bool _saving = false;

  /// Shown in the sheet itself: a snackbar would land on the page behind it, hidden by the sheet and the keyboard.
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final comment = _comment.text.trim();
      await ref
          .read(parcelApiProvider)
          .moveSeats(
            widget.parcelId,
            widget.seatNumbers,
            deliver: widget.warehouse == null && widget.tripId == null,
            warehouseId: widget.warehouse?.id,
            tripId: widget.tripId,
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
    } catch (e, st) {
      // any failure, not only the API's: silently doing nothing is what the user saw
      debugPrint('manual seat move failed: $e\n$st');
      if (!mounted) return;
      setState(() => _error = describeError(context, e));
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
            widget.tripId != null
                ? l.move_manualTitleLoad(widget.tripLabel ?? '${widget.tripId}')
                : w == null
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
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.move_manualSubmit),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
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

/// The item's description in a dialog; owns its controller, which must outlive the closing animation.
class _SeatDescriptionDialog extends StatefulWidget {
  const _SeatDescriptionDialog({required this.seat});

  final Seat seat;

  @override
  State<_SeatDescriptionDialog> createState() => _SeatDescriptionDialogState();
}

class _SeatDescriptionDialogState extends State<_SeatDescriptionDialog> {
  late final _controller = TextEditingController(
    text: widget.seat.description ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text('№${widget.seat.seatNumber}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l.move_description),
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.common_cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l.common_save),
        ),
      ],
    );
  }
}

/// Who may put an item onto a warehouse by hand, by its status (the backend's WarehouseMoveService rules):
/// from the representative — representative or manager; accepted by a driver or in the car — any of the three;
/// already at a warehouse (onto another one) — the manager only.
bool canMoveToWarehouse(ParcelStatus? status, User? user) {
  if (user == null) return false;
  return switch (status) {
    ParcelStatus.RECEIVED_BY_REPRESENTATIVE =>
      user.isRepresentative || user.isManager,
    ParcelStatus.ACCEPTED_BY_DRIVER || ParcelStatus.IN_CAR =>
      user.isDriver || user.isRepresentative || user.isManager,
    ParcelStatus.AT_WAREHOUSE => user.isManager,
    _ => false,
  };
}

/// Hand-over by hand: a driver, a representative or a manager, of an item in the car or at a warehouse.
bool canHandOver(ParcelStatus? status, User? user) {
  if (user == null ||
      !(user.isDriver || user.isRepresentative || user.isManager)) {
    return false;
  }
  return status == ParcelStatus.IN_CAR || status == ParcelStatus.AT_WAREHOUSE;
}

/// Loading by hand, as a typed loading scan: an item with us (received, accepted by a driver or at a warehouse), by
/// a driver (into their own trip — the backend checks), a representative or a manager.
bool canLoadByHand(ParcelStatus? status, User? user) {
  if (user == null ||
      !(user.isDriver || user.isRepresentative || user.isManager)) {
    return false;
  }
  return status == ParcelStatus.RECEIVED_BY_REPRESENTATIVE ||
      status == ParcelStatus.ACCEPTED_BY_DRIVER ||
      status == ParcelStatus.AT_WAREHOUSE;
}
