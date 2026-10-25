import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/domain/unit.dart';
import '../../../request_home/domain/entities/request_filter_params.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import '../../../request_home/domain/use_cases/watch_requests_use_case.dart';
import '../../domain/entities/dio_lens_settings.dart';
import '../../domain/use_cases/reset_settings_use_case.dart';
import '../../domain/use_cases/update_settings_use_case.dart';
import '../../domain/use_cases/watch_settings_use_case.dart';

/// State for the settings sheet: the settings and how many requests are
/// stored (for the usage bar).
///
/// Lazy: nothing is watched until the first listener attaches. Changes
/// apply at once and are stored in the background.
class SettingsController extends ChangeNotifier {
  SettingsController({
    required this._watchSettings,
    required this._updateSettings,
    required this._resetSettings,
    required this._watchRequests,
  });

  final WatchSettingsUseCase _watchSettings;
  final UpdateSettingsUseCase _updateSettings;
  final ResetSettingsUseCase _resetSettings;
  final WatchRequestsUseCase _watchRequests;

  StreamSubscription<DioLensSettings>? _settingsSubscription;
  StreamSubscription<List<RequestListItemEntity>>? _requestsSubscription;

  DioLensSettings? _settings;

  /// Defaults until the stored settings arrive (see [isLoading]).
  DioLensSettings get settings => _settings ?? const DioLensSettings();

  /// True until the settings arrive.
  bool get isLoading => _settings == null;

  int _storedCount = 0;

  /// Requests currently stored.
  int get storedCount => _storedCount;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _settingsSubscription ??= _watchSettings(unit).listen((settings) {
      if (settings == _settings) return;
      _settings = settings;
      notifyListeners();
    });
    _requestsSubscription ??= _watchRequests(RequestFilterParams.none)
        .listen((requests) {
          if (requests.length == _storedCount) return;
          _storedCount = requests.length;
          notifyListeners();
        });
  }

  /// Applies [change] to the current settings.
  Future<void> update(
    DioLensSettings Function(DioLensSettings settings) change,
  ) async {
    final next = change(settings);
    if (next == _settings) return;
    _settings = next;
    notifyListeners();
    await _updateSettings(next);
  }

  /// Back to the settings given to `DioLens.init`.
  Future<void> reset() => _resetSettings(unit);

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    _requestsSubscription?.cancel();
    super.dispose();
  }
}
