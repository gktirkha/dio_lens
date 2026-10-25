import 'dart:async';

import 'package:flutter/material.dart';

import '../../di/dio_lens_dependencies.dart';
import '../../features/export/data/data_sources/export_local_data_source.dart';
import '../../features/export/domain/entities/dio_lens_export_file.dart';
import '../../features/bubble/presentation/bubble_presenter.dart';
import '../../features/home/presentation/pages/dio_lens_home_page.dart';
import '../../features/notification/presentation/request_banner_presenter.dart';
import '../../features/request_detail/data/data_sources/request_detail_local_data_source.dart';
import '../../features/request_detail/presentation/pages/request_detail_page.dart';
import '../../features/request_home/data/data_sources/request_home_local_data_source.dart';
import '../../features/settings/data/data_sources/settings_local_data_source.dart';
import '../../features/settings/domain/entities/dio_lens_settings.dart';
import '../../features/stats/data/data_sources/stats_local_data_source.dart';
import '../../theme/dio_lens_theme_mode_controller.dart';
import '../../theme/dio_lens_theme_scope.dart';
import '../../interceptor/request_replayer.dart';
import '../enums/export_format.dart';
import '../storage/dio_lens_storage.dart';
import '../storage/dio_lens_store.dart';

/// Receives an export built by Dio Lens; the app decides what to do with
/// it (save, share, upload). Dio Lens never stores the file.
typedef DioLensExportCallback = FutureOr<void> Function(DioLensExportFile file);

/// Everything one `DioLens.init` sets up. Each part is created on first
/// use, so an app that never makes a request never touches storage.
class DioLensRuntime {
  DioLensRuntime({
    required this.navigatorKey,
    required this.enabled,
    required this._initialSettings,
    required DioLensStorage Function() storage,
    this.onExport,
  }) : _storageFactory = storage;

  /// The app's export handler; null hides export in the UI.
  final DioLensExportCallback? onExport;

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
    settingsDataSource: () => SettingsLocalDataSource(store),
    exportDataSource: () => ExportLocalDataSource(store),
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

  /// Re-sends captured requests (the detail page's Replay).
  late final RequestReplayer replayer = RequestReplayer();

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
  Future<void> open() => _push(_home);

  /// Pushes the detail page of the request with [id], on its own (from
  /// the banner): its header offers a way to the home page, which then
  /// replaces it.
  Future<void> openRequest(String id) => _push(
    (_) => RequestDetailPage(
      createController: () => dependencies.createRequestDetailController(id),
      onReplay: replayer.replay,
      onOpenHome: () => _push(_home, replace: true),
    ),
  );

  Widget _home(BuildContext context) => DioLensHomePage(
    dependencies: dependencies,
    onReplay: replayer.replay,
    onExport: onExport == null ? null : exportToApp,
  );

  /// Every stored request in [format], built in memory.
  Future<DioLensExportFile> export(DioLensExportFormat format) =>
      dependencies.exportRequestsUseCase(format);

  /// Builds an export and hands it to [onExport].
  Future<DioLensExportFile> exportToApp(DioLensExportFormat format) async {
    final file = await export(format);
    await onExport?.call(file);
    return file;
  }

  /// Pushes a Dio Lens page; with [replace], in place of the current one.
  Future<void> _push(WidgetBuilder builder, {bool replace = false}) async {
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
    final route = MaterialPageRoute<void>(
      builder: (_) => DioLensThemeScope(
        controller: themeController,
        child: Builder(builder: builder),
      ),
    );
    try {
      await (replace
          ? navigator.pushReplacement<void, void>(route)
          : navigator.push<void>(route));
    } finally {
      _pagesOpen.value = --_openPageCount > 0;
    }
  }
}
