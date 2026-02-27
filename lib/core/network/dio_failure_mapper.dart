import 'package:dio/dio.dart';

import '../error/app_failure.dart';

/// Purpose: Hold context-specific messages for normalized Dio failure mapping.
final class DioFailureMessages {
  /// Purpose: Create message bundle with deterministic defaults for transport errors.
  const DioFailureMessages({
    required this.fallbackMessage,
    required this.timeoutMessage,
    required this.unauthorizedMessage,
    required this.tooManyRequestsMessage,
  });

  final String fallbackMessage;
  final String timeoutMessage;
  final String unauthorizedMessage;
  final String tooManyRequestsMessage;
}

/// Purpose: Convert transport-layer Dio exceptions into normalized AppFailure instances.
abstract final class DioFailureMapper {
  /// Purpose: Map one DioException into a stable, UI-safe failure shape.
  static AppFailure map(
    DioException error, {
    required DioFailureMessages messages,
  }) {
    final statusCode = error.response?.statusCode ?? 0;
    if (statusCode == 401 || statusCode == 403) {
      return AppFailure(
        code: AppErrorCode.netUnauthorized,
        message: messages.unauthorizedMessage,
        cause: error,
      );
    }
    if (statusCode == 429) {
      return AppFailure(
        code: AppErrorCode.apiBadResponse,
        message: messages.tooManyRequestsMessage,
        cause: error,
      );
    }
    if (statusCode >= 400 && statusCode < 500) {
      return AppFailure(
        code: AppErrorCode.apiBadResponse,
        message: _extractResponseMessage(error) ?? messages.fallbackMessage,
        cause: error,
      );
    }
    if (_isTimeout(error)) {
      return AppFailure(
        code: AppErrorCode.netTimeout,
        message: messages.timeoutMessage,
        cause: error,
      );
    }
    return AppFailure(
      code: AppErrorCode.unknown,
      message: messages.fallbackMessage,
      cause: error,
    );
  }

  /// Purpose: Extract backend-provided human-readable message from response payload.
  static String? _extractResponseMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    return null;
  }

  /// Purpose: Classify network timeout Dio error variants in one place.
  static bool _isTimeout(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
}
