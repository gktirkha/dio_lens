import 'dart:async';

import '../../domain/entities/dio_lens_settings.dart';
import 'settings_data_source.dart';

class SettingsMockDataSource implements SettingsDataSource {
  SettingsMockDataSource({this.initial = const DioLensSettings()})
    : _settings = initial;

  final DioLensSettings initial;
  DioLensSettings _settings;

  late final StreamController<DioLensSettings> _changes =
      StreamController.broadcast();

  @override
  Stream<DioLensSettings> watchSettings() async* {
    yield _settings;
    yield* _changes.stream;
  }

  @override
  Future<void> updateSettings(DioLensSettings settings) async =>
      _changes.add(_settings = settings);

  @override
  Future<void> resetSettings() => updateSettings(initial);
}
