import 'dart:async';

import 'package:dio/dio.dart' show DioExceptionType;
import 'package:flutter/foundation.dart';

import '../../features/request_detail/domain/entities/request_detail_entity.dart';
import '../../features/settings/domain/entities/dio_lens_settings.dart';
import '../../features/settings/domain/enums/dio_lens_retention.dart';
import '../enums/request_state.dart';
import 'dio_lens_storage.dart';
import 'stored_requests_parser.dart';

/// In-memory source of truth for captured requests and settings, written
/// through to a [DioLensStorage].
///
/// Lazy: storage is created and read on first use. Every change updates
/// memory at once, then reaches storage through a queue, one call at a
/// time. The max requests limit and retention are applied here.
class DioLensStore {
  DioLensStore({
    required DioLensStorage Function() storage,
    required DioLensSettings initialSettings,
  }) : _storageFactory = storage,
       _initialSettings = initialSettings,
       _settings = ValueNotifier(initialSettings);

  /// Settings given to `DioLens.init`; what [resetSettings] goes back to.
  final DioLensSettings _initialSettings;

  final DioLensStorage Function() _storageFactory;
  late final DioLensStorage _storage = _storageFactory();

  final ValueNotifier<DioLensSettings> _settings;

  /// Newest first.
  final List<RequestDetailEntity> _requests = [];

  late final StreamController<List<RequestDetailEntity>> _changes =
      StreamController.broadcast();

  /// Completes once stored settings and requests are loaded.
  late final Future<void> ready = _load();

  Future<void> _queue = Future.value();

  /// Current settings: the initial ones until stored ones are loaded.
  ValueListenable<DioLensSettings> get settings => _settings;

  /// Loaded requests, newest first; empty until [ready].
  List<RequestDetailEntity> get requests => List.unmodifiable(_requests);

  /// The requests, newest first. Emits once loaded, then after every change.
  Stream<List<RequestDetailEntity>> watchRequests() {
    late final StreamController<List<RequestDetailEntity>> controller;
    StreamSubscription<List<RequestDetailEntity>>? subscription;
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

  /// Stores a newly started [request] as the newest one.
  Future<void> add(RequestDetailEntity request) async {
    await ready;
    _requests.insert(0, request);
    _write(request);
    _trim();
    _emit();
  }

  /// Replaces the stored request with the same id. Ignored when it is gone
  /// (deleted, cleared or trimmed while in flight).
  Future<void> update(RequestDetailEntity request) async {
    await ready;
    final index = _requests.indexWhere((r) => r.id == request.id);
    if (index < 0) return;
    _requests[index] = request;
    _write(request);
    _emit();
  }

  Future<void> delete(String id) async {
    await ready;
    final before = _requests.length;
    _requests.removeWhere((r) => r.id == id);
    if (_requests.length == before) return;
    _enqueue((s) => s.deleteRequests([id]));
    _emit();
  }

  Future<void> clear() async {
    await ready;
    _requests.clear();
    _enqueue((s) => s.clearRequests());
    _emit();
  }

  /// Removes requests past the retention (or the limit) now, instead of
  /// waiting for the next request.
  Future<void> removeExpired() async {
    await ready;
    if (_trim()) _emit();
  }

  /// Applies and stores [settings]; a lower limit or shorter retention
  /// removes the requests that no longer fit.
  Future<void> updateSettings(DioLensSettings settings) async {
    await ready;
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

  Future<void> _load() async {
    try {
      final json = await _storage.readSettings();
      if (json != null) _settings.value = DioLensSettings.fromJson(json);
    } catch (error, stack) {
      _log('could not read settings', error, stack);
    }

    if (_settings.value.retention == DioLensRetention.session) {
      // Nothing from an earlier run is kept, so skip reading it.
      _enqueue((s) => s.clearRequests());
      return;
    }
    final ParsedRequests parsed;
    try {
      parsed = switch (_storage) {
        final ParsingDioLensStorage storage =>
          await storage.readParsedRequests(),
        final storage => parseStoredRequests(await storage.readRequests()),
      };
    } catch (error, stack) {
      _log('could not read requests', error, stack);
      return;
    }
    if (parsed.corrupt.isNotEmpty) {
      _enqueue((s) => s.deleteRequests(parsed.corrupt));
    }
    _requests.addAll(parsed.requests.map(_settleInterrupted));
    _trim();
  }

  /// A request stored as pending by an earlier run never got its answer:
  /// it is marked failed, and stored so, instead of spinning forever.
  RequestDetailEntity _settleInterrupted(RequestDetailEntity request) {
    if (request.state != RequestState.pending) return request;
    final settled = request.copyWith(
      state: RequestState.failed,
      errorType: DioExceptionType.unknown,
      errorMessage: 'The app closed before this request finished.',
    );
    _write(settled);
    return settled;
  }

  /// Drops requests past the limit or older than the retention; true when
  /// any were dropped.
  bool _trim() {
    final settings = _settings.value;
    final maxAge = settings.retention.maxAge;
    final cutoff = maxAge == null ? null : DateTime.now().subtract(maxAge);
    final removed = <String>[];
    while (_requests.length > settings.maxRequests ||
        (cutoff != null &&
            _requests.isNotEmpty &&
            _requests.last.startedAt.isBefore(cutoff))) {
      removed.add(_requests.removeLast().id);
    }
    if (removed.isEmpty) return false;
    _enqueue((s) => s.deleteRequests(removed));
    return true;
  }

  void _write(RequestDetailEntity request) =>
      _enqueue((s) => s.writeRequest(request.id, request.toJson()));

  void _emit() {
    if (_changes.hasListener) _changes.add(requests);
  }

  void _enqueue(Future<void> Function(DioLensStorage storage) operation) {
    _queue = _queue
        .then((_) => operation(_storage))
        .catchError(
          (Object error, StackTrace stack) =>
              _log('storage write failed', error, stack),
        );
  }

  static void _log(String message, Object error, StackTrace stack) =>
      debugPrint('DioLens: $message: $error\n$stack');
}
