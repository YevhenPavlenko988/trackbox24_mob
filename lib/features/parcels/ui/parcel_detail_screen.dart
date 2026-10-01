import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/backend_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_history_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';

class ParcelDetailScreen extends ConsumerWidget {
  const ParcelDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final parcel = ref.watch(parcelProvider(id));
    final isRep = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user.isRepresentative,
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(parcel.value?.code ?? l.parcel_title),
        actions: [
          if (isRep && parcel.hasValue)
            IconButton(
              tooltip: l.common_edit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                await context.push('/parcels/$id/edit');
                ref
                  ..invalidate(parcelProvider(id))
                  ..invalidate(parcelHistoryProvider(id));
              },
            ),
        ],
      ),
      body: switch (parcel) {
        AsyncData(:final value) => _Body(parcel: value, isRep: isRep),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(parcelProvider(id)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.parcel, required this.isRep});

  final Parcel parcel;
  final bool isRep;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool _refreshing = false;

  Future<void> _refreshNp() async {
    setState(() => _refreshing = true);
    final l = AppLocalizations.of(context);
    try {
      await ref.read(parcelApiProvider).refreshFromNp(widget.parcel.id);
      ref
        ..invalidate(parcelProvider(widget.parcel.id))
        ..invalidate(parcelHistoryProvider(widget.parcel.id));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.parcel_npRefreshed)));
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(describeError(context, e))));
      }
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = widget.parcel;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(parcelProvider(p.id))
          ..invalidate(parcelHistoryProvider(p.id));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ParcelStatusChip(p.status),
              if (p.warehouseName != null)
                Text(p.warehouseName!, style: theme.textTheme.bodySmall),
              if (p.needsEnrichment)
                Chip(
                  label: Text(l.parcel_needsEnrichment),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Colors.orange.shade50,
                  side: BorderSide(color: Colors.orange.shade300),
                ),
            ],
          ),
          Text(
            '${l.parcel_statusChanged}: ${formatDateTime(p.statusChangedAt)}'
            '${p.statusChangedBy != null ? ' · ${p.statusChangedBy}' : ''}',
            style: theme.textTheme.bodySmall,
          ),

          SectionTitle(l.parcel_seats),
          if (p.seats.isEmpty)
            Text(
              l.parcel_seatsPending(p.seatsAmount ?? 1),
              style: theme.textTheme.bodyMedium,
            )
          else
            for (final s in p.seats)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  child: Text('${s.seatNumber}'),
                ),
                title: Text(
                  s.barcode ?? '—',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                subtitle: Text(
                  '${formatDateTime(s.statusChangedAt)}'
                  '${s.warehouseName != null ? ' · ${s.warehouseName}' : ''}',
                ),
                trailing: ParcelStatusChip(s.status),
              ),

          SectionTitle(l.parcel_details),
          KvRow(
            l.parcel_client,
            p.clientName,
            onTap: p.clientId == null
                ? null
                : () => context.push('/clients/${p.clientId}'),
          ),
          KvRow(l.parcel_clientPhone, formatPhone(p.clientPhone)),
          KvRow(l.parcel_clientCity, p.clientCity),
          KvRow(l.parcel_clientAddress, p.clientAddress),
          KvRow(l.parcel_representative, p.representativeName),
          KvRow(l.parcel_description, p.description),
          KvRow(l.parcel_seatsAmount, '${p.seatCount}'),
          KvRow(l.parcel_weightKg, formatWeight(p.weightKg)),
          KvRow(l.parcel_declaredValue, formatMoney(p.declaredValue)),
          KvRow(l.parcel_senderName, p.senderName),
          KvRow(l.parcel_senderPhone, formatPhone(p.senderPhone)),
          KvRow(l.parcel_senderCity, p.senderCity),
          KvRow(l.parcel_notes, p.notes),
          if (p.hasPrice)
            KvRow(
              l.parcel_deliveryPrice,
              formatMoney(p.deliveryPrice, p.deliveryPriceCurrency),
            ),
          if (p.hasPrice)
            KvRow(
              l.parcel_paymentStatus,
              p.isPaid ? l.parcel_paid : l.parcel_unpaid,
            ),
          if (p.plannedTripId != null)
            KvRow(l.parcel_plannedTrip, '#${p.plannedTripId}'),
          if (p.tripId != null) KvRow(l.parcel_trip, '#${p.tripId}'),
          KvRow(l.common_createdAt, formatDateTime(p.createdAt)),

          if (p.npTtn != null) ...[
            SectionTitle(
              l.parcel_novaPoshta,
              trailing: widget.isRep
                  ? TextButton.icon(
                      onPressed: _refreshing ? null : _refreshNp,
                      icon: _refreshing
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(l.parcel_npRefresh),
                    )
                  : null,
            ),
            KvRow(l.parcel_npTtn, p.npTtn),
            KvRow(
              l.parcel_npStatus,
              p.npStatusText == null
                  ? null
                  : '${p.npStatusText}${p.npStatusCode != null ? ' (${p.npStatusCode})' : ''}',
            ),
            KvRow(
              l.parcel_npStatusUpdatedAt,
              formatDateTime(p.npStatusUpdatedAt),
            ),
            KvRow(l.parcel_npRecipientWarehouse, p.npRecipientWarehouse),
            KvRow(
              l.parcel_npScheduledDeliveryAt,
              formatDate(p.npScheduledDeliveryAt),
            ),
            KvRow(l.parcel_npArrivedAt, formatDateTime(p.npArrivedAt)),
            KvRow(l.parcel_paidStorageFrom, formatDate(p.npPaidStorageFrom)),
            KvRow(l.parcel_npDeliveryCost, formatMoney(p.npDeliveryCost)),
            KvRow(l.parcel_npCodAmount, formatMoney(p.npCodAmount)),
          ],

          SectionTitle(l.parcel_history),
          _History(id: p.id),
        ],
      ),
    );
  }
}

class _History extends ConsumerWidget {
  const _History({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return switch (ref.watch(parcelHistoryProvider(id))) {
      AsyncData(:final value) when value.isEmpty => Text(
        l.parcel_historyEmpty,
        style: theme.textTheme.bodySmall,
      ),
      AsyncData(:final value) => Column(
        children: [
          for (final e in value)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_icon(e.source), size: 20),
              title: Row(
                children: [
                  Text(
                    formatDateTime(e.changedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (e.seatNumber != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      l.parcel_seatN(e.seatNumber!),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.npStatusText != null)
                    Text('${l.parcel_npStatus}: ${e.npStatusText}')
                  else
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (e.previousStatus != null) ...[
                          ParcelStatusChip(e.previousStatus),
                          const Icon(Icons.arrow_forward, size: 14),
                        ],
                        ParcelStatusChip(e.status),
                        if (e.warehouseName != null)
                          Text(
                            e.warehouseName!,
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  if (e.changedByName != null || e.comment != null)
                    Text(
                      [
                        e.changedByName,
                        translateComment(l, e.comment),
                      ].whereType<String>().join(' — '),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
        ],
      ),
      AsyncError(:final error) => Text(
        describeError(context, error),
        style: TextStyle(color: theme.colorScheme.error),
      ),
      _ => const Padding(
        padding: EdgeInsets.all(8),
        child: LinearProgressIndicator(),
      ),
    };
  }

  IconData _icon(HistorySource? s) => switch (s) {
    HistorySource.SCAN => Icons.qr_code_scanner,
    HistorySource.MANUAL => Icons.back_hand_outlined,
    HistorySource.NOVA_POSHTA => Icons.local_shipping_outlined,
    _ => Icons.smart_toy_outlined,
  };
}
