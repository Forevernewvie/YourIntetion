import 'package:dio/dio.dart';

import '../config/app_env.dart';
import '../constants/app_constants.dart';
import '../logging/app_log_writer.dart';
import 'interceptors/auth_header_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/structured_http_log_interceptor.dart';

/// Purpose: Build configured Dio client with timeout, logging and retry behavior.
final class DioFactory {
  DioFactory._();

  /// Purpose: Create a new Dio instance for API communication.
  static Dio create({
    required String? Function() accessTokenReader,
    AppLogWriter? logWriter,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.apiBaseUrl,
        connectTimeout: AppConstants.apiConnectTimeout,
        receiveTimeout: AppConstants.apiReceiveTimeout,
      ),
    );

    dio.interceptors.addAll([
      AuthHeaderInterceptor(accessTokenReader: accessTokenReader),
      StructuredHttpLogInterceptor(logWriter: logWriter),
      RetryInterceptor(dio),
    ]);

    return dio;
  }
}
