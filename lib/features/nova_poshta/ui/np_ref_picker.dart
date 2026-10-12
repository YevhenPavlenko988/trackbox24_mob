import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/nova_poshta/data/np_directory_api.dart';

/// One row of a Nova Poshta directory, as the sheet shows it.
typedef _Option = ({String? ref, String title, String? subtitle});

/// Pick a city. The directories are searched live with the company's Nova Poshta key — without one the backend
/// answers 400 and the sheet shows that message instead of an empty list.
Future<NpRef?> pickNpCity(BuildContext context) {
  final l = AppLocalizations.of(context);
  return _pick(
    context,
    title: l.np_pickCity,
    minQuery: npMinQuery,
    options: (ref, query) => ref
        .watch(npCitiesProvider(query))
        .whenData(
          (list) => [
            for (final c in list)
              (ref: c.ref, title: c.name ?? '', subtitle: c.area),
          ],
        ),
  );
}

Future<NpRef?> pickNpBranch(
  BuildContext context, {
  required String cityRef,
  required bool postomat,
}) {
  final l = AppLocalizations.of(context);
  return _pick(
    context,
    title: postomat ? l.np_pickPostomat : l.np_pickBranch,
    minQuery: 0,
    options: (ref, query) => ref
        .watch(
          npBranchesProvider((
            cityRef: cityRef,
            postomat: postomat,
            query: query,
          )),
        )
        .whenData(
          (list) => [
            for (final b in list) (ref: b.ref, title: b.name ?? '', subtitle: null),
          ],
        ),
  );
}

Future<NpRef?> pickNpStreet(BuildContext context, {required String cityRef}) {
  final l = AppLocalizations.of(context);
  return _pick(
    context,
    title: l.np_pickStreet,
    minQuery: npMinQuery,
    options: (ref, query) => ref
        .watch(npStreetsProvider((cityRef: cityRef, query: query)))
        .whenData(
          (list) => [
            for (final s in list)
              (
                ref: s.ref,
                title: [s.type, s.name].where((x) => x != null && x.isNotEmpty).join(' '),
                subtitle: null,
              ),
          ],
        ),
  );
}

Future<NpRef?> _pick(
  BuildContext context, {
  required String title,
  required int minQuery,
  required AsyncValue<List<_Option>> Function(WidgetRef, String) options,
}) {
  return showModalBottomSheet<NpRef>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _PickSheet(title: title, minQuery: minQuery, options: options),
  );
}

class _PickSheet extends ConsumerStatefulWidget {
  const _PickSheet({
    required this.title,
    required this.minQuery,
    required this.options,
  });

  final String title;
  final int minQuery;
  final AsyncValue<List<_Option>> Function(WidgetRef, String) options;

  @override
  ConsumerState<_PickSheet> createState() => _PickSheetState();
}

class _PickSheetState extends ConsumerState<_PickSheet> {
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  /// An error outlives the request it came from (a key that is not configured, Nova Poshta down), so it wins
  /// over the spinner — otherwise the sheet would just spin.
  Widget _results(
    BuildContext context,
    AsyncValue<List<_Option>> options,
    bool tooShort,
  ) {
    final l = AppLocalizations.of(context);
    if (tooShort) return _Hint(l.np_typeMore(widget.minQuery));
    if (options.hasError) return _Hint(describeError(context, options.error!));
    final value = options.value;
    if (value == null) return const Center(child: CircularProgressIndicator());
    if (value.isEmpty) return _Hint(l.common_empty);
    return ListView.separated(
      itemCount: value.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final o = value[i];
        return ListTile(
          title: Text(o.title),
          subtitle: o.subtitle == null ? null : Text(o.subtitle!),
          onTap: () =>
              Navigator.of(context).pop(NpRef(ref: o.ref, name: o.title)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tooShort = _query.length < widget.minQuery;
    final options = tooShort
        ? const AsyncValue<List<_Option>>.data([])
        : widget.options(ref, _query);
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                autofocus: true,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: l.common_search,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                ),
              ),
            ),
            Expanded(child: _results(context, options, tooShort)),
          ],
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}
