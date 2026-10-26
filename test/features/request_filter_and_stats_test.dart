import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/core/enums/request_status_class.dart';
import 'package:dio_lens/src/features/request_home/data/mappers/request_list_item_mapper.dart';
import 'package:dio_lens/src/features/request_home/domain/entities/request_filter_params.dart';
import 'package:dio_lens/src/features/request_home/domain/entities/request_status_filter.dart';
import 'package:dio_lens/src/features/stats/data/utils/request_stats_calculator.dart';
import 'package:dio_lens/src/features/stats/presentation/models/stats_ranking.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/entities.dart';

void main() {
  group('RequestFilterParams', () {
    final get200 = request(
      'a',
      url: 'https://api.example.com/v1/orders?page=2',
    ).toListItem();
    final post404 = request(
      'b',
      method: 'POST',
      url: 'https://auth.example.com/login',
      statusCode: 404,
    ).toListItem();
    final failed = request('c', state: RequestState.failed).toListItem();

    test('none matches everything', () {
      expect(RequestFilterParams.none.isEmpty, isTrue);
      for (final r in [get200, post404, failed]) {
        expect(RequestFilterParams.none.matches(r), isTrue);
      }
    });

    test('status, methods and search combine', () {
      const errors = RequestFilterParams(status: RequestStatusFilter.errors);
      expect(errors.matches(failed), isTrue);
      expect(errors.matches(get200), isFalse);
      const posts = RequestFilterParams(methods: {'POST'});
      expect(posts.matches(post404), isTrue);
      expect(posts.matches(get200), isFalse);
      const search = RequestFilterParams(search: '  PAGE=2 ');
      expect(search.matches(get200), isTrue);
      expect(search.matches(post404), isFalse);
      const client = RequestFilterParams(
        status: RequestStatusFilter.clientError,
      );
      expect(client.matches(post404), isTrue);
    });
  });

  test('RequestStatsCalculator', () {
    final stats = RequestStatsCalculator.calculate(
      [
        request(
          '1',
          duration: const Duration(milliseconds: 100),
          responseSize: 100,
        ),
        request(
          '2',
          duration: const Duration(milliseconds: 300),
          responseSize: 900,
        ),
        request(
          '3',
          url: 'https://api.example.com/v1/big',
          statusCode: 500,
          duration: const Duration(milliseconds: 800),
          responseSize: 5000,
        ),
        request('4', state: RequestState.failed),
        request('5', state: RequestState.pending),
      ].map((r) => r.toListItem()).toList(),
    );

    expect(stats.totalRequests, 5);
    expect(stats.finishedRequests, 4);
    expect(stats.successCount, 2);
    expect(stats.errorCount, 2);
    expect(stats.totalBytes, 6000);
    expect(stats.averageLatency, const Duration(milliseconds: 400));
    expect(stats.p95Latency, const Duration(milliseconds: 800));
    expect(stats.successRate, 0.5);
    expect(stats.largestResponses.first.path, '/v1/big');
    expect(stats.largestResponses.first.bytes, 5000);
    expect(stats.mostCalledEndpoints.first.name, '/v1/orders');
    expect(stats.mostCalledEndpoints.first.count, 4);
    expect(stats.topHosts.single.name, 'api.example.com');
    expect(stats.statusDistribution.map((s) => s.statusClass), [
      RequestStatusClass.success,
      RequestStatusClass.serverError,
      RequestStatusClass.error,
      RequestStatusClass.pending,
    ]);
  });

  test('top failing endpoints count 4xx, 5xx and no response', () {
    final stats = RequestStatsCalculator.calculate(
      [
        request('1', statusCode: 404),
        request('2', state: RequestState.failed),
        request('3', url: 'https://api.example.com/v1/big', statusCode: 500),
        request('4', url: 'https://api.example.com/v1/ok'),
        request('5', url: 'https://api.example.com/v1/ok', statusCode: 302),
        request('6', state: RequestState.pending),
      ].map((r) => r.toListItem()).toList(),
    );

    expect(stats.topFailingEndpoints.map((e) => (e.name, e.count)), [
      ('/v1/orders', 2),
      ('/v1/big', 1),
    ], reason: 'success, redirect and pending are not failures');
    expect(StatsRanking.topFailingEndpoints.items(stats).map((i) => i.value), [
      '2×',
      '1×',
    ]);
  });

  test('empty stats', () {
    final stats = RequestStatsCalculator.calculate(const []);
    expect(stats.isEmpty, isTrue);
    expect(stats.successRate, isNull);
  });
}
