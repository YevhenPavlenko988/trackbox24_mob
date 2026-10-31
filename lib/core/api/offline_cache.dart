import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
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
  RegExp(r'^/api/routes/\d+$'),
];

bool isOfflineCached(RequestOptions o) =>
    o.method == 'GET' && _cached.any((r) => r.hasMatch(o.uri.path));

/// Lists whose items are whole cards: each item is kept as its own card too, so a parcel or a move in a trip opens
/// offline even though nobody opened its card online. The same backend view backs the list and the card.
final _seeds = <RegExp, String>{
  RegExp(r'^/api/trips/\d+/parcels$'): '/api/parcels/',
  RegExp(r'^/api/parcels$'): '/api/parcels/',
  RegExp(r'^/api/trips$'): '/api/trips/',
};

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
    if (o.method == 'GET' && response.data != null) {
      try {
        final now = DateTime.now();
        await _db.batch((b) {
          if (isOfflineCached(o)) {
            b.insert(
              _db.cachedResponses,
              CachedResponsesCompanion.insert(
                key: offlineCacheKey(o),
                body: jsonEncode(response.data),
                savedAt: now,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
          final prefix = _seeds.entries
              .where((e) => e.key.hasMatch(o.uri.path))
              .map((e) => e.value)
              .firstOrNull;
          final content = response.data is Map
              ? (response.data as Map)['content']
              : null;
          if (prefix != null && content is List) {
            for (final item in content) {
              if (item is Map && item['id'] != null) {
                b.insert(
                  _db.cachedResponses,
                  CachedResponsesCompanion.insert(
                    key: '$prefix${item['id']}',
                    body: jsonEncode(item),
                    savedAt: now,
                  ),
                  mode: InsertMode.insertOrReplace,
                );
              }
            }
          }
        });
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
