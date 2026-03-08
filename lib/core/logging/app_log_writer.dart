import 'app_logger.dart';

/// Purpose: Define an injectable logging contract for infrastructure concerns.
abstract interface class AppLogWriter {
  /// Purpose: Write an informational event with structured fields.
  void info(String event, {Map<String, Object?> fields = const {}});

  /// Purpose: Write a warning event with structured fields.
  void warn(String event, {Map<String, Object?> fields = const {}});

  /// Purpose: Write an error event with structured fields and failure details.
  void error(
    String event, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Purpose: Bridge the injectable logging contract to the shared app logger.
final class DefaultAppLogWriter implements AppLogWriter {
  /// Purpose: Create the default application log writer implementation.
  const DefaultAppLogWriter();

  /// Purpose: Forward informational events to the shared structured logger.
  @override
  void info(String event, {Map<String, Object?> fields = const {}}) {
    AppLogger.info(event, fields: fields);
  }

  /// Purpose: Forward warning events to the shared structured logger.
  @override
  void warn(String event, {Map<String, Object?> fields = const {}}) {
    AppLogger.warn(event, fields: fields);
  }

  /// Purpose: Forward error events to the shared structured logger.
  @override
  void error(
    String event, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) {
    AppLogger.error(
      event,
      fields: fields,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
