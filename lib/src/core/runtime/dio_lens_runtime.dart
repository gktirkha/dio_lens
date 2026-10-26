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
import '../../features/share/domain/entities/dio_lens_share_content.dart';
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

/// Receives an export built by Dio Lens; the app decides what to do with it
/// (save, share, upload). Dio Lens never stores the file.
typedef DioLensExportCallback = FutureOr<void> Function(DioLensExportFile file);

/// Everything one `DioLens.init` sets up. Each part is created on first use.
class DioLensRuntime {
  /// Creates the runtime for one `DioLens.init` call.
  DioLensRuntime({
    required this.navigatorKey,
    required this.uiEnabled,
    required this.consoleEnabled,
    required this._initialSettings,
    required DioLensStorage Function() storage,
    this.onExport,
    this.onShare,
  }) : _storageFactory = storage;

  /// The app's share handler; null copies the report to the clipboard.
  final DioLensShareCallback? onShare;

  /// The app's export handler; null disables export in the UI.
  final DioLensExportCallback? onExport;

  /// The runtime of the last `DioLens.init`; null before it.
  static DioLensRuntime? current;

  /// The host app's navigator: Dio Lens pages, banners and the bubble are shown
  /// through it.
  final GlobalKey<NavigatorState> navigatorKey;

  /// Whether requests are recorded and the UI is available (from the UI
  /// mode).
  final bool uiEnabled;

  /// Whether requests are printed to the console (from the console mode).
  final bool consoleEnabled;

  final DioLensSettings _initialSettings;
  final DioLensStorage Function() _storageFactory;

  /// Captured requests and settings, in memory and in storage.
  late final DioLensStore store = DioLensStore(
    storage: _storageFactory,
    initialSettings: _initialSettings,
  );

  /// Wires the data sources, repositories and use cases of every feature.
  late final DioLensDependencies dependencies = DioLensDependencies(
    requestHomeDataSource: () => RequestHomeLocalDataSource(store),
    statsDataSource: () => StatsLocalDataSource(store),
    requestDetailDataSource: () => RequestDetailLocalDataSource(store),
    settingsDataSource: () => SettingsLocalDataSource(store),
    exportDataSource: () => ExportLocalDataSource(store),
  );

  /// Theme mode shared by every Dio Lens page, kept in sync with the theme mode
  /// setting both ways.
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

  /// Shows the request-finished banner.
  late final RequestBannerPresenter banner = RequestBannerPresenter(
    navigatorKey: navigatorKey,
    themeController: themeController,
    onView: openRequest,
  );

  /// Re-sends captured requests (the detail page's Replay).
  late final RequestReplayer replayer = RequestReplayer();

  /// Shows the floating bubble that opens Dio Lens.
  late final BubblePresenter bubble = BubblePresenter(
    navigatorKey: navigatorKey,
    settings: store.settings,
    hidden: _pagesOpen,
    onTap: open,
  );

  final ValueNotifier<bool> _pagesOpen = ValueNotifier(false);
  int _openPageCount = 0;

  int _sequence = 0;

  /// A new request id, unique within this app run and across runs.
  String nextRequestId() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
      '-${(_sequence++).toRadixString(36)}';

  /// Pushes the Dio Lens home page on the host's navigator.
  Future<void> open() => _push(_home);

  /// Pushes the detail page of the request with [id] on its own, as from the
  /// banner. Its header offers a way to the home page.
  Future<void> openRequest(String id) => _push(
    (_) => RequestDetailPage(
      createController: () => dependencies.createRequestDetailController(id),
      onReplay: replayer.replay,
      replayUnavailableReason: replayer.unavailableReason,
      onShare: onShare,
      onOpenHome: () => _push(_home, replace: true),
    ),
  );

  Widget _home(BuildContext context) => DioLensHomePage(
    dependencies: dependencies,
    onReplay: replayer.replay,
    replayUnavailableReason: replayer.unavailableReason,
    canReplayItem: (item) =>
        replayer.unavailableReasonFor(
          item.id,
          hasFileUpload: item.hasFileUpload,
          requestBodyIncomplete: item.requestBodyIncomplete,
        ) ==
        null,
    onExport: onExport == null ? null : exportToApp,
    onShare: onShare,
  );

  /// Every stored request in [format], built in memory.
  Future<DioLensExportFile> export(DioLensExportFormat format) =>
      dependencies.exportRequestsUseCase(format);

  /// Builds an export in [format] and hands it to [onExport].
  Future<DioLensExportFile> exportToApp(DioLensExportFormat format) async {
    final file = await export(format);
    await onExport?.call(file);
    return file;
  }

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
        page: true,
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
