import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart' show DioExceptionType;

import '../../../../core/enums/request_state.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import 'stats_data_source.dart';

/// [StatsDataSource] backed by generated traffic over the last 12 hours.
///
/// Stand-in until stats read from the shared request store. Lazy: requests
/// are generated on first use.
class StatsMockDataSource implements StatsDataSource {
  StatsMockDataSource({List<RequestListItemEntity> Function()? seed})
    : _seed = seed ?? generateRequests;

  final List<RequestListItemEntity> Function() _seed;

  late final List<RequestListItemEntity> _requests = List.unmodifiable(_seed());

  @override
  Stream<List<RequestListItemEntity>> watchRequests() async* {
    yield _requests;
  }

  /// Deterministic sample: ~350 requests whose hourly volume, status mix and
  /// per-endpoint latency resemble a real session.
  static List<RequestListItemEntity> generateRequests({DateTime? now}) {
    final at = now ?? DateTime.now();
    final random = Random(42);

    // Relative traffic per hour, oldest first.
    const hourlyWeights = [6, 9, 14, 22, 31, 27, 19, 24, 35, 29, 18, 10];
    // (method, host, path, weight, base latency ms)
    const endpoints = [
      ('GET', 'api.example.com', '/v1/users', 40, 184),
      ('GET', 'api.example.com', '/v1/orders', 27, 266),
      ('POST', 'auth.example.com', '/auth/login', 15, 150),
      ('GET', 'api.example.com', '/v1/notifications', 11, 120),
      ('PUT', 'api.example.com', '/v1/cart', 6, 140),
      ('GET', 'cdn.example.com', '/images/avatar.jpg', 16, 60),
      ('POST', 'api.example.com', '/v1/payments/intent', 4, 742),
      ('GET', 'api.example.com', '/v1/sync', 4, 612),
      ('GET', 'api.example.com', '/v1/reports/export', 3, 398),
    ];
    final totalWeight = endpoints.fold<int>(0, (sum, e) => sum + e.$4);

    T pick<T>(List<(T, int)> options) {
      var roll = random.nextInt(options.fold(0, (sum, o) => sum + o.$2));
      for (final (value, weight) in options) {
        if ((roll -= weight) < 0) return value;
      }
      return options.last.$1;
    }

    final requests = <RequestListItemEntity>[];
    var id = 0;
    for (var hour = 0; hour < hourlyWeights.length; hour++) {
      final count = (hourlyWeights[hour] * 1.45).round();
      final hourStart = at.subtract(
        Duration(hours: hourlyWeights.length - hour),
      );
      for (var i = 0; i < count; i++) {
        var roll = random.nextInt(totalWeight);
        final endpoint = endpoints.firstWhere((e) => (roll -= e.$4) < 0);
        final (method, host, path, _, baseMs) = endpoint;
        final startedAt = hourStart.add(
          Duration(seconds: random.nextInt(3600)),
        );
        final ms = (baseMs * (0.6 + random.nextDouble() * 0.8)).round();

        // 72% 2xx, 6% 3xx, 9% 4xx, 5% 5xx, 5% network error, 3% pending.
        final (state, code) = pick([
          ((RequestState.completed, 200), 72),
          ((RequestState.completed, 304), 6),
          ((RequestState.completed, 404), 9),
          ((RequestState.completed, 500), 5),
          ((RequestState.failed, null), 5),
          ((RequestState.pending, null), 3),
        ]);

        requests.add(
          RequestListItemEntity(
            id: 'stats-${id++}',
            method: method,
            uri: Uri.parse('https://$host$path'),
            startedAt: startedAt,
            state: state,
            statusCode: code,
            duration: state == RequestState.pending
                ? null
                : Duration(milliseconds: ms),
            responseSize: state == RequestState.completed
                ? 200 + random.nextInt(28000)
                : null,
            errorType: state == RequestState.failed
                ? DioExceptionType.connectionTimeout
                : null,
          ),
        );
      }
    }
    requests.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return requests;
  }
}
