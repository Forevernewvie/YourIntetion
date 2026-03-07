import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/app_constants.dart';
import '../logging/app_logger.dart';

/// Purpose: Load and expose environment configuration with safe defaults.
final class AppEnv {
  AppEnv._();

  static String? _cachedApiBaseUrl;

  /// Purpose: Load .env file when available without hard failure in local development.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      AppLogger.info('env_loaded');
    } catch (_) {
      // Purpose: Allow booting without a local .env file for development fallback.
      AppLogger.warn('env_missing_using_fallbacks');
    }
  }

  /// Purpose: Resolve API base URL from env while supporting compile-time overrides.
  static String get apiBaseUrl {
    return _cachedApiBaseUrl ??= _resolveApiBaseUrl();
  }

  /// Purpose: Resolve and validate the API base URL before first use.
  static String _resolveApiBaseUrl() {
    final compileTime = const String.fromEnvironment('API_BASE_URL');
    final fromDotEnv = dotenv.env['API_BASE_URL'];
    final resolved = compileTime.isNotEmpty
        ? compileTime
        : (fromDotEnv != null && fromDotEnv.isNotEmpty)
        ? fromDotEnv
        : _defaultApiBaseUrl;

    final parsed = Uri.tryParse(resolved);
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
      throw StateError('API_BASE_URL must be an absolute URL.');
    }

    _warnIfApiBaseUrlIsInsecure(parsed);
    return parsed.toString();
  }

  /// Purpose: Provide local-development API fallback based on current platform.
  static String get _defaultApiBaseUrl {
    if (kIsWeb) {
      return AppNetworkDefaults.localApiUri(
        host: AppNetworkDefaults.localhost,
      ).toString();
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AppNetworkDefaults.localApiUri(
        host: AppNetworkDefaults.androidEmulatorHost,
      ).toString(),
      _ => AppNetworkDefaults.localApiUri(
        host: AppNetworkDefaults.localhost,
      ).toString(),
    };
  }

  /// Purpose: Log potentially unsafe release configuration without exposing secrets.
  static void _warnIfApiBaseUrlIsInsecure(Uri parsed) {
    final isLocalHost =
        parsed.host == AppNetworkDefaults.localhost ||
        parsed.host == AppNetworkDefaults.androidEmulatorHost;
    final isSecure = parsed.scheme == 'https' || isLocalHost;

    if (kReleaseMode && !isSecure) {
      AppLogger.warn(
        'env_insecure_api_base_url',
        fields: {
          'scheme': parsed.scheme,
          'host': parsed.host,
          'port': parsed.port,
        },
      );
    }
  }
}
