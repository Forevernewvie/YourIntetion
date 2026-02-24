/// Purpose: Centralized constants used across layers to avoid magic numbers.
abstract final class AppConstants {
  static const Duration apiConnectTimeout = Duration(seconds: 5);
  static const Duration apiReceiveTimeout = Duration(seconds: 12);
  static const int retryMaxAttempts = 3;
  static const Duration retryBaseDelay = Duration(milliseconds: 250);

  static const int digestQuickMaxItems = 5;
  static const int digestStandardMaxItems = 10;
  static const int digestDeepMaxItems = 15;

  static const int cacheDigestTtlMinutes = 1440;
  static const Duration remoteLatestDigestMemoryTtl = Duration(seconds: 20);
  static const int uiDefaultPadding = 16;
  static const int uiDefaultGap = 12;
}
