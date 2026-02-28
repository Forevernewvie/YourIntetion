import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/error/app_failure.dart';
import 'package:vibecodingexpert/core/network/dio_failure_mapper.dart';

void main() {
  const messages = DioFailureMessages(
    fallbackMessage: 'fallback',
    timeoutMessage: 'timeout',
    unauthorizedMessage: 'unauthorized',
    tooManyRequestsMessage: 'too-many',
  );

  group('DioFailureMapper', () {
    test('maps unauthorized status to netUnauthorized', () {
      final options = RequestOptions(path: '/auth');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<void>(requestOptions: options, statusCode: 401),
      );

      final failure = DioFailureMapper.map(error, messages: messages);

      expect(failure.code, AppErrorCode.netUnauthorized);
      expect(failure.message, 'unauthorized');
    });

    test('maps 429 status to apiBadResponse with throttle message', () {
      final options = RequestOptions(path: '/auth');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<void>(requestOptions: options, statusCode: 429),
      );

      final failure = DioFailureMapper.map(error, messages: messages);

      expect(failure.code, AppErrorCode.apiBadResponse);
      expect(failure.message, 'too-many');
    });

    test('prefers backend message for 4xx payloads', () {
      final options = RequestOptions(path: '/digest');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 400,
          data: const <String, dynamic>{'message': 'backend detail'},
        ),
      );

      final failure = DioFailureMapper.map(error, messages: messages);

      expect(failure.code, AppErrorCode.apiBadResponse);
      expect(failure.message, 'backend detail');
    });

    test('maps timeout types to netTimeout', () {
      final options = RequestOptions(path: '/digest');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );

      final failure = DioFailureMapper.map(error, messages: messages);

      expect(failure.code, AppErrorCode.netTimeout);
      expect(failure.message, 'timeout');
    });
  });
}
