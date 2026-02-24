import 'package:dio/dio.dart';

import '../config/app_env.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';

/// Purpose: Build configured Dio client with timeout, logging and retry behavior.
final class DioFactory {
  DioFactory._();

  /// Purpose: Create a new Dio instance for API communication.
  static Dio create({required String? Function() accessTokenReader}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.apiBaseUrl,
        connectTimeout: AppConstants.apiConnectTimeout,
        receiveTimeout: AppConstants.apiReceiveTimeout,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = accessTokenReader();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          AppLogger.info(
            'http_request',
            fields: {'method': options.method, 'path': options.path},
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info(
            'http_response',
            fields: {
              'statusCode': response.statusCode,
              'path': response.requestOptions.path,
            },
          );
          handler.next(response);
        },
        onError: (error, handler) async {
          if (_canRetry(error)) {
            final attempt = (error.requestOptions.extra['retryAttempt'] as int?) ?? 0;
            if (attempt < AppConstants.retryMaxAttempts) {
              final delay = Duration(
                milliseconds: AppConstants.retryBaseDelay.inMilliseconds * (attempt + 1),
              );
              await Future<void>.delayed(delay);

              final clonedOptions = _cloneRequestOptions(error.requestOptions)
                ..extra = {
                  ...error.requestOptions.extra,
                  'retryAttempt': attempt + 1,
                };

              try {
                final response = await dio.fetch<dynamic>(clonedOptions);
                handler.resolve(response);
                return;
              } on DioException catch (_) {
                // Purpose: Fall through to structured error logging when retry still fails.
              }
            }
          }

          AppLogger.warn(
            'http_error',
            fields: {
              'path': error.requestOptions.path,
              'statusCode': error.response?.statusCode,
            },
          );
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  /// Purpose: Decide if request is safe and useful to retry for transient failures.
  static bool _canRetry(DioException error) {
    if (error.requestOptions.method.toUpperCase() != 'GET') {
      return false;
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => (error.response?.statusCode ?? 0) >= 500,
      _ => false,
    };
  }

  /// Purpose: Create retry-safe request options copy preserving original request data.
  static RequestOptions _cloneRequestOptions(RequestOptions request) {
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
