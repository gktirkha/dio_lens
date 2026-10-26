import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../../settings/domain/enums/dio_lens_redaction_mode.dart';
import '../../domain/entities/request_detail_entity.dart';
import 'body_view.dart';
import 'error_card.dart';
import 'image_preview.dart';
import 'key_value_box.dart';
import 'overview_widgets.dart';

/// Response tab: headers and body, the error when the request failed, or a
/// waiting state while pending.
class ResponseTab extends StatelessWidget {
  /// Creates the tab.
  const ResponseTab({
    super.key,
    required this.request,
    this.settings = const DioLensSettings(),
  });

  /// The request shown.
  final RequestDetailEntity request;

  /// Decides which headers are masked.
  final DioLensSettings settings;

  @override
  Widget build(BuildContext context) {
    final sections = switch (request.state) {
      RequestState.pending => [const _Waiting()],
      RequestState.failed => [
        ErrorCard(type: request.errorType, message: request.errorMessage),
        if (request.stackTrace case final trace? when trace.isNotEmpty)
          StackTraceSection(stackTrace: trace),
      ],
      RequestState.completed => _completed(),
    };

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, i) => sections[i],
    );
  }

  List<Widget> _completed() {
    final contentType = request.responseContentType ?? '';
    final body = request.responseBody;
    final isImage = contentType.toLowerCase().startsWith('image/');

    return [
      if (request.responseHeaders.isEmpty)
        const _Labelled(label: 'Headers', child: _Muted('None'))
      else
        KeyValueBox(
          title: 'Headers',
          entries: [
            for (final e in request.responseHeaders.entries)
              KeyValueEntry(
                e.key,
                e.value,
                redacted: settings.isHeaderRedacted(e.key),
                copyRedacted: settings.isHeaderRedacted(
                  e.key,
                  target: DioLensRedactionTarget.clipboard,
                ),
              ),
          ],
        ),
      _Labelled(
        label: 'Body',
        child: isImage
            ? ImagePreview(
                bytes: switch (body) {
                  Uint8List b => b,
                  List<int> b => Uint8List.fromList(b),
                  String encoded => _decodeBase64(encoded),
                  _ => null,
                },
                contentType: request.responseContentType,
                size: request.responseSize,
              )
            : BodyView(
                body: body,
                contentType: request.responseContentType,
                emptyLabel: 'No response body.',
              ),
      ),
    ];
  }
}

Uint8List? _decodeBase64(String encoded) {
  try {
    return base64Decode(encoded);
  } on FormatException {
    return null;
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [OverviewLabel(label), const SizedBox(height: 6), child],
    );
  }
}

class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        color: DioLensTheme.of(context).textFaint,
      ),
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting();

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.accent,
              backgroundColor: theme.borderStrong,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Waiting for response…',
            style: TextStyle(fontSize: 12.5, color: theme.textMuted),
          ),
        ],
      ),
    );
  }
}
