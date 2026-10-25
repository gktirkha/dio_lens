import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../entities/dio_lens_settings.dart';

abstract final class RequestRedactor {
  static const String mask = '[REDACTED]';

  static RequestDetailEntity redact(
    RequestDetailEntity request,
    DioLensSettings settings,
  ) {
    Map<String, String> headers(Map<String, String> all) => {
      for (final e in all.entries)
        e.key: settings.isHeaderRedacted(e.key) ? mask : e.value,
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
                      '${settings.isQueryParamRedacted(p.key) ? mask : Uri.encodeQueryComponent(p.value)}',
              ].join('&'),
            ),
    );
  }
}
