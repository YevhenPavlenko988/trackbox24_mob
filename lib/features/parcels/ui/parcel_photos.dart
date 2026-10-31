import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_model.dart';

/// Photos of a parcel: thumbnails three in a row, a full-screen viewer, add from camera or gallery, delete.
///
/// Files go up as the picker returns them (HEIC from an iPhone included) in one request — the backend converts
/// and either keeps the whole batch or nothing. Links are presigned and expire in an hour, so a stale list is
/// refetched before it is shown; images are cached by photo id, never by link.
///
/// Without [photosEnabledProvider] the block only appears when photos already exist, read-only.
class ParcelPhotosBlock extends ConsumerStatefulWidget {
  const ParcelPhotosBlock({
    required this.parcel,
    this.standalone = false,
    super.key,
  });

  final Parcel parcel;

  /// Fills a screen of its own (the «Фото» screen from the scan result) instead of a section in the parcel card.
  final bool standalone;

  @override
  ConsumerState<ParcelPhotosBlock> createState() => _ParcelPhotosBlockState();
}

class _ParcelPhotosBlockState extends ConsumerState<ParcelPhotosBlock> {
  final _picker = ImagePicker();
  int _uploading = 0;

  int get _id => widget.parcel.id;

  void _refresh() {
    ref
      ..invalidate(parcelPhotosProvider(_id))
      ..invalidate(parcelHistoryProvider(_id));
  }

  Future<void> _add(int left) async {
    final l = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.photos_camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l.photos_gallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    List<XFile> files;
    try {
      files = switch (source) {
        ImageSource.camera => [
          ?await _picker.pickImage(source: ImageSource.camera),
        ],
        // The gallery lets the user pick only as many as still fit.
        ImageSource.gallery =>
          left == 1
              ? [?await _picker.pickImage(source: ImageSource.gallery)]
              : await _picker.pickMultiImage(limit: left),
      };
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      return;
    }
    if (files.isEmpty || !mounted) return;
    if (files.length > left) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.photos_tooMany(left, files.length))),
      );
      return;
    }
    await _upload(files);
  }

  Future<void> _upload(List<XFile> files) async {
    final l = AppLocalizations.of(context);
    setState(() => _uploading = files.length);
    try {
      await ref.read(parcelPhotoApiProvider).add(_id, files);
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.photos_added(files.length))));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _uploading = 0);
    }
  }

  Future<void> _delete(ParcelPhoto photo) async {
    final l = AppLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.photos_deleteTitle),
        content: Text(l.photos_deleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.photos_delete),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    try {
      await ref.read(parcelPhotoApiProvider).delete(_id, photo.id);
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.photos_deleted)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(describeError(context, e))));
    }
  }

  Future<void> _open(List<ParcelPhoto> photos, int index) async {
    final deleted = await Navigator.of(context).push<ParcelPhoto>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PhotoViewerScreen(
          photos: photos,
          initialIndex: index,
          canDelete: ref.read(photosEnabledProvider),
        ),
      ),
    );
    if (deleted != null && mounted) await _delete(deleted);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final enabled = ref.watch(photosEnabledProvider);
    final photos = ref.watch(parcelPhotosProvider(_id));
    // a move's item photos are shown with its items; this block is the parcel's own
    final list = (photos.value ?? const <ParcelPhoto>[])
        .where((p) => p.seatNumber == null)
        .toList();

    // An hour has passed with the card open: the links are dead, fetch fresh ones instead of showing broken images.
    if (list.any((p) => p.linksExpired)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.invalidate(parcelPhotosProvider(_id)),
      );
    }

    if (!enabled && list.isEmpty && !widget.standalone) {
      return const SizedBox.shrink();
    }

    // The backend wipes a delivered parcel's photos 14 days after hand-over: until then an empty list is just empty.
    final deliveredAt = widget.parcel.status == ParcelStatus.DELIVERED_TO_CLIENT
        ? widget.parcel.statusChangedAt
        : null;
    final photosPurged =
        deliveredAt != null &&
        DateTime.now().difference(deliveredAt) > photoRetention;
    final purgeHint = deliveredAt != null && !photosPurged
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l.photos_purgeHint, style: theme.textTheme.bodySmall),
          )
        : null;

    final left = maxParcelPhotos - list.length - _uploading;
    final canAdd = enabled && photos.hasValue && left > 0 && _uploading == 0;
    final addButton = canAdd
        ? TextButton.icon(
            onPressed: () => _add(left),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: Text(l.photos_add),
          )
        : null;

    final grid = switch (photos) {
      AsyncError(:final error) when list.isEmpty => Text(
        describeError(context, error),
        style: TextStyle(color: theme.colorScheme.error),
      ),
      AsyncLoading() when list.isEmpty => const Padding(
        padding: EdgeInsets.all(8),
        child: LinearProgressIndicator(),
      ),
      _ when list.isEmpty && _uploading == 0 => Text(
        photosPurged ? l.photos_emptyDelivered : l.photos_empty,
        style: theme.textTheme.bodySmall,
      ),
      _ => GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < list.length; i++)
            _Thumb(
              photo: list[i],
              onTap: () => _open(list, i),
              onLongPress: enabled ? () => _delete(list[i]) : null,
              onBroken: () => ref.invalidate(parcelPhotosProvider(_id)),
            ),
          for (var i = 0; i < _uploading; i++)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
    };

    if (widget.standalone) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          grid,
          ?purgeHint,
          if (addButton != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => _add(left),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(l.photos_add),
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.photos_title, trailing: addButton),
        grid,
        ?purgeHint,
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.photo,
    required this.onTap,
    required this.onBroken,
    this.onLongPress,
  });

  final ParcelPhoto photo;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onBroken;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: CachedNetworkImage(
          imageUrl: photo.thumbnailUrl,
          cacheKey: 'thumb-${photo.id}',
          fit: BoxFit.cover,
          placeholder: (_, _) => ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          // A dead link (expired before the refetch) — tapping reloads the list.
          errorWidget: (_, _, _) => InkWell(
            onTap: onBroken,
            child: const Center(child: Icon(Icons.refresh)),
          ),
        ),
      ),
    );
  }
}

/// Full-screen photos with swipe and pinch-zoom. Pops with the photo to delete when the user asks for it;
/// the caller owns the confirmation and the request.
class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({
    required this.photos,
    required this.initialIndex,
    required this.canDelete,
    super.key,
  });

  final List<ParcelPhoto> photos;
  final int initialIndex;
  final bool canDelete;

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final photo = widget.photos[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l.photos_counter(_index + 1, widget.photos.length)),
        actions: [
          if (widget.canDelete)
            IconButton(
              tooltip: l.photos_delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => Navigator.of(context).pop(photo),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.photos.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                maxScale: 5,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.photos[i].url,
                    cacheKey: 'photo-${widget.photos[i].id}',
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const CircularProgressIndicator(),
                    errorWidget: (_, _, _) => const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (photo.createdBy != null || photo.createdAt != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  [
                    photo.createdBy,
                    formatDateTime(photo.createdAt),
                  ].whereType<String>().join(' · '),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// `/parcels/:id/photos` — the photos alone, reached from the scan result where there is no card yet on screen.
class ParcelPhotosScreen extends ConsumerWidget {
  const ParcelPhotosScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final parcel = ref.watch(parcelProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(l.photos_screenTitle(parcel.value?.code ?? '')),
      ),
      body: switch (parcel) {
        AsyncData(:final value) => ParcelPhotosBlock(
          parcel: value,
          standalone: true,
        ),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(parcelProvider(id)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
