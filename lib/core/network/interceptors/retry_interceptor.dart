import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../dio_request_cloner.dart';
import '../dio_retry_policy.dart';

/// Purpose: Retry transient idempotent HTTP requests using centralized retry policy.
final class RetryInterceptor extends Interceptor {
  /// Purpose: Construct retry interceptor with the active Dio client dependency.
  RetryInterceptor(this._dio);

  final Dio _dio;

  /// Purpose: Retry eligible failures before letting terminal errors propagate.
  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (!DioRetryPolicy.shouldRetry(error)) {
      handler.next(error);
      return;
    }

    final attempt =
        (error.requestOptions.extra[AppNetworkKey.retryAttempt] as int?) ?? 0;
    if (!DioRetryPolicy.canAttempt(attempt)) {
      handler.next(error);
      return;
    }

    final delay = DioRetryPolicy.nextDelay(attempt);
    await Future<void>.delayed(delay);

    final clonedOptions = DioRequestCloner.clone(error.requestOptions)
      ..extra = {
        ...error.requestOptions.extra,
        AppNetworkKey.retryAttempt: attempt + 1,
      };

    try {
      final response = await _dio.fetch<dynamic>(clonedOptions);
      handler.resolve(response);
    } on DioException catch (retriedError) {
      // Purpose: Preserve the terminal retry failure so downstream handlers see the latest error.
      handler.next(retriedError);
    }
  }
}
