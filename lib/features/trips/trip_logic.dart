import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// `GET /api/trips/{id}/parcels` returns plan and fact in one list:
/// `plannedTripId == id && tripId == null` → planned, not loaded; `tripId == id` → loaded (or delivered);
/// the rest were in the car and left it (to a warehouse, a transfer), listed by the trip's history. Departure takes
/// what was not loaded out of the plan, so once the trip stops loading ([stillPlanning] false) a parcel still planned
/// here and not in the car is an unloaded one (it keeps its plan).
({List<Parcel> planned, List<Parcel> loaded, List<Parcel> unloaded})
splitTripParcels(
  int tripId,
  List<Parcel> parcels, {
  bool stillPlanning = true,
}) => (
  planned: parcels
      .where(
        (p) => p.plannedTripId == tripId && p.tripId == null && stillPlanning,
      )
      .toList(),
  loaded: parcels.where((p) => p.tripId == tripId).toList(),
  unloaded: parcels
      .where(
        (p) =>
            p.tripId != tripId && (p.plannedTripId != tripId || !stillPlanning),
      )
      .toList(),
);

/// Loaded without being in the trip's plan; a move is made and loaded on the spot, so it never is.
bool isOutsidePlan(int tripId, Parcel p) =>
    !p.isMove && p.tripId == tripId && p.plannedTripId != tripId;

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
