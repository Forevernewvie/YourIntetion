import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Purpose: Load and expose environment configuration with safe defaults.
final class AppEnv {
  AppEnv._();

  /// Purpose: Load .env file when available without hard failure in local development.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Purpose: Allow booting without a local .env file for development fallback.
    }
  }

  /// Purpose: Resolve API base URL from env while supporting compile-time overrides.
  static String get apiBaseUrl {
    final compileTime = const String.fromEnvironment('API_BASE_URL');
    if (compileTime.isNotEmpty) {
      return compileTime;
    }

    final fromDotEnv = dotenv.env['API_BASE_URL'];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) {
      return fromDotEnv;
    }

    return 'http://127.0.0.1:8090';
  }
}
