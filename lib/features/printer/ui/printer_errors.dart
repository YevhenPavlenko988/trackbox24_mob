import 'package:flutter/widgets.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/printer/niimbot/ble_transport.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_packet.dart';
import 'package:trackbox24_mob/features/printer/niimbot/niimbot_printer.dart';

/// What to tell the user when printing failed.
String describePrinterError(BuildContext context, Object error) {
  final l = AppLocalizations.of(context);
  return switch (error) {
    BluetoothUnavailable(:final problem) => switch (problem) {
      BluetoothProblem.off => l.printer_errBluetoothOff,
      BluetoothProblem.unauthorized => l.printer_errBluetoothUnauthorized,
      BluetoothProblem.unsupported => l.printer_errBluetoothUnsupported,
    },
    NiimbotException(:final failure, :final code) => switch (failure) {
      NiimbotFailure.timeout => l.printer_errTimeout,
      NiimbotFailure.disconnected => l.printer_errDisconnected,
      NiimbotFailure.notSupported => l.printer_errNotSupported,
      NiimbotFailure.printerError => switch (code) {
        NiimbotErrorCode.coverOpen => l.printer_errCoverOpen,
        NiimbotErrorCode.lackPaper ||
        NiimbotErrorCode.paperOutException => l.printer_errNoPaper,
        NiimbotErrorCode.lowBattery ||
        NiimbotErrorCode.batteryException => l.printer_errLowBattery,
        NiimbotErrorCode.overheat => l.printer_errOverheat,
        NiimbotErrorCode.temperatureLow => l.printer_errCold,
        NiimbotErrorCode.printerBusy => l.printer_errBusy,
        NiimbotErrorCode.wrongPaper => l.printer_errWrongPaper,
        NiimbotErrorCode.b3sAbnormalPaperOutput => l.printer_errPaperJam,
        final c => l.printer_errPrinter(c ?? 0),
      },
    },
    _ => describeError(context, error),
  };
}
