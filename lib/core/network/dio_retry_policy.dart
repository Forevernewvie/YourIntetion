import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Purpose: Encapsulate retry decision rules for transient HTTP failures.
final class DioRetryPolicy {
  DioRetryPolicy._();

  /// Purpose: Decide whether the given request failure should be retried.
  static bool shouldRetry(DioException error) {
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

  /// Purpose: Determine whether another retry attempt is still allowed.
  static bool canAttempt(int attempt) {
    return attempt < AppConstants.retryMaxAttempts;
  }

  /// Purpose: Calculate backoff delay for the next retry attempt.
  static Duration nextDelay(int attempt) {
    return Duration(
      milliseconds: AppConstants.retryBaseDelay.inMilliseconds * (attempt + 1),
    );
  }
}
