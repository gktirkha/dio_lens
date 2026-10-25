import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:flutter/material.dart';

/// The key given to [MaterialApp]; Dio Lens shows its pages through it.
final navigatorKey = GlobalKey<NavigatorState>();

/// The app's own Dio, used by every request below.
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://httpbingo.org',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Authorization': 'Bearer example-token'},
  ),
);

void main() {
  DioLens.init(
    navigatorKey: navigatorKey,
    // Debug and profile builds; never release builds.
    mode: DioLensMode.debugProfile,
    // Starting values; the user can change them in the settings sheet.
    settings: const DioLensSettings(
      maxRequests: 200,
      retention: DioLensRetention.sevenDays,
    ),
    // Dio Lens builds the file; the app decides what to do with it.
    onExport: (file) {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${file.fileName}: ${file.requestCount} requests, '
            '${file.bytes.length} bytes',
          ),
        ),
      );
    },
  );

  // Add Dio Lens last, and pass the Dio so Replay can re-send through it.
  dio.interceptors.add(DioLensInterceptor(dio: dio));

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
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const RequestsPage(),
    );
  }
}

/// A request the example can make.
typedef _Demo = ({String label, Future<Response<dynamic>> Function() send});

final List<_Demo> _demos = [
  (
    label: 'GET with query',
    send: () => dio.get('/get', queryParameters: {'page': 2}),
  ),
  (
    label: 'POST JSON',
    send: () => dio.post('/post', data: {'item': 301, 'quantity': 1}),
  ),
  (label: 'PUT JSON', send: () => dio.put('/put', data: {'name': 'Ava'})),
  (
    label: 'PATCH JSON',
    send: () => dio.patch('/patch', data: {'theme': 'dark'}),
  ),
  (label: 'DELETE', send: () => dio.delete('/delete')),
  (
    label: 'Upload a file',
    send: () => dio.post(
      '/post',
      data: FormData.fromMap({
        'file': MultipartFile.fromString('hello', filename: 'hello.txt'),
      }),
    ),
  ),
  (
    label: 'Image response',
    send: () => dio.get(
      '/image/png',
      options: Options(responseType: ResponseType.bytes),
    ),
  ),
  (label: '404 Not found', send: () => dio.get('/status/404')),
  (label: '500 Server error', send: () => dio.get('/status/500')),
  (
    label: 'Receive timeout',
    send: () => dio.get(
      '/delay/5',
      options: Options(receiveTimeout: const Duration(seconds: 1)),
    ),
  ),
];

/// Buttons that make requests, and a way to open Dio Lens.
class RequestsPage extends StatelessWidget {
  /// Creates the page.
  const RequestsPage({super.key});

  Future<void> _run(BuildContext context, _Demo demo) async {
    final messenger = ScaffoldMessenger.of(context);
    String result;
    try {
      final response = await demo.send();
      result = '${demo.label}: ${response.statusCode}';
    } on DioException catch (error) {
      result =
          '${demo.label}: ${error.response?.statusCode ?? error.type.name}';
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Lens Example'),
        actions: [
          IconButton(
            tooltip: 'Open Dio Lens',
            onPressed: DioLens.open,
            icon: const Icon(Icons.travel_explore_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Make a request, then tap the floating bubble (or the search '
            'icon) to inspect it.',
          ),
          const SizedBox(height: 12),
          for (final demo in _demos)
            Card(
              child: ListTile(
                title: Text(demo.label),
                trailing: const Icon(Icons.send_rounded),
                onTap: () => _run(context, demo),
              ),
            ),
        ],
      ),
    );
  }
}
