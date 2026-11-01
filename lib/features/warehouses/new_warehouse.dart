import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

/// A warehouse added on the way: its name and address; returns it, already in the list of active warehouses.
Future<Warehouse?> createWarehouse(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final name = TextEditingController();
  final address = TextEditingController();
  final created = await showDialog<Warehouse>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.warehouse_new),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.warehouse_name,
              hintText: l.warehouse_nameHint,
            ),
          ),
          TextField(
            controller: address,
            decoration: InputDecoration(labelText: l.warehouse_address),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l.common_cancel),
        ),
        FilledButton(
          onPressed: () async {
            if (name.text.trim().isEmpty) return;
            try {
              final w = await ref
                  .read(warehouseApiProvider)
                  .create(name: name.text.trim(), address: address.text.trim());
              ref.invalidate(activeWarehousesProvider);
              if (ctx.mounted) Navigator.pop(ctx, w);
            } on ApiException catch (e) {
              if (!ctx.mounted) return;
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(describeError(ctx, e))));
            }
          },
          child: Text(l.common_save),
        ),
      ],
    ),
  );
  name.dispose();
  address.dispose();
  return created;
}
