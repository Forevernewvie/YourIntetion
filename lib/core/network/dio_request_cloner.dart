import 'package:dio/dio.dart';

/// Purpose: Recreate request options so retries do not mutate the original request.
final class DioRequestCloner {
  DioRequestCloner._();

  /// Purpose: Clone request options while preserving request semantics for retries.
  static RequestOptions clone(RequestOptions request) {
    return RequestOptions(
      path: request.path,
      method: request.method,
      baseUrl: request.baseUrl,
      data: request.data,
      queryParameters: Map<String, dynamic>.from(request.queryParameters),
      headers: Map<String, dynamic>.from(request.headers),
      extra: Map<String, dynamic>.from(request.extra),
      contentType: request.contentType,
      connectTimeout: request.connectTimeout,
      sendTimeout: request.sendTimeout,
      receiveTimeout: request.receiveTimeout,
      responseType: request.responseType,
      followRedirects: request.followRedirects,
      maxRedirects: request.maxRedirects,
      receiveDataWhenStatusError: request.receiveDataWhenStatusError,
      validateStatus: request.validateStatus,
      requestEncoder: request.requestEncoder,
      responseDecoder: request.responseDecoder,
      listFormat: request.listFormat,
      preserveHeaderCase: request.preserveHeaderCase,
    );
  }
}
