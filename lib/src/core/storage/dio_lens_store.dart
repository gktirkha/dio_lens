import 'dart:async';

import 'package:dio/dio.dart' show DioExceptionType;
import 'package:flutter/foundation.dart';

import '../../features/request_detail/domain/entities/request_detail_entity.dart';
import '../../features/settings/domain/entities/dio_lens_settings.dart';
import '../../features/settings/domain/enums/dio_lens_retention.dart';
import '../enums/request_state.dart';
import 'dio_lens_storage.dart';
import 'stored_requests_parser.dart';

class DioLensStore {
  DioLensStore({
    required DioLensStorage Function() storage,
    required DioLensSettings initialSettings,
  }) : _storageFactory = storage,
       _initialSettings = initialSettings,
       _settings = ValueNotifier(initialSettings);

  final DioLensSettings _initialSettings;

  final DioLensStorage Function() _storageFactory;
  late final DioLensStorage _storage = _storageFactory();

  final ValueNotifier<DioLensSettings> _settings;

  final List<RequestDetailEntity> _requests = [];

  late final StreamController<List<RequestDetailEntity>> _changes =
      StreamController.broadcast();

  late final Future<void> ready = _load();

  Future<void> _queue = Future.value();

  ValueListenable<DioLensSettings> get settings => _settings;

  List<RequestDetailEntity> get requests => List.unmodifiable(_requests);

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

  Future<void> add(RequestDetailEntity request) async {
    await ready;
    _requests.insert(0, request);
    _write(request);
    _trim();
    _emit();
  }

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

  Future<void> removeExpired() async {
    await ready;
    if (_trim()) _emit();
  }

  Future<void> updateSettings(DioLensSettings settings) async {
    await ready;
    if (settings == _settings.value) return;
    _settings.value = settings;
    _enqueue((s) => s.writeSettings(settings.toJson()));
    if (_trim()) _emit();
  }

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
