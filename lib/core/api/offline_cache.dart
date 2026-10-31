import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';

/// GETs worth keeping for the road: the trips to load into and their parcels, warehouses, a parcel or move card,
/// the company. Everything else (lists, history, photos) simply needs the connection.
final _cached = [
  RegExp(r'^/api/trips$'),
  RegExp(r'^/api/trips/\d+$'),
  RegExp(r'^/api/trips/\d+/parcels$'),
  RegExp(r'^/api/warehouses$'),
  RegExp(r'^/api/parcels/\d+$'),
  RegExp(r'^/api/companies/current$'),
];

bool isOfflineCached(RequestOptions o) =>
    o.method == 'GET' && _cached.any((r) => r.hasMatch(o.uri.path));

/// The key of a request: its path and query, independent of the server address.
String offlineCacheKey(RequestOptions o) =>
    o.uri.hasQuery ? '${o.uri.path}?${o.uri.query}' : o.uri.path;

/// Header set on an answer that came from the phone, not the server: when it was saved.
const offlineCacheHeader = 'x-offline-cache';

/// Remembers the last good answer to the GETs above and, when the connection is gone (no network, a timeout),
/// answers with it instead of an error — so a trip can be picked and a move opened in a basement or a lift.
/// Scans taken meanwhile go to the queue as before; the backend checks them when they arrive.
class OfflineCacheInterceptor extends Interceptor {
  OfflineCacheInterceptor(this._db);

  final AppDatabase _db;

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final o = response.requestOptions;
    if (isOfflineCached(o) && response.data != null) {
      try {
        await _db
            .into(_db.cachedResponses)
            .insertOnConflictUpdate(
              CachedResponsesCompanion.insert(
                key: offlineCacheKey(o),
                body: jsonEncode(response.data),
                savedAt: DateTime.now(),
              ),
            );
      } on Object {
        // a full disk must not break the request itself
      }
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final o = err.requestOptions;
    final transport = switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => true,
      _ => false,
    };
    if (transport && isOfflineCached(o)) {
      final row = await (_db.select(
        _db.cachedResponses,
      )..where((t) => t.key.equals(offlineCacheKey(o)))).getSingleOrNull();
      if (row != null) {
        return handler.resolve(
          Response(
            requestOptions: o,
            statusCode: 200,
            data: jsonDecode(row.body),
            headers: Headers.fromMap({
              offlineCacheHeader: [row.savedAt.toIso8601String()],
            }),
          ),
        );
      }
    }
    handler.next(err);
  }
}

/// Forgets every kept answer: another user may log in on this phone next.
Future<void> clearOfflineCache(AppDatabase db) =>
    db.delete(db.cachedResponses).go();
