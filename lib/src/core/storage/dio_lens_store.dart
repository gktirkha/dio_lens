import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart' show DioExceptionType;
import 'package:flutter/foundation.dart';

import '../../features/request_detail/domain/entities/request_detail_entity.dart';
import '../../features/request_home/data/mappers/request_list_item_mapper.dart';
import '../../features/request_home/domain/entities/request_list_item_entity.dart';
import '../../features/settings/domain/entities/dio_lens_settings.dart';
import '../../features/settings/domain/enums/dio_lens_retention.dart';
import '../enums/request_state.dart';
import 'dio_lens_storage.dart';
import 'stored_requests_parser.dart';

/// In-memory source of truth for captured requests and settings, written
/// through to a [DioLensStorage]. Keeps only request summaries in memory, plus
/// a small cache of full requests; applies the max requests limit and
/// retention.
class DioLensStore {
  /// Creates a store over the storage built by [storage], starting from
  /// [initialSettings].
  DioLensStore({
    required DioLensStorage Function() storage,
    required DioLensSettings initialSettings,
  }) : _storageFactory = storage,
       _initialSettings = initialSettings,
       _settings = ValueNotifier(initialSettings);

  /// Full requests kept in memory, most recently used.
  static const int detailCacheSize = 20;

  final DioLensSettings _initialSettings;

  final DioLensStorage Function() _storageFactory;
  late final DioLensStorage _storage = _storageFactory();

  final ValueNotifier<DioLensSettings> _settings;

  final List<RequestListItemEntity> _summaries = [];

  final LinkedHashMap<String, RequestDetailEntity> _details = LinkedHashMap();

  late final StreamController<List<RequestListItemEntity>> _changes =
      StreamController.broadcast();

  late final StreamController<RequestDetailEntity> _detailChanges =
      StreamController.broadcast();

  late final StreamController<Set<String>?> _removals =
      StreamController.broadcast();

  /// Completes once stored settings and request summaries are loaded.
  late final Future<void> ready = _load();

  Future<void> _queue = Future.value();

  /// Current settings: the initial ones until the stored ones are loaded.
  ValueListenable<DioLensSettings> get settings => _settings;

  /// Request summaries, newest first; empty until [ready].
  List<RequestListItemEntity> get requests => List.unmodifiable(_summaries);

  /// Request summaries, newest first. Emits once loaded, then after every
  /// change.
  Stream<List<RequestListItemEntity>> watchRequests() {
    late final StreamController<List<RequestListItemEntity>> controller;
    StreamSubscription<List<RequestListItemEntity>>? subscription;
    controller = StreamController(
      onListen: () {
        subscription = _changes.stream.listen(controller.add);
        ready.then((_) {
          if (!controller.isClosed) controller.add(requests);
        });
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  /// The full request with [id], from the cache or storage; null when it is not
  /// stored.
  Future<RequestDetailEntity?> getRequest(String id) async {
    await ready;
    if (!_summaries.any((s) => s.id == id)) return null;
    if (_details.remove(id) case final cached?) return _cache(cached);
    final loaded = await _read(
      (s) => switch (s) {
        final ParsingDioLensStorage storage => storage.readParsedRequest(id),
        final storage => storage.readRequest(id).then(parseStoredRequest),
      },
    );
    if (loaded == null || !_summaries.any((s) => s.id == id)) return null;
    return _cache(_details[id] ?? loaded);
  }

  /// The full request with [id]: emits it once loaded, again on every update,
  /// and null once it is removed.
  Stream<RequestDetailEntity?> watchRequest(String id) {
    late final StreamController<RequestDetailEntity?> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    controller = StreamController(
      onListen: () {
        var changed = false;
        subscriptions
          ..add(
            _detailChanges.stream.where((r) => r.id == id).listen((request) {
              changed = true;
              controller.add(request);
            }),
          )
          ..add(
            _removals.stream
                .where((ids) => ids == null || ids.contains(id))
                .listen((_) {
                  changed = true;
                  controller.add(null);
                }),
          );
        getRequest(id).then((request) {
          if (!changed && !controller.isClosed) controller.add(request);
        });
      },
      onCancel: () {
        for (final s in subscriptions) {
          s.cancel();
        }
      },
    );
    return controller.stream;
  }

  /// Every stored request in full, newest first. Used for export.
  Future<List<RequestDetailEntity>> getAllRequests() async {
    await ready;
    return _read(
      (s) => switch (s) {
        final ParsingDioLensStorage storage => storage.readParsedRequests(),
        final storage => storage.readRequests().then(parseStoredRequests),
      },
    );
  }

  /// Stores a newly started [request] as the newest one.
  Future<void> add(RequestDetailEntity request) async {
    await ready;
    _summaries.insert(0, request.toListItem());
    _cache(request);
    _write(request);
    _trim();
    _emit();
    if (_detailChanges.hasListener) _detailChanges.add(request);
  }

  /// Replaces the stored request with the same id; ignored when it is gone.
  Future<void> update(RequestDetailEntity request) async {
    await ready;
    final index = _summaries.indexWhere((s) => s.id == request.id);
    if (index < 0) return;
    _summaries[index] = request.toListItem();
    _details.remove(request.id);
    _cache(request);
    _write(request);
    _emit();
    if (_detailChanges.hasListener) _detailChanges.add(request);
  }

  /// Removes the request with [id].
  Future<void> delete(String id) async {
    await ready;
    final before = _summaries.length;
    _summaries.removeWhere((s) => s.id == id);
    if (_summaries.length == before) return;
    _details.remove(id);
    _enqueue((s) => s.deleteRequests([id]));
    _emit();
    _notifyRemoved({id});
  }

  /// Removes every request.
  Future<void> clear() async {
    await ready;
    _summaries.clear();
    _details.clear();
    _enqueue((s) => s.clearRequests());
    _emit();
    _notifyRemoved(null);
  }

  /// Removes requests past the retention or the limit now.
  Future<void> removeExpired() async {
    await ready;
    if (_trim()) _emit();
  }

  /// Applies and stores [settings]; a lower limit or shorter retention removes
  /// the requests that no longer fit.
  Future<void> updateSettings(DioLensSettings settings) async {
    await ready;
    settings = _enforce(settings);
    if (settings == _settings.value) return;
    _settings.value = settings;
    _enqueue((s) => s.writeSettings(settings.toJson()));
    if (_trim()) _emit();
  }

  /// Removes the stored settings and goes back to the initial ones.
  Future<void> resetSettings() async {
    await ready;
    _enqueue((s) => s.clearSettings());
    if (_settings.value == _initialSettings) return;
    _settings.value = _initialSettings;
    if (_trim()) _emit();
  }

  /// [settings] with the redaction fields from the initial settings when
  /// those lock redaction in this build.
  DioLensSettings _enforce(DioLensSettings settings) {
    final initial = _initialSettings;
    if (!initial.isRedactionLocked) return settings;
    return settings.copyWith(
      lockRedaction: initial.lockRedaction,
      redactionMode: initial.redactionMode,
      redactedHeaders: initial.redactedHeaders,
      redactedQueryParams: initial.redactedQueryParams,
    );
  }

  Future<void> _load() async {
    try {
      final json = await _storage.readSettings();
      if (json != null) {
        _settings.value = _enforce(DioLensSettings.fromJson(json));
      }
    } catch (error, stack) {
      _log('could not read settings', error, stack);
    }

    if (_settings.value.retention == DioLensRetention.session) {
      _enqueue((s) => s.clearRequests());
      return;
    }
    final ParsedSummaries parsed;
    try {
      parsed = switch (_storage) {
        final ParsingDioLensStorage storage =>
          await storage.readParsedSummaries(),
        final storage => parseStoredSummaries(await storage.readSummaries()),
      };
    } catch (error, stack) {
      _log('could not read requests', error, stack);
      return;
    }
    if (parsed.corrupt.isNotEmpty) {
      _enqueue((s) => s.deleteRequests(parsed.corrupt));
    }
    _summaries.addAll(parsed.summaries.map(_settleInterrupted));
    _trim();
  }

  RequestListItemEntity _settleInterrupted(RequestListItemEntity summary) {
    if (summary.state != RequestState.pending) return summary;
    const errorType = DioExceptionType.unknown;
    const message = 'The app closed before this request finished.';
    _enqueue((s) async {
      final request = switch (s) {
        final ParsingDioLensStorage storage => await storage.readParsedRequest(
          summary.id,
        ),
        final storage => parseStoredRequest(
          await storage.readRequest(summary.id),
        ),
      };
      if (request == null) return;
      final settled = request.copyWith(
        state: RequestState.failed,
        errorType: errorType,
        errorMessage: message,
      );
      await s.writeRequest(
        settled.id,
        request: settled.toJson(),
        summary: settled.toListItem().toJson(),
      );
    });
    return summary.copyWith(state: RequestState.failed, errorType: errorType);
  }

  bool _trim() {
    final settings = _settings.value;
    final maxAge = settings.retention.maxAge;
    final cutoff = maxAge == null ? null : DateTime.now().subtract(maxAge);
    final removed = <String>{};
    while (_summaries.length > settings.maxRequests ||
        (cutoff != null &&
            _summaries.isNotEmpty &&
            _summaries.last.startedAt.isBefore(cutoff))) {
      final id = _summaries.removeLast().id;
      removed.add(id);
      _details.remove(id);
    }
    if (removed.isEmpty) return false;
    _enqueue((s) => s.deleteRequests(removed.toList()));
    _notifyRemoved(removed);
    return true;
  }

  RequestDetailEntity _cache(RequestDetailEntity request) {
    _details[request.id] = request;
    while (_details.length > detailCacheSize) {
      _details.remove(_details.keys.first);
    }
    return request;
  }

  void _write(RequestDetailEntity request) => _enqueue(
    (s) => s.writeRequest(
      request.id,
      request: request.toJson(),
      summary: request.toListItem().toJson(),
    ),
  );

  void _emit() {
    if (_changes.hasListener) _changes.add(requests);
  }

  void _notifyRemoved(Set<String>? ids) {
    if (_removals.hasListener) _removals.add(ids);
  }

  void _enqueue(Future<void> Function(DioLensStorage storage) operation) {
    _queue = _queue
        .then((_) => operation(_storage))
        .catchError(
          (Object error, StackTrace stack) =>
              _log('storage write failed', error, stack),
        );
  }

  Future<T> _read<T>(Future<T> Function(DioLensStorage storage) read) {
    final result = _queue.then((_) => read(_storage));
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  static void _log(String message, Object error, StackTrace stack) =>
      debugPrint('DioLens: $message: $error\n$stack');
}
