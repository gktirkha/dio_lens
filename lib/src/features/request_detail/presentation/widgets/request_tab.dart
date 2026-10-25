import 'package:flutter/material.dart';

import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../domain/entities/request_detail_entity.dart';
import 'body_view.dart';
import 'key_value_box.dart';
import 'overview_widgets.dart';

/// Request tab: headers, query params and the request body.
class RequestTab extends StatelessWidget {
  const RequestTab({
    super.key,
    required this.request,
    this.settings = const DioLensSettings(),
  });

  final RequestDetailEntity request;

  /// Decides which headers and query params are masked.
  final DioLensSettings settings;

  @override
  Widget build(BuildContext context) {
    final params = request.queryParameters;
    final sections = <Widget>[
      if (request.requestHeaders.isEmpty)
        const _EmptySection(title: 'Headers')
      else
        KeyValueBox(
          title: 'Headers',
          entries: [
            for (final e in request.requestHeaders.entries)
              KeyValueEntry(
                e.key,
                e.value,
                redacted: settings.isHeaderRedacted(e.key),
              ),
          ],
        ),
      if (params.isNotEmpty)
        KeyValueBox(
          title: 'Query params',
          entries: [
            for (final p in params)
              KeyValueEntry(
                p.key,
                p.value,
                redacted: settings.isQueryParamRedacted(p.key),
              ),
          ],
        ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OverviewLabel('Body'),
          const SizedBox(height: 6),
          BodyView(
            body: request.requestBody,
            contentType: request.requestContentType,
            emptyLabel: 'No request body.',
          ),
        ],
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, i) => sections[i],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverviewLabel(title),
        const SizedBox(height: 6),
        const Text('None', style: TextStyle(fontSize: 12.5)),
      ],
    );
  }
}
