import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

/// A driver creates a trip for themselves on their default car (the backend enforces both) — on its own, as the
/// first leg of a new route, or as the next leg of [routeId] (starting at [from], where the last leg ended).
class TripCreateScreen extends ConsumerStatefulWidget {
  const TripCreateScreen({
    this.pick = false,
    this.routeId,
    this.legTitle,
    this.from,
    super.key,
  });

  /// Opened to pick a trip: pops with the created [Trip] instead of opening its card.
  final bool pick;

  /// The route this is the next leg of.
  final int? routeId;

  /// «14.3»: what the new leg will be called.
  final String? legTitle;
  final String? from;

  @override
  ConsumerState<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends ConsumerState<TripCreateScreen> {
  late final _origin = TextEditingController(text: widget.from ?? '');
  final _destination = TextEditingController();
  final _notes = TextEditingController();
  DateTime _departure = DateTime.now();
  bool _saving = false;
  bool _asRoute = false;

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDeparture() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _departure,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_departure),
    );
    if (time == null) return;
    setState(
      () => _departure = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final api = ref.read(tripApiProvider);
      final leg = tripBody(
        plannedDepartureAt: _departure,
        origin: _origin.text.trim(),
        destination: _destination.text.trim(),
        notes: _notes.text.trim(),
      );
      final routeId = widget.routeId;
      final trip = routeId != null
          ? await api.addLeg(routeId, leg)
          : _asRoute
          ? await api.createRoute(leg, origin: _origin.text.trim())
          : await api.create(
              plannedDepartureAt: _departure,
              origin: _origin.text.trim(),
              destination: _destination.text.trim(),
              notes: _notes.text.trim(),
            );
      ref.invalidate(tripsByStatusProvider);
      if (!mounted) return;
      if (widget.pick) {
        context.pop(trip);
      } else {
        context.pushReplacement('/trips/${trip.id}');
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(describeError(context, e))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.legTitle != null
              ? l.trip_nextLegTitle(widget.legTitle!)
              : l.trip_createTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(l.trip_createHint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule),
            title: Text(l.trip_plannedDepartureAt),
            subtitle: Text(formatDateTime(_departure)),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _pickDeparture,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _origin,
            decoration: InputDecoration(labelText: l.trip_origin),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _destination,
            decoration: InputDecoration(labelText: l.trip_destination),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: InputDecoration(labelText: l.trip_notes),
            maxLines: 3,
          ),
          if (widget.routeId == null) ...[
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _asRoute,
              onChanged: (v) => setState(() => _asRoute = v),
              title: Text(l.trip_newRoute),
              subtitle: Text(l.trip_newRouteHint),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.common_create),
          ),
        ],
      ),
    );
  }
}
