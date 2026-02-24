import 'dart:convert';
import 'dart:developer' as developer;

/// Purpose: Provide structured JSON logging with basic sensitive-field redaction.
final class AppLogger {
  AppLogger._();

  static const _redacted = '<redacted>';

  /// Purpose: Emit an informational log event.
  static void info(String event, {Map<String, Object?> fields = const {}}) {
    _log('INFO', event, fields: fields);
  }

  /// Purpose: Emit a warning log event.
  static void warn(String event, {Map<String, Object?> fields = const {}}) {
    _log('WARN', event, fields: fields);
  }

  /// Purpose: Emit an error log event with optional error and stack trace.
  static void error(
    String event, {
    Map<String, Object?> fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', event, fields: fields, error: error, stackTrace: stackTrace);
  }

  /// Purpose: Serialize and print a structured log payload.
  static void _log(
    String level,
    String event, {
    required Map<String, Object?> fields,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final payload = <String, Object?>{
      'timestamp': DateTime.now().toIso8601String(),
      'level': level,
      'event': event,
      'fields': _redact(fields),
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    };

    developer.log(jsonEncode(payload), name: 'psc');
  }

  /// Purpose: Redact known sensitive keys before logging.
  static Map<String, Object?> _redact(Map<String, Object?> source) {
    const sensitiveKeys = {
      'token',
      'authorization',
      'password',
      'secret',
      'apiKey',
    };
    final result = <String, Object?>{};

    for (final entry in source.entries) {
      final keyLower = entry.key.toLowerCase();
      result[entry.key] = sensitiveKeys.contains(keyLower)
          ? _redacted
          : entry.value;
    }

    return result;
  }
}
