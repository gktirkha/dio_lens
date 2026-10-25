import 'package:flutter/material.dart';

import '../../../../core/enums/request_status_class.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../domain/entities/request_detail_entity.dart';
import 'key_value_box.dart';
import 'overview_widgets.dart';

/// Overview tab: every key fact as a tap-to-copy field, query params and
/// the cURL command.
class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
    required this.request,
    this.settings = const DioLensSettings(),
  });

  final RequestDetailEntity request;

  /// Decides which query params are masked.
  final DioLensSettings settings;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final params = request.queryParameters;
    final statusClass = request.statusClass;
    final statusText = switch (statusClass) {
      RequestStatusClass.pending => 'PENDING',
      RequestStatusClass.error =>
        'ERR${request.errorType == null ? '' : ' · ${request.errorType!.name}'}',
      _ => '${request.statusCode ?? 'ERR'}',
    };
    final statusColor = switch (statusClass) {
      RequestStatusClass.success => theme.success,
      RequestStatusClass.clientError => theme.warning,
      RequestStatusClass.serverError ||
      RequestStatusClass.error => theme.danger,
      _ => null,
    };

    final fields = <Widget>[
      OverviewField(label: 'Full URL', value: request.uri.toString()),
      OverviewField(label: 'Host', value: request.host),
      OverviewField(label: 'Path', value: request.path),
      if (params.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OverviewLabel('Query params'),
            const SizedBox(height: 6),
            KeyValueBox(
              title: 'Query',
              entries: [
                for (final p in params)
                  KeyValueEntry(
                    p.key,
                    p.value,
                    redacted: settings.isQueryParamRedacted(p.key),
                  ),
              ],
              copyAllLabel: 'Query params',
            ),
          ],
        ),
      OverviewField(label: 'Method', value: request.method),
      OverviewField(
        label: 'Status',
        value: statusText,
        copyable: false,
        valueColor: statusColor,
      ),
      OverviewField(label: 'Protocol', value: request.protocol),
      OverviewField(
        label: 'Start time',
        value: FormatUtils.clockTime(request.startedAt),
      ),
      OverviewField(
        label: 'Duration',
        value: FormatUtils.duration(request.duration),
      ),
      OverviewField(
        label: 'Request size',
        value: FormatUtils.bytes(request.requestSize),
      ),
      OverviewField(
        label: 'Response size',
        value: FormatUtils.bytes(request.responseSize),
      ),
      OverviewField(label: 'Request type', value: request.requestContentType),
      OverviewField(label: 'Response type', value: request.responseContentType),
      CurlSection(command: request.curl),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: fields.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, i) => fields[i],
    );
  }
}
