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

typedef DioLensExportCallback = FutureOr<void> Function(DioLensExportFile file);

class DioLensRuntime {
  DioLensRuntime({
    required this.navigatorKey,
    required this.enabled,
    required this._initialSettings,
    required DioLensStorage Function() storage,
    this.onExport,
    this.onShare,
  }) : _storageFactory = storage;

  final DioLensShareCallback? onShare;

  final DioLensExportCallback? onExport;

  static DioLensRuntime? current;

  final GlobalKey<NavigatorState> navigatorKey;

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

  late final RequestReplayer replayer = RequestReplayer();

  late final BubblePresenter bubble = BubblePresenter(
    navigatorKey: navigatorKey,
    settings: store.settings,
    hidden: _pagesOpen,
    onTap: open,
  );

  final ValueNotifier<bool> _pagesOpen = ValueNotifier(false);
  int _openPageCount = 0;

  int _sequence = 0;

  String nextRequestId() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
      '-${(_sequence++).toRadixString(36)}';

  Future<void> open() => _push(_home);

  Future<void> openRequest(String id) => _push(
    (_) => RequestDetailPage(
      createController: () => dependencies.createRequestDetailController(id),
      onReplay: replayer.replay,
      onShare: onShare,
      onOpenHome: () => _push(_home, replace: true),
    ),
  );

  Widget _home(BuildContext context) => DioLensHomePage(
    dependencies: dependencies,
    onReplay: replayer.replay,
    onExport: onExport == null ? null : exportToApp,
    onShare: onShare,
  );

  Future<DioLensExportFile> export(DioLensExportFormat format) =>
      dependencies.exportRequestsUseCase(format);

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
