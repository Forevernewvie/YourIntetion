/// Purpose: Define normalized error codes for application-wide failure handling.
enum AppErrorCode {
  netTimeout,
  netUnauthorized,
  apiBadResponse,
  ruleValidation,
  ruleConflict,
  cacheMiss,
  storageFailure,
  unknown,
}

/// Purpose: Represent a safe and structured domain failure for UI and logging.
class AppFailure implements Exception {
  /// Purpose: Create a normalized failure instance.
  const AppFailure({required this.code, required this.message, this.cause});

  final AppErrorCode code;
  final String message;
  final Object? cause;

  /// Purpose: Provide readable output for diagnostic traces.
  @override
  String toString() =>
      'AppFailure(code: $code, message: $message, cause: $cause)';
}
