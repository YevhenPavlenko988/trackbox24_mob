import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/parcels/label/label_data.dart';
import 'package:trackbox24_mob/features/parcels/label/label_painter.dart';
import 'package:trackbox24_mob/features/printer/niimbot/ble_transport.dart';
import 'package:trackbox24_mob/features/printer/niimbot/label_bitmap.dart';
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
  const PrintDone(this.count, {this.batteryPercent, this.timings});

  final int count;
  final int? batteryPercent;

  /// How long each stage took, to tell where the wait is.
  final PrintTimings? timings;
}

/// Where the time of a print run went: connecting (with drawing the labels alongside), sending the image of
/// the first label, the printer printing it.
class PrintTimings {
  const PrintTimings({
    required this.connect,
    required this.send,
    required this.print,
  });

  final Duration connect;
  final Duration send;
  final Duration print;

  /// Seconds with one decimal, e.g. `2.4`.
  static String seconds(Duration d) =>
      (d.inMilliseconds / 1000).toStringAsFixed(1);

  @override
  String toString() =>
      'connect ${seconds(connect)} s, send ${seconds(send)} s, print ${seconds(print)} s';
}

class PrintFailed extends PrintJobState {
  const PrintFailed(this.error, {required this.printed, required this.total});

  /// A [NiimbotException], a [BluetoothUnavailable] or something unexpected.
  final Object error;

  /// How many labels were done before the failure.
  final int printed;
  final int total;
}

/// The stages of the last successful print, shown in the printer settings: a slow print can be looked into
/// by a screenshot from the driver.
final lastPrintTimingsProvider =
    NotifierProvider<LastPrintTimings, PrintTimings?>(LastPrintTimings.new);

class LastPrintTimings extends Notifier<PrintTimings?> {
  @override
  PrintTimings? build() => null;

  // ignore: use_setters_to_change_properties — a notifier's method, called as one
  void record(PrintTimings timings) => state = timings;
}

/// Sends how a print went to the server log (`POST /api/print-timings`, looked at in Grafana): the printer is
/// with the client, so this is how a slow print is seen. Fire and forget — a lost report never matters.
typedef PrintReporter = void Function(Map<String, Object?> report);

final printReporterProvider = Provider<PrintReporter>((ref) {
  final dio = ref.watch(dioProvider);
  return (report) => unawaited(() async {
    try {
      final info = await PackageInfo.fromPlatform();
      await dio.post<void>(
        '/api/print-timings',
        data: {
          ...report,
          'platform': defaultTargetPlatform.name,
          'appVersion': '${info.version}+${info.buildNumber}',
        },
      );
    } on Object {
      // Only diagnostics.
    }
  }());
});

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
    final clock = Stopwatch()..start();
    Duration? connected;
    Duration? sent;
    Duration? done;
    int? battery;
    void report(Object? error) {
      int? ms(Duration? to, Duration? from) =>
          to == null ? null : (to - (from ?? Duration.zero)).inMilliseconds;
      ref.read(printReporterProvider)({
        'connectMs': ms(connected, null),
        'sendMs': ms(sent, connected),
        'printMs': ms(done, sent ?? connected),
        'labels': labels.length,
        'printer': settings.name,
        'batteryPercent': battery,
        if (error != null)
          'error': '$error'.substring(0, '$error'.length.clamp(0, 200)),
      });
    }

    try {
      // The labels are drawn while the radio connects; both are done before the printer gets a page, so a
      // drawing problem does not leave it mid-job.
      final transport = ref.read(transportOpenerProvider)(deviceId);
      final List<LabelBitmap> bitmaps;
      try {
        bitmaps = await Future.wait([
          for (final label in labels)
            renderLabelBitmap(
              label,
              heightDots: settings.labelHeightDots.toDouble(),
            ),
        ]);
      } catch (_) {
        unawaited(transport.then((t) => t.close(), onError: (_) {}));
        rethrow;
      }
      printer = NiimbotPrinter(await transport);
      final info = await printer.connect();
      battery = info.batteryPercent;
      connected = clock.elapsed;
      for (var i = 0; i < bitmaps.length; i++) {
        state = PrintPrinting(index: i + 1, total: bitmaps.length, progress: 0);
        await printer.printLabel(
          bitmaps[i],
          density: settings.density,
          rotate: settings.rotate,
          offsetDots: settings.offsetMm * 8,
          onProgress: (p) {
            if (p >= 1 && i == 0) sent ??= clock.elapsed;
            state = PrintPrinting(
              index: i + 1,
              total: bitmaps.length,
              progress: p,
            );
          },
        );
        if (i == 0) done = clock.elapsed;
        printed++;
      }
      final timings = PrintTimings(
        connect: connected,
        send: (sent ?? connected) - connected,
        print: done! - (sent ?? connected),
      );
      debugPrint('Label print: $timings, labels ${bitmaps.length}');
      ref.read(lastPrintTimingsProvider.notifier).record(timings);
      report(null);
      state = PrintDone(
        printed,
        batteryPercent: info.batteryPercent,
        timings: timings,
      );
    } catch (e) {
      report(e);
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
