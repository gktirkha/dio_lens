// How an app integrates Dio Lens. Every button makes a real request to
// https://httpbingo.org, which echoes back whatever it receives and accepts
// any HTTP method. The demo requests and screen are in lib/src/.

import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:flutter/material.dart';

import 'src/demo_page.dart';
import 'src/platform/platform.dart';

/// The key given to [MaterialApp]; Dio Lens shows its pages through it.
final navigatorKey = GlobalKey<NavigatorState>();

/// The app's own Dio.
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://httpbingo.org',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Authorization': 'Bearer example-token'},
  ),
);

/// A second Dio whose requests fail the certificate check.
final pinnedDio = createPinnedDio('https://httpbingo.org');

/// Dio Lens only hands the file over; this app chooses to save it (in the
/// temp folder, or as a browser download on the web) and say where.
Future<void> saveExport(DioLensExportFile export) async {
  final savedTo = await saveExportFile(export);
  debugPrint('Dio Lens export saved: $savedTo');
  final context = navigatorKey.currentContext;
  if (context == null || !context.mounted) return;
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Text('Saved ${export.fileName} (${export.bytes.length} bytes)'),
    ),
  );
}

void main() {
  DioLens.init(
    navigatorKey: navigatorKey,
    // Starting values; testers can change them in the settings sheet.
    settings: const DioLensSettings(
      retention: .sevenDays,
      maxBodyBytes: 10240,
      themeMode: .system,
      redactionMode: .all,
      // In debug builds redaction is fixed to the values above.
      lockRedaction: .debug,
    ),
    // Recording, the UI and console logs in debug and profile builds (for
    // testers). Never release builds.
    uiMode: .debugProfile,
    consoleMode: .debugProfile,
    onExport: saveExport,
  );

  // Add Dio Lens last, and pass the Dio so Replay can re-send through it.
  dio.interceptors.add(
    DioLensInterceptor(
      dio: dio,
      consoleSettings: const DioLensConsoleSettings(maxWidth: 110),
    ),
  );
  // The name tells Dios with the same base URL apart.
  pinnedDio.interceptors.add(
    DioLensInterceptor(dio: pinnedDio, name: 'pinned'),
  );

  runApp(const ExampleApp());
}

/// The example app.
class ExampleApp extends StatelessWidget {
  /// Creates the app.
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Dio Lens Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: DemoPage(dio: dio, pinnedDio: pinnedDio),
    );
  }
}
