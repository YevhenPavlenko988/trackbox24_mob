import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/util/scan_code.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';

/// What a scan does. Which modes a user sees depends on roles (see [modesFor]).
enum ScanMode { lookup, receive, load, deliver, toWarehouse }

List<ScanMode> modesFor(User? user) {
  final rep = user?.isRepresentative ?? false;
  final drv = user?.isDriver ?? false;
  return [
    ScanMode.lookup,
    if (rep) ScanMode.receive,
    if (rep || drv) ScanMode.load,
    if (drv) ScanMode.deliver,
    if (rep || drv) ScanMode.toWarehouse,
  ];
}

/// Extra inputs some modes need; validated in [ScanService.perform].
class ScanParams {
  const ScanParams({
    this.tripId,
    this.warehouseId,
    this.paymentReceived = false,
    this.comment,
  });

  final int? tripId;
  final int? warehouseId;
  final bool paymentReceived;
  final String? comment;
}

sealed class ScanOutcome {
  const ScanOutcome(this.code);

  final String code;
}

class ScanSuccess extends ScanOutcome {
  const ScanSuccess(super.code, this.parcel, {this.created = false});

  final Parcel parcel;

  /// `receive` of an unknown TTN creates the parcel on the fly.
  final bool created;
}

/// No connection: the scan is stored and will be replayed by the queue worker.
class ScanQueued extends ScanOutcome {
  const ScanQueued(super.code);
}

class ScanFailure extends ScanOutcome {
  const ScanFailure(super.code, this.error);

  final ApiException error;
}

/// Rejected before any request: wrong code type for the mode, missing trip/warehouse, duplicate in queue.
class ScanRejected extends ScanOutcome {
  const ScanRejected(super.code, this.reason);

  final ScanRejectReason reason;
}

enum ScanRejectReason {
  notTtn,
  unknownCode,
  tripRequired,
  warehouseRequired,
  alreadyQueued,
}

class ScanService {
  ScanService(this._api, this._queue);

  final ScanApi _api;

  /// Null in contexts without a database (unit tests of the online path).
  final ScanQueue? _queue;

  Future<ScanOutcome> perform(
    ScanMode mode,
    String raw, {
    bool manual = false,
    ScanParams params = const ScanParams(),
  }) async {
    final code = normalizeScanCode(raw);
    final type = classifyScanCode(code);
    // Lookup is the backend's job: it also understands a seat label, an 18-digit code and a waybill replaced by
    // a redirect, none of which the client can recognise. Only an empty code is worth rejecting here.
    if (mode == ScanMode.lookup && code.isEmpty) {
      return ScanRejected(code, ScanRejectReason.unknownCode);
    }
    if (mode != ScanMode.lookup && type == ScanCodeType.unknown) {
      return ScanRejected(code, ScanRejectReason.unknownCode);
    }
    // Receiving goes by waybill; a seat label carries one.
    final ttn = ttnOf(code);
    if (mode == ScanMode.receive && ttn == null) {
      return ScanRejected(code, ScanRejectReason.notTtn);
    }
    if (mode == ScanMode.load && params.tripId == null) {
      return ScanRejected(code, ScanRejectReason.tripRequired);
    }
    if (mode == ScanMode.toWarehouse && params.warehouseId == null) {
      return ScanRejected(code, ScanRejectReason.warehouseRequired);
    }
    if (mode != ScanMode.lookup &&
        _queue != null &&
        await _queue.isPending(mode, code)) {
      return ScanRejected(code, ScanRejectReason.alreadyQueued);
    }

    final req = ScanRequest(
      code: mode == ScanMode.receive ? ttn! : code,
      manualInput: manual,
      comment: params.comment,
      tripId: mode == ScanMode.load ? params.tripId : null,
      paymentReceived: mode == ScanMode.deliver ? params.paymentReceived : null,
      warehouseId: mode == ScanMode.toWarehouse ? params.warehouseId : null,
    );
    try {
      switch (mode) {
        case ScanMode.lookup:
          return ScanSuccess(code, await _api.lookup(code));
        case ScanMode.receive:
          // Unknown TTN → 404 on lookup but receive creates it; detect "created" by probing first.
          final existed = await _exists(ttn!);
          return ScanSuccess(code, await _api.receive(req), created: !existed);
        case ScanMode.load:
          return ScanSuccess(code, await _api.load(req));
        case ScanMode.deliver:
          return ScanSuccess(code, await _api.deliver(req));
        case ScanMode.toWarehouse:
          return ScanSuccess(code, await _api.toWarehouse(req));
      }
    } on ApiException catch (e) {
      if (e.isTransport && mode != ScanMode.lookup && _queue != null) {
        final id = await _queue.enqueue(mode, req);
        return id == null
            ? ScanRejected(code, ScanRejectReason.alreadyQueued)
            : ScanQueued(code);
      }
      return ScanFailure(code, e);
    }
  }

  Future<bool> _exists(String code) async {
    try {
      await _api.lookup(code);
      return true;
    } on ApiException catch (e) {
      if (e.isNotFound) return false;
      rethrow;
    }
  }
}

final scanServiceProvider = Provider<ScanService>(
  (ref) =>
      ScanService(ref.watch(scanApiProvider), ref.watch(scanQueueProvider)),
);
