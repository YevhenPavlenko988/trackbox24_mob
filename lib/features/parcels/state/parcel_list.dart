import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

part 'parcel_list.freezed.dart';

/// Identifies one server-side list (filters + sort + search). Equal keys share one notifier.
@freezed
abstract class ParcelListKey with _$ParcelListKey {
  const factory ParcelListKey({
    ParcelStatus? status,

    /// Several statuses at once; the backend takes one per request, so they are fetched in parallel and merged.
    @Default(<ParcelStatus>[]) List<ParcelStatus> statuses,
    int? representativeId,
    bool? needsEnrichment,
    String? sort,
    @Default('') String query,
  }) = _ParcelListKey;
}

@freezed
abstract class ParcelListState with _$ParcelListState {
  const factory ParcelListState({
    required List<Parcel> items,
    required bool hasMore,
    required int totalElements,
    @Default(false) bool loadingMore,
    @Default(0) int nextPage,
  }) = _ParcelListState;
}

/// Paged list with pull-to-refresh and infinite scroll.
class ParcelListNotifier extends AsyncNotifier<ParcelListState> {
  ParcelListNotifier(this.key);

  final ParcelListKey key;
  static const _size = 20;
  static const _mergedSize = 200;

  @override
  Future<ParcelListState> build() => _fetch(0);

  Future<ParcelListState> _fetch(int page) async {
    final api = ref.read(parcelApiProvider);
    if (key.statuses.length > 1) {
      // Merged statuses come in one go; paging over several server lists at once is not worth the complexity.
      final pages = await Future.wait([
        for (final status in key.statuses)
          api.list(
            status: status,
            representativeId: key.representativeId,
            needsEnrichment: key.needsEnrichment,
            query: key.query,
            sort: key.sort,
            size: _mergedSize,
          ),
      ]);
      final items = [for (final p in pages) ...p.content];
      return ParcelListState(
        items: items,
        hasMore: false,
        totalElements: pages.fold(0, (n, p) => n + p.totalElements),
        nextPage: 1,
      );
    }
    final res = await api.list(
      status: key.status ?? (key.statuses.isEmpty ? null : key.statuses.first),
      representativeId: key.representativeId,
      needsEnrichment: key.needsEnrichment,
      query: key.query,
      sort: key.sort,
      page: page,
    );
    final prev = page == 0
        ? const <Parcel>[]
        : (state.value?.items ?? const <Parcel>[]);
    return ParcelListState(
      items: [...prev, ...res.content],
      hasMore: res.hasMore,
      totalElements: res.totalElements,
      nextPage: page + 1,
    );
  }

  Future<void> refresh() async {
    state = AsyncData(await _fetch(0));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      state = AsyncData(await _fetch(current.nextPage));
    } catch (e) {
      // Keep what is already loaded; scrolling again retries.
      debugPrint('loadMore failed: $e');
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  /// Drops a parcel that no longer belongs to this list (e.g. received → leaves "to receive").
  void remove(int id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(items: current.items.where((p) => p.id != id).toList()),
    );
  }
}

final parcelListProvider = AsyncNotifierProvider.autoDispose
    .family<ParcelListNotifier, ParcelListState, ParcelListKey>(
      ParcelListNotifier.new,
    );

/// Page size is exposed for tests.
int get parcelListPageSize => ParcelListNotifier._size;
