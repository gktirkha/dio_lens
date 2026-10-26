import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:flutter/material.dart';

import 'demo_requests.dart';

/// Buttons that make requests, grouped by kind.
class DemoPage extends StatelessWidget {
  /// Creates the page for the app's Dios.
  DemoPage({super.key, required Dio dio, required Dio pinnedDio})
    : _methods = methodRequests(dio),
      _bodies = bodyRequests(dio),
      _failures = failureRequests(dio, pinnedDio);

  final List<DemoRequest> _methods;
  final List<DemoRequest> _bodies;
  final List<DemoRequest> _failures;

  Future<void> _run(BuildContext context, DemoRequest request) async {
    final messenger = ScaffoldMessenger.of(context);
    String result;
    try {
      final response = await request.send();
      result = '${request.method} → ${response.statusCode}';
    } on DioException catch (e) {
      result = e.response != null
          ? '${request.method} → ${e.response!.statusCode}'
          : '${request.method} → ${e.type.name}';
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(result), duration: const Duration(seconds: 1)),
      );
  }

  Future<void> _runAll(BuildContext context, List<DemoRequest> requests) async {
    for (final r in requests) {
      if (!context.mounted) return;
      await _run(context, r);
    }
  }

  @override
  Widget build(BuildContext context) =>
      _MaterialHost(child: Builder(builder: _buildPage));

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Lens Example'),
        actions: [
          IconButton(
            tooltip: 'Run every request',
            onPressed: () =>
                _runAll(context, [..._methods, ..._bodies, ..._failures]),
            icon: const Icon(Icons.playlist_play_rounded),
          ),
          IconButton(
            tooltip: 'Open Dio Lens',
            onPressed: DioLens.open,
            icon: const Icon(Icons.travel_explore_rounded),
          ),
          IconButton(
            tooltip: 'Reset Dio Lens settings',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await DioLens.resetSettings();
              messenger.showSnackBar(
                const SnackBar(content: Text('Dio Lens settings reset')),
              );
            },
            icon: const Icon(Icons.settings_backup_restore_rounded),
          ),
          IconButton(
            tooltip: 'Clear captured requests',
            onPressed: DioLens.clear,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 96),
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(top: 8),
            child: Text(
              'Make a request, then tap the floating bubble (or the search '
              'icon) to inspect it.',
            ),
          ),
          _SectionHeader(
            'HTTP methods',
            trailing: TextButton.icon(
              onPressed: () => _runAll(context, _methods),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run all'),
            ),
          ),
          for (final r in _methods)
            _RequestTile(request: r, onTap: () => _run(context, r)),
          const _SectionHeader('Bodies & statuses'),
          for (final r in _bodies)
            _RequestTile(request: r, onTap: () => _run(context, r)),
          _SectionHeader(
            'Failures (stack trace)',
            trailing: TextButton.icon(
              onPressed: () => _runAll(context, _failures),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run all'),
            ),
          ),
          for (final r in _failures)
            _RequestTile(request: r, onTap: () => _run(context, r)),
        ],
      ),
    );
  }
}

/// Gives this Material page a [ScaffoldMessenger] and Material localizations
/// when the app has none, as in a `CupertinoApp`. Dio Lens pages fill these in
/// themselves.
class _MaterialHost extends StatelessWidget {
  const _MaterialHost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var page = child;
    if (ScaffoldMessenger.maybeOf(context) == null) {
      page = ScaffoldMessenger(child: page);
    }
    final hasLocalizations =
        Localizations.of<MaterialLocalizations>(
          context,
          MaterialLocalizations,
        ) !=
        null;
    if (hasLocalizations) return page;
    return Localizations.override(
      context: context,
      delegates: const [DefaultMaterialLocalizations.delegate],
      child: page,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request, required this.onTap});

  final DemoRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 72,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            request.method,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: scheme.onSecondaryContainer,
            ),
          ),
        ),
        title: Text(request.title),
        subtitle: Text(request.subtitle),
        trailing: const Icon(Icons.send_rounded, size: 18),
      ),
    );
  }
}
