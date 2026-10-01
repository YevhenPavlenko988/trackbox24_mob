import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/clients/data/client_api.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';

/// Search clients by name/phone and pop with the chosen one; "+" creates a new client.
class ClientPickScreen extends ConsumerStatefulWidget {
  const ClientPickScreen({super.key});

  @override
  ConsumerState<ClientPickScreen> createState() => _ClientPickScreenState();
}

class _ClientPickScreenState extends ConsumerState<ClientPickScreen> {
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  Future<void> _create() async {
    final created = await context.push<Client>('/clients/new');
    if (created != null && mounted) context.pop(created);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clients = ref.watch(clientSearchProvider(_query));
    return Scaffold(
      appBar: AppBar(
        title: Text(l.client_pickTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: l.client_searchHint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        child: const Icon(Icons.person_add_alt_1),
      ),
      body: switch (clients) {
        AsyncData(:final value) when value.isEmpty => EmptyView(
          text: l.client_none,
          icon: Icons.person_search_outlined,
        ),
        AsyncData(:final value) => ListView.separated(
          itemCount: value.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final c = value[i];
            return ListTile(
              title: Text(c.displayName),
              subtitle: Text(
                [
                  formatPhone(c.phone),
                  c.city,
                ].whereType<String>().where((s) => s != '—').join(' · '),
              ),
              onTap: () => context.pop(c),
            );
          },
        ),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(clientSearchProvider(_query)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
