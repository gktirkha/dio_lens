import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/domain/unit.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../../settings/domain/use_cases/watch_settings_use_case.dart';
import '../../../share/domain/entities/dio_lens_share_content.dart';
import '../../../share/domain/use_cases/build_share_content_use_case.dart';
import '../../domain/entities/request_detail_entity.dart';
import '../../domain/use_cases/watch_request_detail_use_case.dart';

/// State for one request's detail page.
///
/// Lazy: nothing is watched until the first listener attaches.
class RequestDetailController extends ChangeNotifier {
  RequestDetailController({
    required this.requestId,
    required this._watchRequestDetail,
    required this._watchSettings,
    required this._buildShareContent,
  });

  final String requestId;
  final WatchRequestDetailUseCase _watchRequestDetail;
  final WatchSettingsUseCase _watchSettings;
  final BuildShareContentUseCase _buildShareContent;

  StreamSubscription<RequestDetailEntity?>? _subscription;
  StreamSubscription<DioLensSettings>? _settingsSubscription;

  DioLensSettings _settings = const DioLensSettings();

  /// Decides which headers and query params are masked.
  DioLensSettings get settings => _settings;

  RequestDetailEntity? _request;

  /// Null while loading or once the request was deleted.
  RequestDetailEntity? get request => _request;

  bool _loading = true;

  /// True until the first result arrives.
  bool get isLoading => _loading;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _subscription ??= _watchRequestDetail(requestId).listen((request) {
      _request = request;
      _loading = false;
      notifyListeners();
    });
    _settingsSubscription ??= _watchSettings(unit).listen((settings) {
      if (settings == _settings) return;
      _settings = settings;
      notifyListeners();
    });
  }

  /// [request] as a shareable report, masked as the settings say.
  Future<DioLensShareContent> shareContent(RequestDetailEntity request) =>
      _buildShareContent((request: request, settings: _settings));

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
