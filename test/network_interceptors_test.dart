import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/constants/app_constants.dart';
import 'package:vibecodingexpert/core/logging/app_log_writer.dart';
import 'package:vibecodingexpert/core/network/interceptors/auth_header_interceptor.dart';
import 'package:vibecodingexpert/core/network/interceptors/retry_interceptor.dart';
import 'package:vibecodingexpert/core/network/interceptors/structured_http_log_interceptor.dart';

void main() {
  group('network interceptors', () {
    test('auth header interceptor attaches bearer token header', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      final adapter = _SequenceHttpClientAdapter([
        _AdapterResult.success(statusCode: 200, body: '{}'),
      ]);
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        AuthHeaderInterceptor(accessTokenReader: () => 'token-123'),
      );

      await dio.get<void>('/digest');

      expect(
        adapter.requestOptions.single.headers[AppNetworkKey
            .authorizationHeader],
        '${AppNetworkValue.bearerScheme} token-123',
      );
    });

    test(
      'structured log interceptor writes request and response events',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        final adapter = _SequenceHttpClientAdapter([
          _AdapterResult.success(statusCode: 200, body: '{}'),
        ]);
        final logWriter = _FakeAppLogWriter();
        dio.httpClientAdapter = adapter;
        dio.interceptors.add(
          StructuredHttpLogInterceptor(logWriter: logWriter),
        );

        await dio.get<void>('/digest');

        expect(logWriter.events, [
          (level: 'info', event: AppLogEvent.httpRequest),
          (level: 'info', event: AppLogEvent.httpResponse),
        ]);
      },
    );

    test('structured log interceptor writes terminal error events', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      final adapter = _SequenceHttpClientAdapter([
        _AdapterResult.success(statusCode: 500, body: '{"error":true}'),
      ]);
      final logWriter = _FakeAppLogWriter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(StructuredHttpLogInterceptor(logWriter: logWriter));

      await expectLater(dio.get<void>('/digest'), throwsA(isA<DioException>()));

      expect(logWriter.events, [
        (level: 'info', event: AppLogEvent.httpRequest),
        (level: 'warn', event: AppLogEvent.httpError),
      ]);
    });

    test(
      'retry interceptor retries eligible GET requests and resolves success',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        final adapter = _SequenceHttpClientAdapter([
          _AdapterResult.failure(DioExceptionType.connectionTimeout),
          _AdapterResult.success(statusCode: 200, body: '{"ok":true}'),
        ]);
        dio.httpClientAdapter = adapter;
        dio.interceptors.add(RetryInterceptor(dio));

        final response = await dio.get<Map<String, dynamic>>('/digest');

        expect(response.statusCode, 200);
        expect(adapter.requestOptions, hasLength(2));
        expect(
          adapter.requestOptions.last.extra[AppNetworkKey.retryAttempt],
          1,
        );
      },
    );

    test(
      'retry interceptor preserves terminal retried error metadata',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        final adapter = _SequenceHttpClientAdapter(
          List<_AdapterResult>.generate(
            AppConstants.retryMaxAttempts + 1,
            (_) => _AdapterResult.failure(DioExceptionType.connectionTimeout),
          ),
        );
        dio.httpClientAdapter = adapter;
        dio.interceptors.add(RetryInterceptor(dio));

        final matcher = throwsA(
          isA<DioException>().having(
            (error) => error.requestOptions.extra[AppNetworkKey.retryAttempt],
            'retryAttempt',
            AppConstants.retryMaxAttempts,
          ),
        );

        await expectLater(dio.get<void>('/digest'), matcher);
        expect(
          adapter.requestOptions,
          hasLength(AppConstants.retryMaxAttempts + 1),
        );
      },
    );
  });
}

/// Purpose: Provide deterministic adapter behavior for interceptor integration tests.
final class _SequenceHttpClientAdapter implements HttpClientAdapter {
  /// Purpose: Construct adapter from an ordered sequence of response outcomes.
  _SequenceHttpClientAdapter(this._results);

  final List<_AdapterResult> _results;
  final requestOptions = <RequestOptions>[];
  int _index = 0;

  /// Purpose: Return the next configured result while recording request options.
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestOptions.add(options);
    final result = _results[_index];
    _index += 1;

    if (result.errorType != null) {
      throw DioException(requestOptions: options, type: result.errorType!);
    }

    return ResponseBody.fromString(
      result.body!,
      result.statusCode!,
      headers: const {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  /// Purpose: Satisfy Dio adapter lifecycle without external resources.
  @override
  void close({bool force = false}) {}
}

/// Purpose: Describe a single deterministic adapter outcome for test scenarios.
final class _AdapterResult {
  /// Purpose: Create a successful adapter result with status and body payload.
  const _AdapterResult.success({required this.statusCode, required this.body})
    : errorType = null;

  /// Purpose: Create a failing adapter result with a specific Dio error type.
  const _AdapterResult.failure(this.errorType) : statusCode = null, body = null;

  final int? statusCode;
  final String? body;
  final DioExceptionType? errorType;
}

/// Purpose: Capture structured log invocations for interceptor behavior assertions.
final class _FakeAppLogWriter implements AppLogWriter {
  final events = <({String level, String event})>[];

  /// Purpose: Record informational logging calls made by the interceptor.
  @override
  void info(String event, {Map<String, Object?> fields = const {}}) {
    events.add((level: 'info', event: event));
  }

  /// Purpose: Record warning logging calls made by the interceptor.
  @override
  void warn(String event, {Map<String, Object?> fields = const {}}) {
    events.add((level: 'warn', event: event));
  }

  /// Purpose: Record error logging calls when used by future test scenarios.
  @override
  void error(
    String event, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) {
    events.add((level: 'error', event: event));
  }
}
