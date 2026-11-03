import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/ui/np_number.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';
import 'package:trackbox24_mob/features/currency/ui/paid_currency.dart';
import 'package:trackbox24_mob/features/moves/move_seats_section.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/parcels/payment_method_ui.dart';
import 'package:trackbox24_mob/features/referral/data/referral_api.dart';
import 'package:trackbox24_mob/features/referral/ui/points_field.dart';
import 'package:trackbox24_mob/features/scan/state/scan_actions.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

/// What the user picked in the sheet: the action plus the context it needed.
class ChosenScanAction {
  const ChosenScanAction(
    this.mode, {
    this.tripId,
    this.warehouse,
    this.paymentMethod,
    this.paidCurrency,
    this.pointsToRedeem,
  });

  final ScanMode mode;
  final int? tripId;

  /// Kept whole so the next scan can show its name without asking again.
  final Warehouse? warehouse;

  /// How the client paid at hand-over; null means they paid nothing.
  final PaymentMethod? paymentMethod;

  /// The client paid in another currency than the price («Курси валют»); null — in the price's.
  final String? paidCurrency;

  /// The parcel's client's points spent on it («Реферальна програма»).
  final int? pointsToRedeem;

  int? get warehouseId => warehouse?.id;
}

/// Shows the scanned parcel and the actions its status allows; returns the one the user picked.
class ScanActionSheet extends ConsumerStatefulWidget {
  const ScanActionSheet({
    required this.code,
    required this.actions,
    required this.onPickTrip,
    this.parcel,
    this.lookupError,
    this.tripId,
    this.tripLabel,
    this.warehouse,
    super.key,
  });

  final String code;
  final List<ScanAction> actions;

  /// Null when the lookup did not return a parcel; [lookupError] then says why.
  final Parcel? parcel;
  final ApiException? lookupError;

  /// Remembered between scans so a run of parcels does not ask every time.
  final int? tripId;

  /// How people name the preselected trip: «14», «14.2»; the id when it is not known.
  final String? tripLabel;
  final Warehouse? warehouse;
  final Future<int?> Function() onPickTrip;

  @override
  ConsumerState<ScanActionSheet> createState() => _ScanActionSheetState();
}

class _ScanActionSheetState extends ConsumerState<ScanActionSheet> {
  late int? _tripId = widget.tripId;
  late Warehouse? _warehouse = widget.warehouse;
  PaymentMethod? _paymentMethod;
  String? _paidCurrency;

  /// «Реферальна програма»: the parcel's client's points (loaded when a payment is picked) and how many to spend.
  RedeemInfo? _redeem;
  int _points = 0;

  /// What is left to pay: the price less the referral discount and the points picked.
  double? get _toPay {
    final p = widget.parcel;
    final due = p?.dueAmount ?? p?.deliveryPrice;
    if (due == null) return null;
    final off = _points * (_redeem?.pointValue ?? 0);
    return ((due - off).clamp(0, double.infinity) * 100).round() / 100;
  }

  Future<void> _loadRedeem() async {
    final p = widget.parcel;
    if (p == null ||
        p.isMove ||
        !ref.read(referralEnabledProvider) ||
        _redeem != null) {
      return;
    }
    try {
      final info = await ref.read(referralApiProvider).forParcel(p.id);
      if (mounted) setState(() => _redeem = info);
    } on ApiException {
      // offline or no rights: the payment goes without points
    }
  }

  String get _priceCurrency => widget.parcel?.deliveryPriceCurrency ?? 'UAH';

  /// The receive scan creates a parcel the backend has never seen, so that is asked for first.
  bool get _wouldCreate =>
      widget.parcel == null && widget.lookupError?.isNotFound == true;

  Future<bool> _confirmCreate() async {
    final l = AppLocalizations.of(context);
    final answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.scanAction_createTitle),
        content: Text(l.scanAction_createBody(widget.code)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.scanAction_createConfirm),
          ),
        ],
      ),
    );
    return answer == true;
  }

  Future<void> _run(ScanAction action) async {
    if (action.mode == ScanMode.receive && _wouldCreate) {
      if (!await _confirmCreate() || !mounted) return;
    }
    if (action.needsTrip && _tripId == null) {
      final picked = await widget.onPickTrip();
      if (picked == null) return;
      if (!mounted) return;
      setState(() => _tripId = picked);
    }
    if (action.needsWarehouse && _warehouse == null) {
      final picked = await _pickWarehouse();
      if (picked == null) return;
      if (!mounted) return;
      setState(() => _warehouse = picked);
    }
    if (!mounted) return;
    Navigator.of(context).pop(
      ChosenScanAction(
        action.mode,
        tripId: _tripId,
        warehouse: _warehouse,
        paymentMethod: _paymentMethod,
        pointsToRedeem: _paymentMethod != null && _points > 0 ? _points : null,
        paidCurrency:
            _paymentMethod != null &&
                ref.read(currencyEnabledProvider) &&
                _paidCurrency != null &&
                _paidCurrency != _priceCurrency
            ? _paidCurrency
            : null,
      ),
    );
  }

  /// Any active warehouse, or a new one added right here.
  Future<Warehouse?> _pickWarehouse() => pickWarehouse(context, ref);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = widget.parcel;
    final canDeliver = widget.actions.any((a) => a.mode == ScanMode.deliver);

    return SafeArea(
      // with a payment, its points and currencies the sheet may be taller than the screen: it scrolls
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NpNumberText(
                p?.code ?? widget.code,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 8),
              if (p != null) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ParcelStatusChip(p.status),
                    if (p.awaitsReceiveScan && p.effectiveNpState != null)
                      NpStateChip(p),
                    if (p.warehouseName != null)
                      Text(p.warehouseName!, style: theme.textTheme.bodySmall),
                    // Which trip it is in: the driver has to notice a parcel sitting in someone else's car.
                    if (p.tripId != null)
                      Text(
                        '· ${l.scanAction_trip(legNo(p.tripNumber ?? p.tripId!, p.tripLegNumber))}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (p.clientName != null)
                  Text(
                    '${l.parcel_client}: ${p.clientName}',
                    style: theme.textTheme.bodyMedium,
                  ),
                if (p.senderName != null)
                  Text(
                    '${l.parcel_sender}: ${p.senderName}',
                    style: theme.textTheme.bodySmall,
                  ),
                if (p.awaitsReceiveScan && p.npTtn != null)
                  Text(
                    '${l.np_toPay}: ${npAmountText(l, p)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (p.hasPrice)
                  Text(
                    '${l.parcel_deliveryPrice}: ${formatMoney(p.deliveryPrice, p.deliveryPriceCurrency)}'
                    '${p.isPaid ? ' · ${l.parcel_paid}' : ''}',
                    style: theme.textTheme.bodySmall,
                  ),
                // the referred client's discount off the price
                if (p.hasPrice && !p.isPaid && (p.referralDiscount ?? 0) > 0)
                  Text(
                    l.points_discount(
                      formatMoney(p.referralDiscount, p.deliveryPriceCurrency),
                      formatMoney(p.dueAmount, p.deliveryPriceCurrency),
                    ),
                    key: const ValueKey('referral-discount'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade800,
                    ),
                  ),
                // the price in the client's currencies, for when they would rather not pay in the price's
                if (p.hasPrice && !p.isPaid && p.deliveryPrice != null)
                  PriceInCurrencies(
                    price: p.dueAmount ?? p.deliveryPrice!,
                    currency: _priceCurrency,
                  ),
              ] else
                Text(
                  _whyNoParcel(context, l),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade900,
                  ),
                ),

              const SizedBox(height: 16),
              if (widget.actions.isEmpty)
                Text(
                  p == null ? l.scanAction_none : noActionsReason(p, l),
                  style: theme.textTheme.bodyMedium,
                )
              else ...[
                // Paying at hand-over is part of the deliver action, so the choice sits with it.
                // Nothing picked means the parcel is handed over unpaid, which the trip reports separately.
                // Already paid («· Оплачено» by the price): nothing to take at hand-over, so no choice — just how it was paid.
                if (canDeliver && p != null && p.hasPrice && p.isPaid) ...[
                  if (_paidHow(l, p) case final how?)
                    Text(
                      how,
                      key: const ValueKey('already-paid'),
                      style: theme.textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 12),
                ] else if (canDeliver && (p?.hasPrice ?? true)) ...[
                  Text(l.scan_paymentMethod, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 6),
                  // compact chips: the three methods fit one row, the sheet stays short
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final m in paymentMethods)
                        ChoiceChip(
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          showCheckmark: false,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          label: Text(paymentMethodShortLabel(l, m)),
                          selected: _paymentMethod == m,
                          onSelected: (on) => setState(() {
                            _paymentMethod = on ? m : null;
                            // the method decides the usual currency: a Ukrainian card pays in hryvnias, a foreign one not
                            _paidCurrency = on
                                ? defaultPaidCurrency(m.name, _priceCurrency)
                                : null;
                            if (!on) _points = 0;
                            if (on) unawaited(_loadRedeem());
                          }),
                        ),
                    ],
                  ),
                  if (_paymentMethod != null && _redeem != null)
                    PointsField(
                      info: _redeem!,
                      value: _points,
                      onChanged: (v) => setState(() => _points = v),
                    ),
                  // the sum is on the currency chips with «Курси валют»; without them it is said here
                  if (_paymentMethod != null &&
                      _points > 0 &&
                      _toPay != null &&
                      !ref.watch(currencyEnabledProvider))
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        l.points_toPay(formatMoney(_toPay, _priceCurrency)),
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  if (_paymentMethod != null && p?.deliveryPrice != null)
                    PaidCurrencyPicker(
                      price: _toPay ?? p!.deliveryPrice!,
                      priceCurrency: _priceCurrency,
                      method: _paymentMethod!.name,
                      value: _paidCurrency ?? _priceCurrency,
                      onChanged: (c) => setState(() => _paidCurrency = c),
                    ),
                  if (_paymentMethod == null) ...[
                    const SizedBox(height: 6),
                    Text(l.scan_paymentNone, style: theme.textTheme.bodySmall),
                  ],
                  const SizedBox(height: 12),
                ],
                for (final action in widget.actions) ...[
                  FilledButton.icon(
                    onPressed: () => _run(action),
                    icon: Icon(action.icon),
                    label: Text(_labelWithContext(l, action)),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
              // The card is the only way to the parcel's details — and to its Nova Poshta shipment for a return parcel.
              if (p != null)
                TextButton.icon(
                  onPressed: () async {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    await router.push('/parcels/${p.id}');
                  },
                  icon: const Icon(Icons.description_outlined),
                  label: Text(l.scanAction_openParcel),
                ),
              // Photos straight from the scan result, when the company has them switched on.
              if (p != null && ref.watch(photosEnabledProvider))
                TextButton.icon(
                  onPressed: () async {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    await router.push('/parcels/${p.id}/photos');
                  },
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: Text(l.scanAction_photos),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.scanAction_pickAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Three different reasons look alike from the outside, so each gets its own wording.
  String _whyNoParcel(BuildContext context, AppLocalizations l) {
    final e = widget.lookupError;
    if (e == null) return l.scanAction_badCode;
    if (e.isTransport) return l.scanAction_offline;
    if (e.isNotFound) {
      return widget.actions.isEmpty
          ? l.scanAction_notFound
          : '${l.scanAction_notFound} ${l.scanAction_notFoundReceive}';
    }
    return describeError(context, e);
  }

  /// The button says where the parcel is going when that is already known.
  String _labelWithContext(AppLocalizations l, ScanAction action) {
    final base = action.label(l);
    if (action.needsTrip && _tripId != null) {
      return '$base · ${l.scan_tripSelected(widget.tripLabel ?? '$_tripId')}';
    }
    if (action.needsWarehouse && _warehouse != null) {
      return '$base · ${_warehouse!.name}';
    }
    return base;
  }
}

/// «Укр. картка · 1 552,79 грн за курсом 1 € = 51,7598 грн» for a parcel paid before the hand-over; null when unknown.
String? _paidHow(AppLocalizations l, Parcel p) {
  final parts = [
    if (p.paymentMethod != null && p.paymentMethod != PaymentMethod.unknown)
      paymentMethodLabel(l, p.paymentMethod),
    ?paidInLine(
      p.paidCurrency,
      p.paidAmount,
      p.paidRate,
      p.deliveryPriceCurrency,
    ),
  ];
  return parts.isEmpty ? null : parts.join(' · ');
}
