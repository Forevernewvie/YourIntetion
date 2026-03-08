import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../../logging/app_log_writer.dart';

/// Purpose: Emit structured request, response, and final error logs for HTTP traffic.
final class StructuredHttpLogInterceptor extends Interceptor {
  /// Purpose: Construct HTTP log interceptor with an injectable log writer.
  StructuredHttpLogInterceptor({AppLogWriter? logWriter})
    : _logWriter = logWriter ?? const DefaultAppLogWriter();

  final AppLogWriter _logWriter;

  /// Purpose: Log outbound request metadata before network execution.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logWriter.info(
      AppLogEvent.httpRequest,
      fields: {'method': options.method, 'path': options.path},
    );
    handler.next(options);
  }

  /// Purpose: Log inbound response metadata after successful execution.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logWriter.info(
      AppLogEvent.httpResponse,
      fields: {
        'statusCode': response.statusCode,
        'path': response.requestOptions.path,
      },
    );
    handler.next(response);
  }

  /// Purpose: Log terminal HTTP errors after retry logic has finished.
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _logWriter.warn(
      AppLogEvent.httpError,
      fields: {
        'path': error.requestOptions.path,
        'statusCode': error.response?.statusCode,
      },
    );
    handler.next(error);
  }
}
