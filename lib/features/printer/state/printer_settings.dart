import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/providers.dart';

/// The label printer the phone is paired with in the app, and how dark it prints.
class PrinterSettings {
  const PrinterSettings({
    this.deviceId,
    this.name,
    this.density = defaultDensity,
  });

  /// The B3S family prints 1 (light) … 5 (dark); 3 is the factory default.
  static const defaultDensity = 3;
  static const minDensity = 1;
  static const maxDensity = 5;

  final String? deviceId;
  final String? name;
  final int density;

  bool get hasPrinter => deviceId != null && deviceId!.isNotEmpty;

  PrinterSettings copyWith({
    String? deviceId,
    String? name,
    int? density,
    bool clearPrinter = false,
  }) => PrinterSettings(
    deviceId: clearPrinter ? null : deviceId ?? this.deviceId,
    name: clearPrinter ? null : name ?? this.name,
    density: density ?? this.density,
  );
}

class PrinterSettingsNotifier extends AsyncNotifier<PrinterSettings> {
  @override
  Future<PrinterSettings> build() async {
    final store = ref.watch(secureStoreProvider);
    final printer = await store.readPrinter();
    final density = await store.readPrinterDensity();
    return PrinterSettings(
      deviceId: printer?.$1,
      name: printer?.$2,
      density: (density ?? PrinterSettings.defaultDensity).clamp(
        PrinterSettings.minDensity,
        PrinterSettings.maxDensity,
      ),
    );
  }

  Future<void> savePrinter(String deviceId, String name) async {
    await ref.read(secureStoreProvider).writePrinter(deviceId, name);
    state = AsyncData(_current.copyWith(deviceId: deviceId, name: name));
  }

  Future<void> forgetPrinter() async {
    await ref.read(secureStoreProvider).writePrinter(null, null);
    state = AsyncData(_current.copyWith(clearPrinter: true));
  }

  Future<void> setDensity(int density) async {
    await ref.read(secureStoreProvider).writePrinterDensity(density);
    state = AsyncData(_current.copyWith(density: density));
  }

  PrinterSettings get _current => state.value ?? const PrinterSettings();
}

final printerSettingsProvider =
    AsyncNotifierProvider<PrinterSettingsNotifier, PrinterSettings>(
      PrinterSettingsNotifier.new,
    );
