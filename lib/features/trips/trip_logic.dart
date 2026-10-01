import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// `GET /api/trips/{id}/parcels` returns plan and fact in one list:
/// `plannedTripId == id && tripId == null` → planned, not loaded; `tripId == id` → loaded (or delivered).
({List<Parcel> planned, List<Parcel> loaded}) splitTripParcels(
  int tripId,
  List<Parcel> parcels,
) => (
  planned: parcels
      .where((p) => p.plannedTripId == tripId && p.tripId == null)
      .toList(),
  loaded: parcels.where((p) => p.tripId == tripId).toList(),
);

bool isOutsidePlan(int tripId, Parcel p) =>
    p.tripId == tripId && p.plannedTripId != tripId;

/// Seat counters over the loaded parcels; `loaded` includes delivered seats.
({int loaded, int delivered, int total}) seatProgress(List<Parcel> parcels) {
  var loaded = 0;
  var delivered = 0;
  var total = 0;
  for (final p in parcels) {
    final seats = p.seats.isNotEmpty
        ? p.seats.map((s) => s.status)
        : [p.status];
    for (final s in seats) {
      total++;
      if (s == ParcelStatus.IN_CAR || s == ParcelStatus.DELIVERED_TO_CLIENT) {
        loaded++;
      }
      if (s == ParcelStatus.DELIVERED_TO_CLIENT) delivered++;
    }
  }
  return (loaded: loaded, delivered: delivered, total: total);
}
