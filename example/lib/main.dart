// How an app integrates Dio Lens. Every button makes a real request to
// https://httpbingo.org, which echoes back whatever it receives and accepts
// any HTTP method. The demo requests and screen are in lib/src/.

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:flutter/material.dart';

import 'src/demo_page.dart';

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

/// A second Dio that pins a certificate no server has, so every TLS handshake
/// is rejected.
final pinnedDio = Dio(BaseOptions(baseUrl: 'https://httpbingo.org'))
  ..httpClientAdapter = IOHttpClientAdapter(
    validateCertificate: (_, _, _) => false,
  );

/// Dio Lens only hands the file over; this app chooses to save it in the
/// temp folder and say where.
Future<void> saveExport(DioLensExportFile export) async {
  final file = File('${Directory.systemTemp.path}/${export.fileName}');
  await file.writeAsBytes(export.bytes);
  debugPrint('Dio Lens export saved: ${file.path}');
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
