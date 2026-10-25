import 'dart:async';

import '../../../../core/storage/dio_lens_store.dart';
import '../../domain/entities/dio_lens_settings.dart';
import 'settings_data_source.dart';

/// [SettingsDataSource] over the stored settings.
class SettingsLocalDataSource implements SettingsDataSource {
  SettingsLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<DioLensSettings> watchSettings() {
    final settings = _store.settings;
    late final StreamController<DioLensSettings> controller;
    void emit() => controller.add(settings.value);
    controller = StreamController(
      onListen: () {
        settings.addListener(emit);
        // Stored settings replace the initial ones once loaded.
        _store.ready.then((_) {
          if (!controller.isClosed) emit();
        });
      },
      onCancel: () => settings.removeListener(emit),
    );
    return controller.stream;
  }

  @override
  Future<void> updateSettings(DioLensSettings settings) =>
      _store.updateSettings(settings);

  @override
  Future<void> resetSettings() => _store.resetSettings();
}
