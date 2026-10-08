import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/channel_ui.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_history_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/parcels/ui/np_payment_block.dart';

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
        AsyncError(:final error) => _GoneOrError(
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
              if (p.awaitsReceiveScan) NpStateChip(p),
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
              p.seatsAmount == null
                  ? l.parcel_seatsUnknown
                  : l.parcel_seatsPending(p.seatsAmount!),
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
          if (p.channel != null && p.channel != Channel.unknown)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ChannelLine(
                channel: p.channel!,
                details: p.channelDetails,
              ),
            ),
          KvRow(l.parcel_representative, p.representativeName),
          KvRow(l.parcel_description, p.description),
          KvRow(
            l.parcel_seatsAmount,
            p.seatsAmount == null && p.seats.isEmpty ? '?' : '${p.seatCount}',
          ),
          KvRow(l.parcel_weightKg, formatWeight(p.weightKg)),
          KvRow(l.parcel_npVolumeWeight, formatWeight(p.npVolumeWeight)),
          if (p.lengthCm != null || p.widthCm != null || p.heightCm != null)
            KvRow(
              l.parcel_dimensions,
              [p.lengthCm, p.widthCm, p.heightCm]
                  .map(
                    (v) => v == null
                        ? '?'
                        : (v == v.roundToDouble() ? '${v.toInt()}' : '$v'),
                  )
                  .join(' × '),
            ),
          KvRow(l.parcel_deliveryCity, p.deliveryCity),
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
            if (p.npStatusUpdatedAt == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l.np_noTrackingHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange.shade900,
                  ),
                ),
              ),
            KvRow(
              l.parcel_npTtn,
              p.npTtn,
              onTap: () => _copy(context, p.npTtn!),
            ),
            if (p.npPreviousTtn != null)
              KvRow(
                l.np_previousTtn,
                p.npPreviousTtn,
                onTap: () => _copy(context, p.npPreviousTtn!),
              ),
            KvRow(l.np_payerType, npPayerLabel(l, p.npPayerType)),
            KvRow(l.np_paymentMethod, npMethodLabel(l, p.npPaymentMethod)),
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
            // 0.00 from Nova Poshta means "nothing", not a price: hide it.
            if ((p.npDeliveryCost ?? 0) > 0)
              KvRow(l.parcel_npDeliveryCost, formatMoney(p.npDeliveryCost)),
            if ((p.npCodAmount ?? 0) > 0)
              KvRow(l.parcel_npCodAmount, formatMoney(p.npCodAmount)),
            const SizedBox(height: 8),
            NpPaymentBlock(parcel: p),
          ],

          SectionTitle(l.parcel_history),
          _History(id: p.id),
        ],
      ),
    );
  }
}

void _copy(BuildContext context, String value) {
  unawaited(Clipboard.setData(ClipboardData(text: value)));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context).np_copied)),
  );
}

/// 404 means the parcel was merged into another one (Nova Poshta redirect) or deleted: say so and go back.
class _GoneOrError extends StatefulWidget {
  const _GoneOrError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  State<_GoneOrError> createState() => _GoneOrErrorState();
}

class _GoneOrErrorState extends State<_GoneOrError> {
  @override
  void initState() {
    super.initState();
    final e = widget.error;
    if (e is ApiException && e.isNotFound) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).np_gone)),
        );
        Navigator.of(context).maybePop();
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      ErrorView(error: widget.error, onRetry: widget.onRetry);
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
                  // A scan carries the NP status snapshot too, but what changed is OUR status: show that first.
                  if (_showsOurStatus(e))
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
                  if (_showsNpStatus(e))
                    Text(
                      '${l.parcel_npStatus}: ${e.npStatusText}'
                      '${e.npStatusCode != null ? ' (${e.npStatusCode})' : ''}',
                    ),
                  if (e.changedByName != null || e.comment != null)
                    Text(
                      [
                        e.changedByName,
                        e.comment,
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

bool _showsOurStatus(ParcelHistoryEntry e) {
  if (e.status == null) return false;
  if (e.source != HistorySource.NOVA_POSHTA) return true;
  return e.previousStatus != null && e.previousStatus != e.status;
}

bool _showsNpStatus(ParcelHistoryEntry e) {
  if (e.npStatusText == null) return false;
  return e.source == HistorySource.NOVA_POSHTA ||
      e.source == HistorySource.SYSTEM ||
      !_showsOurStatus(e);
}
