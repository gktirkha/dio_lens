import 'package:flutter/material.dart';

import '../../di/dio_lens_dependencies.dart';
import '../../features/bubble/presentation/bubble_presenter.dart';
import '../../features/home/presentation/pages/dio_lens_home_page.dart';
import '../../features/notification/presentation/request_banner_presenter.dart';
import '../../features/request_detail/data/data_sources/request_detail_local_data_source.dart';
import '../../features/request_detail/presentation/pages/request_detail_page.dart';
import '../../features/request_home/data/data_sources/request_home_local_data_source.dart';
import '../../features/settings/domain/entities/dio_lens_settings.dart';
import '../../features/stats/data/data_sources/stats_local_data_source.dart';
import '../../theme/dio_lens_theme_mode_controller.dart';
import '../../theme/dio_lens_theme_scope.dart';
import '../storage/dio_lens_storage.dart';
import '../storage/dio_lens_store.dart';

/// Everything one `DioLens.init` sets up. Each part is created on first
/// use, so an app that never makes a request never touches storage.
class DioLensRuntime {
  DioLensRuntime({
    required this.navigatorKey,
    required this.enabled,
    required this._initialSettings,
    required DioLensStorage Function() storage,
  }) : _storageFactory = storage;

  /// The runtime of the last `DioLens.init`; null before it.
  static DioLensRuntime? current;

  /// The host's navigator: Dio Lens pages and banners are shown through it.
  final GlobalKey<NavigatorState> navigatorKey;

  /// When false, the interceptor records nothing.
  final bool enabled;

  final DioLensSettings _initialSettings;
  final DioLensStorage Function() _storageFactory;

  late final DioLensStore store = DioLensStore(
    storage: _storageFactory,
    initialSettings: _initialSettings,
  );

  late final DioLensDependencies dependencies = DioLensDependencies(
    requestHomeDataSource: () => RequestHomeLocalDataSource(store),
    statsDataSource: () => StatsLocalDataSource(store),
    requestDetailDataSource: () => RequestDetailLocalDataSource(store),
  );

  /// Appearance shared by every Dio Lens page and banner, kept in sync
  /// with [DioLensSettings.themeMode] both ways.
  late final DioLensThemeModeController themeController = () {
    final controller = DioLensThemeModeController(
      store.settings.value.themeMode,
    );
    store.settings.addListener(
      () => controller.value = store.settings.value.themeMode,
    );
    controller.addListener(() {
      final settings = store.settings.value;
      if (settings.themeMode != controller.value) {
        store.updateSettings(settings.copyWith(themeMode: controller.value));
      }
    });
    return controller;
  }();

  late final RequestBannerPresenter banner = RequestBannerPresenter(
    navigatorKey: navigatorKey,
    themeController: themeController,
    onView: openRequest,
  );

  late final BubblePresenter bubble = BubblePresenter(
    navigatorKey: navigatorKey,
    settings: store.settings,
    hidden: _pagesOpen,
    onTap: open,
  );

  /// True while a Dio Lens page is on the navigator.
  final ValueNotifier<bool> _pagesOpen = ValueNotifier(false);
  int _openPageCount = 0;

  int _sequence = 0;

  /// A new id, unique within this app run and across runs.
  String nextRequestId() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
      '-${(_sequence++).toRadixString(36)}';

  /// Pushes the Dio Lens home page on the host's navigator.
  Future<void> open() =>
      _push((_) => DioLensHomePage(dependencies: dependencies));

  /// Pushes the detail page of the request with [id].
  Future<void> openRequest(String id) => _push(
    (_) => RequestDetailPage(
      createController: () => dependencies.createRequestDetailController(id),
    ),
  );

  Future<void> _push(WidgetBuilder builder) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      debugPrint(
        'DioLens: the navigator key passed to DioLens.init is not attached '
        'to a Navigator yet.',
      );
      return;
    }
    banner.dismiss();
    _pagesOpen.value = ++_openPageCount > 0;
    try {
      await navigator.push<void>(
        MaterialPageRoute(
          builder: (_) => DioLensThemeScope(
            controller: themeController,
            child: Builder(builder: builder),
          ),
        ),
      );
    } finally {
      _pagesOpen.value = --_openPageCount > 0;
    }
  }
}
