import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/providers.dart';

/// The label printer the phone is paired with in the app, and how it prints.
class PrinterSettings {
  const PrinterSettings({
    this.deviceId,
    this.name,
    this.density = defaultDensity,
    this.rollWidthMm = defaultRollWidthMm,
    this.offsetMm = 0,
  });

  /// The B3S family prints 1 (light) … 5 (dark); 3 is the factory default.
  static const defaultDensity = 3;
  static const minDensity = 1;
  static const maxDensity = 5;

  /// The rolls the printer takes: 40 and 50 mm wide with the 70 mm label along the tape, or 70 mm wide with
  /// the label across. The client uses 50×70.
  static const rollWidths = [40, 50, 70];
  static const defaultRollWidthMm = 50;
  static const maxOffsetMm = 6;

  final String? deviceId;
  final String? name;
  final int density;
  final int rollWidthMm;

  /// Sideways shift of the print on the tape, to fine-tune a printer whose roll does not sit dead centre.
  final int offsetMm;

  bool get hasPrinter => deviceId != null && deviceId!.isNotEmpty;

  /// On the narrow rolls the label lies along the tape, so the picture is turned 90° for printing.
  bool get rotate => rollWidthMm < 70;

  /// The label's short side in printer dots: the roll width on the narrow rolls, 40 mm on the 70 mm roll.
  int get labelHeightDots => (rotate ? rollWidthMm : 40) * 8;

  PrinterSettings copyWith({
    String? deviceId,
    String? name,
    int? density,
    int? rollWidthMm,
    int? offsetMm,
    bool clearPrinter = false,
  }) => PrinterSettings(
    deviceId: clearPrinter ? null : deviceId ?? this.deviceId,
    name: clearPrinter ? null : name ?? this.name,
    density: density ?? this.density,
    rollWidthMm: rollWidthMm ?? this.rollWidthMm,
    offsetMm: offsetMm ?? this.offsetMm,
  );
}

class PrinterSettingsNotifier extends AsyncNotifier<PrinterSettings> {
  @override
  Future<PrinterSettings> build() async {
    final store = ref.watch(secureStoreProvider);
    final printer = await store.readPrinter();
    final density = await store.readPrinterDensity();
    final roll = await store.readPrinterRoll();
    final offset = await store.readPrinterOffset();
    return PrinterSettings(
      deviceId: printer?.$1,
      name: printer?.$2,
      rollWidthMm: PrinterSettings.rollWidths.contains(roll)
          ? roll!
          : PrinterSettings.defaultRollWidthMm,
      offsetMm: (offset ?? 0).clamp(
        -PrinterSettings.maxOffsetMm,
        PrinterSettings.maxOffsetMm,
      ),
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

  Future<void> setRollWidth(int mm) async {
    await ref.read(secureStoreProvider).writePrinterRoll(mm);
    state = AsyncData(_current.copyWith(rollWidthMm: mm));
  }

  Future<void> setOffset(int mm) async {
    await ref.read(secureStoreProvider).writePrinterOffset(mm);
    state = AsyncData(_current.copyWith(offsetMm: mm));
  }

  PrinterSettings get _current => state.value ?? const PrinterSettings();
}

final printerSettingsProvider =
    AsyncNotifierProvider<PrinterSettingsNotifier, PrinterSettings>(
      PrinterSettingsNotifier.new,
    );
