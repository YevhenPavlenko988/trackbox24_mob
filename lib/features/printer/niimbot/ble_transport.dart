import 'dart:async';
import 'dart:typed_data';

import 'package:trackbox24_mob/features/printer/niimbot/niimbot_printer.dart';
import 'package:universal_ble/universal_ble.dart';

/// A printer seen while scanning.
class FoundPrinter {
  const FoundPrinter({required this.deviceId, required this.name, this.rssi});

  final String deviceId;
  final String name;
  final int? rssi;

  /// NIIMBOT printers advertise their model as the name: `B3S_P-…`, `B1-…`, `D110-…`.
  bool get looksLikeNiimbot => RegExp(r'^[A-Z]{1,2}\d').hasMatch(name);
}

/// The Bluetooth LE side: finding the printer and the one characteristic it talks over.
class NiimbotBleTransport implements NiimbotTransport {
  NiimbotBleTransport._(
    this._deviceId,
    this._service,
    this._characteristic,
    this._chunkSize,
    this._received,
  );

  /// The GATT service NIIMBOT printers expose; the channel is whichever characteristic in it both notifies and
  /// accepts writes without response.
  static const serviceUuid = 'e7810a71-73ae-499d-8c15-faa9aef0c3f2';

  static const _connectTimeout = Duration(seconds: 15);

  final String _deviceId;
  final String _service;
  final String _characteristic;
  final int _chunkSize;
  final Stream<List<int>> _received;

  @override
  Stream<List<int>> get received => _received;

  /// Lists nearby printers for [duration]. Devices without a name are left out; [all] keeps the ones that do
  /// not look like a NIIMBOT.
  static Stream<FoundPrinter> scan({
    Duration duration = const Duration(seconds: 6),
    bool all = false,
  }) async* {
    await _ensureBluetooth();
    final seen = <String>{};
    final controller = StreamController<FoundPrinter>();
    final sub = UniversalBle.scanStream.listen((d) {
      final name = (d.name ?? d.rawName ?? '').trim();
      if (name.isEmpty || !seen.add(d.deviceId)) return;
      final found = FoundPrinter(
        deviceId: d.deviceId,
        name: name,
        rssi: d.rssi,
      );
      if (all || found.looksLikeNiimbot) controller.add(found);
    });
    await UniversalBle.startScan(scanFilter: ScanFilter(connectableOnly: true));
    final timer = Timer(duration, controller.close);
    try {
      yield* controller.stream;
    } finally {
      timer.cancel();
      await sub.cancel();
      await UniversalBle.stopScan();
    }
  }

  static Future<void> _ensureBluetooth() async {
    final state = await UniversalBle.getBluetoothAvailabilityState();
    switch (state) {
      case AvailabilityState.poweredOn:
      case AvailabilityState.unknown:
      case AvailabilityState.resetting:
        break;
      case AvailabilityState.poweredOff:
        throw const BluetoothUnavailable(BluetoothProblem.off);
      case AvailabilityState.unauthorized:
        throw const BluetoothUnavailable(BluetoothProblem.unauthorized);
      case AvailabilityState.unsupported:
        throw const BluetoothUnavailable(BluetoothProblem.unsupported);
    }
    try {
      await UniversalBle.requestPermissions();
    } on UniversalBleException catch (e) {
      throw BluetoothUnavailable(
        BluetoothProblem.unauthorized,
        detail: e.message,
      );
    }
  }

  /// Connects to a saved printer and subscribes to its channel.
  static Future<NiimbotBleTransport> open(String deviceId) async {
    await _ensureBluetooth();
    try {
      await UniversalBle.connect(deviceId, timeout: _connectTimeout);
    } on UniversalBleException catch (e) {
      throw NiimbotException(NiimbotFailure.timeout, detail: e.message);
    }
    try {
      final services = await UniversalBle.discoverServices(deviceId);
      final channel = _findChannel(services);
      if (channel == null) {
        throw const NiimbotException(
          NiimbotFailure.notSupported,
          detail: 'no NIIMBOT characteristic',
        );
      }
      final (service, characteristic) = channel;
      await UniversalBle.subscribeNotifications(
        deviceId,
        service,
        characteristic,
      );
      // Best effort: iOS and Android 14+ negotiate on their own, older Android starts at 23 bytes.
      var mtu = 23;
      try {
        mtu = await UniversalBle.requestMtu(deviceId, 247);
      } on Exception {
        // Keep the default.
      }
      final received = UniversalBle.characteristicValueStream(
        deviceId,
        characteristic,
      );
      return NiimbotBleTransport._(
        deviceId,
        service,
        characteristic,
        (mtu - 3).clamp(20, 244),
        received,
      );
    } catch (_) {
      await _disconnectQuietly(deviceId);
      rethrow;
    }
  }

  static (String, String)? _findChannel(List<BleService> services) {
    // The known service first, then anything that fits — some firmwares use a different UUID.
    final ordered = [
      ...services.where((s) => s.uuid.toLowerCase() == serviceUuid),
      ...services.where(
        (s) => s.uuid.toLowerCase() != serviceUuid && s.uuid.length > 8,
      ),
    ];
    for (final s in ordered) {
      for (final c in s.characteristics) {
        final p = c.properties;
        if (p.contains(CharacteristicProperty.notify) &&
            p.contains(CharacteristicProperty.writeWithoutResponse)) {
          return (s.uuid, c.uuid);
        }
      }
    }
    return null;
  }

  @override
  Future<void> write(Uint8List bytes) async {
    try {
      for (var offset = 0; offset < bytes.length; offset += _chunkSize) {
        final end = offset + _chunkSize < bytes.length
            ? offset + _chunkSize
            : bytes.length;
        await UniversalBle.write(
          _deviceId,
          _service,
          _characteristic,
          Uint8List.sublistView(bytes, offset, end),
          withoutResponse: true,
        );
      }
    } on UniversalBleException catch (e) {
      throw NiimbotException(NiimbotFailure.disconnected, detail: e.message);
    }
  }

  @override
  Future<void> close() => _disconnectQuietly(_deviceId);

  static Future<void> _disconnectQuietly(String deviceId) async {
    try {
      await UniversalBle.disconnect(deviceId);
    } on Exception {
      // Already gone.
    }
  }
}

enum BluetoothProblem { off, unauthorized, unsupported }

/// Bluetooth itself is not usable; not a printer problem.
class BluetoothUnavailable implements Exception {
  const BluetoothUnavailable(this.problem, {this.detail});

  final BluetoothProblem problem;
  final String? detail;

  @override
  String toString() => 'BluetoothUnavailable($problem, $detail)';
}
