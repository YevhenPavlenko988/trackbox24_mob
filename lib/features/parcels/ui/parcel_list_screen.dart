import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_list.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_tile.dart';

/// A client-side filter chip over the loaded items (the backend has no such filter).
class ParcelListFilter {
  const ParcelListFilter({required this.label, required this.test});

  final String Function(AppLocalizations l) label;
  final bool Function(Parcel p) test;
}

/// Searchable, paged parcel list. [keyFor] turns the search text into the server query.
class ParcelListScreen extends ConsumerStatefulWidget {
  const ParcelListScreen({
    required this.title,
    required this.keyFor,
    this.emptyText,
    this.showCreate = false,
    this.filters = const [],
    this.trailingFor,
    super.key,
  });

  final String title;
  final ParcelListKey Function(String query) keyFor;
  final String? emptyText;
  final bool showCreate;

  /// Optional chips shown under the search; the first one is selected by default.
  final List<ParcelListFilter> filters;

  /// Per-parcel shortcut shown on the right of its row.
  final Widget? Function(Parcel parcel)? trailingFor;

  @override
  ConsumerState<ParcelListScreen> createState() => _ParcelListScreenState();
}

class _ParcelListScreenState extends ConsumerState<ParcelListScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  String _query = '';
  int _filter = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  ParcelListKey get _key => widget.keyFor(_query);

  void _onScroll() {
    if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) {
      unawaited(ref.read(parcelListProvider(_key).notifier).loadMore());
    }
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(parcelListProvider(_key));
    final hasFilters = widget.filters.length > 1;
    final active = hasFilters && _filter < widget.filters.length
        ? widget.filters[_filter]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(hasFilters ? 104 : 56),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _search,
                  onChanged: _onSearch,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l.parcels_searchHint,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _search.clear();
                              _onSearch('');
                            },
                          ),
                  ),
                ),
              ),
              if (hasFilters)
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    itemCount: widget.filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => ChoiceChip(
                      label: Text(widget.filters[i].label(l)),
                      selected: _filter == i,
                      onSelected: (_) => setState(() => _filter = i),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.showCreate
          ? FloatingActionButton(
              onPressed: () => context.push('/parcels/new'),
              child: const Icon(Icons.add),
            )
          : null,
      body: switch (state) {
        AsyncData(value: final raw) => () {
          // Chips filter what is loaded; infinite scroll keeps fetching more from the server.
          final value = active == null
              ? raw
              : raw.copyWith(items: raw.items.where(active.test).toList());
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(parcelListProvider(_key).notifier).refresh(),
            child: value.items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: EmptyView(text: widget.emptyText),
                      ),
                    ],
                  )
                : ListView.separated(
                    controller: _scroll,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: value.items.length + 1,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      if (i == value.items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: value.loadingMore
                                ? const CircularProgressIndicator()
                                : Text(
                                    active == null
                                        ? l.parcels_total(value.totalElements)
                                        : l.parcels_filteredTotal(
                                            value.items.length,
                                            raw.items.length,
                                          ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                          ),
                        );
                      }
                      final p = value.items[i];
                      return ParcelTile(
                        parcel: p,
                        onTap: () => _open(p),
                        trailing: widget.trailingFor?.call(p),
                      );
                    },
                  ),
          );
        }(),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(parcelListProvider(_key)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Future<void> _open(Parcel p) async {
    await context.push('/parcels/${p.id}');
    // The parcel may have changed status while open; reload this list.
    if (mounted) {
      unawaited(ref.read(parcelListProvider(_key).notifier).refresh());
    }
  }
}
