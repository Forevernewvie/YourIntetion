import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/constants/app_constants.dart';
import 'package:vibecodingexpert/core/network/dio_retry_policy.dart';

void main() {
  group('DioRetryPolicy', () {
    test('retries transient GET timeout requests', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/digest', method: 'GET'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = DioRetryPolicy.shouldRetry(error);

      expect(result, isTrue);
    });

    test('does not retry non-GET requests', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/digest', method: 'POST'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = DioRetryPolicy.shouldRetry(error);

      expect(result, isFalse);
    });

    test('limits attempts using centralized retry max constant', () {
      expect(
        DioRetryPolicy.canAttempt(AppConstants.retryMaxAttempts - 1),
        isTrue,
      );
      expect(DioRetryPolicy.canAttempt(AppConstants.retryMaxAttempts), isFalse);
    });

    test('calculates linear retry backoff from centralized base delay', () {
      final delay = DioRetryPolicy.nextDelay(1);

      expect(
        delay,
        Duration(milliseconds: AppConstants.retryBaseDelay.inMilliseconds * 2),
      );
    });
  });
}
