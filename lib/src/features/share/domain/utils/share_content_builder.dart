import 'dart:convert';

import '../../../../core/enums/request_state.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../../settings/domain/utils/request_redactor.dart';
import '../entities/dio_lens_share_content.dart';

/// Builds the shared report of one request. Pure, so it can run in an
/// isolate.
abstract final class ShareContentBuilder {
  static DioLensShareContent build(
    RequestDetailEntity request,
    DioLensSettings settings,
  ) {
    final r = RequestRedactor.redact(request, settings);
    final status = switch (r.state) {
      RequestState.pending => 'Pending',
      RequestState.failed => 'Failed (${r.errorType?.name ?? 'unknown'})',
      RequestState.completed => '${r.statusCode ?? '—'}',
    };
    final out = StringBuffer();

    _section(out, 'Overview');
    _field(out, 'URL', '${r.uri}');
    _field(out, 'Method', r.method);
    _field(out, 'Status', status);
    _field(out, 'Started', _time(r.startedAt));
    _field(out, 'Duration', FormatUtils.duration(r.duration));
    if (r.protocol case final protocol?) _field(out, 'Protocol', protocol);
    _field(out, 'Request size', FormatUtils.bytes(r.requestSize));
    _field(out, 'Response size', FormatUtils.bytes(r.responseSize));

    _section(out, 'Request');
    _field(out, 'Content-Type', r.requestContentType ?? '—');
    _pairs(out, 'Headers', r.requestHeaders.entries);
    if (r.queryParameters.isNotEmpty) {
      _pairs(out, 'Query params', [
        for (final p in r.queryParameters) MapEntry(p.key, p.value),
      ]);
    }
    _body(out, r.requestBody, r.requestContentType);

    if (r.state == RequestState.failed) {
      _section(out, 'Error');
      _field(out, 'Type', 'DioExceptionType.${r.errorType?.name ?? 'unknown'}');
      _field(out, 'Message', r.errorMessage ?? '—');
      if (r.stackTrace case final stack? when stack.isNotEmpty) {
        out
          ..writeln()
          ..writeln('-- Stack trace --')
          ..writeln(stack.trimRight());
      }
    } else if (r.state == RequestState.completed) {
      _section(out, 'Response');
      _field(out, 'Content-Type', r.responseContentType ?? '—');
      _pairs(out, 'Headers', r.responseHeaders.entries);
      _body(out, r.responseBody, r.responseContentType);
    }

    _section(out, 'cURL');
    out.writeln(r.curl);

    return DioLensShareContent(
      subject: '${r.method} ${r.path} · $status',
      text: out.toString().trimRight(),
    );
  }

  static void _section(StringBuffer out, String title) {
    if (out.isNotEmpty) out.writeln();
    out.writeln('=============== $title ===============');
  }

  static void _field(StringBuffer out, String label, String value) =>
      out.writeln('$label: $value');

  static void _pairs(
    StringBuffer out,
    String title,
    Iterable<MapEntry<String, String>> entries,
  ) {
    out
      ..writeln()
      ..writeln('-- $title --');
    if (entries.isEmpty) out.writeln('(none)');
    for (final e in entries) {
      out.writeln('${e.key}: ${e.value}');
    }
  }

  static void _body(StringBuffer out, Object? body, String? contentType) {
    out
      ..writeln()
      ..writeln('-- Body --');
    final isImage = (contentType ?? '').toLowerCase().startsWith('image/');
    out.writeln(switch (body) {
      null => '(none)',
      String _ when isImage => '(image, not included)',
      String text => text,
      _ => const JsonEncoder.withIndent('  ').convert(body),
    });
  }

  /// `2026-10-25 16:54:01.123`
  static String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} '
        '${two(t.hour)}:${two(t.minute)}:${two(t.second)}.'
        '${t.millisecond.toString().padLeft(3, '0')}';
  }
}
