import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/parcels/label/label_painter.dart';
import 'package:trackbox24_mob/features/printer/niimbot/ble_transport.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_printer.dart';
import 'package:trackbox24_mob/features/printer/state/printer_settings.dart';

/// Where a print run is.
sealed class PrintJobState {
  const PrintJobState();
}

class PrintIdle extends PrintJobState {
  const PrintIdle();
}

class PrintConnecting extends PrintJobState {
  const PrintConnecting(this.printerName);

  final String printerName;
}

class PrintPrinting extends PrintJobState {
  const PrintPrinting({
    required this.index,
    required this.total,
    required this.progress,
  });

  /// 1-based label being printed.
  final int index;
  final int total;

  /// 0…1 of the current label's rows sent.
  final double progress;
}

class PrintDone extends PrintJobState {
  const PrintDone(this.count, {this.batteryPercent});

  final int count;
  final int? batteryPercent;
}

class PrintFailed extends PrintJobState {
  const PrintFailed(this.error, {required this.printed, required this.total});

  /// A [NiimbotException], a [BluetoothUnavailable] or something unexpected.
  final Object error;

  /// How many labels were done before the failure.
  final int printed;
  final int total;
}

/// Opens the transport; swapped in tests.
typedef TransportOpener = Future<NiimbotTransport> Function(String deviceId);

final transportOpenerProvider = Provider<TransportOpener>(
  (_) => NiimbotBleTransport.open,
);

/// Prints the labels of a parcel one after another on the saved printer: one connection, one page per label.
class PrintJobNotifier extends Notifier<PrintJobState> {
  @override
  PrintJobState build() => const PrintIdle();

  Future<void> printLabels(List<ParcelLabel> labels) async {
    if (state is PrintConnecting || state is PrintPrinting) return;
    final settings = await ref.read(printerSettingsProvider.future);
    final deviceId = settings.deviceId;
    if (deviceId == null) {
      state = PrintFailed(
        const NiimbotException(NiimbotFailure.timeout),
        printed: 0,
        total: labels.length,
      );
      return;
    }
    state = PrintConnecting(settings.name ?? '');
    var printed = 0;
    NiimbotPrinter? printer;
    try {
      // Rendering first: a drawing problem should not leave the printer mid-job.
      final bitmaps = [
        for (final label in labels) await renderLabelBitmap(label),
      ];
      printer = NiimbotPrinter(
        await ref.read(transportOpenerProvider)(deviceId),
      );
      final info = await printer.connect();
      for (var i = 0; i < bitmaps.length; i++) {
        state = PrintPrinting(index: i + 1, total: bitmaps.length, progress: 0);
        await printer.printLabel(
          bitmaps[i],
          density: settings.density,
          onProgress: (p) => state = PrintPrinting(
            index: i + 1,
            total: bitmaps.length,
            progress: p,
          ),
        );
        printed++;
      }
      state = PrintDone(printed, batteryPercent: info.batteryPercent);
    } catch (e) {
      state = PrintFailed(e, printed: printed, total: labels.length);
    } finally {
      await printer?.close();
    }
  }

  void reset() => state = const PrintIdle();
}

final printJobProvider =
    NotifierProvider.autoDispose<PrintJobNotifier, PrintJobState>(
      PrintJobNotifier.new,
    );
