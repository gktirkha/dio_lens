import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../entities/dio_lens_settings.dart';
import '../enums/dio_lens_redaction_mode.dart';

/// Masks sensitive values in a captured request before it leaves Dio Lens
/// (export, share), as the redaction settings say.
abstract final class RequestRedactor {
  /// Replaces masked header and query values.
  static const String mask = '[REDACTED]';

  /// The request with redacted headers and query values masked for [target]
  /// (the UI by default).
  static RequestDetailEntity redact(
    RequestDetailEntity request,
    DioLensSettings settings, {
    DioLensRedactionTarget target = DioLensRedactionTarget.ui,
  }) {
    Map<String, String> headers(Map<String, String> all) => {
      for (final e in all.entries)
        e.key: settings.isHeaderRedacted(e.key, target: target)
            ? mask
            : e.value,
    };
    final uri = request.uri;
    return request.copyWith(
      requestHeaders: headers(request.requestHeaders),
      responseHeaders: headers(request.responseHeaders),
      uri: request.query == null
          ? uri
          : uri.replace(
              query: [
                for (final p in request.queryParameters)
                  '${Uri.encodeQueryComponent(p.key)}='
                      '${settings.isQueryParamRedacted(p.key, target: target) ? mask : Uri.encodeQueryComponent(p.value)}',
              ].join('&'),
            ),
    );
  }
}
