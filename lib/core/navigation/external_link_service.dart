import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Purpose: Define a testable contract for opening external URLs.
abstract interface class ExternalLinkService {
  /// Purpose: Open the given URL outside the app and report whether it succeeded.
  Future<bool> openExternal(Uri uri);
}

/// Purpose: Provide the app-wide external link opener dependency.
final externalLinkServiceProvider = Provider<ExternalLinkService>((ref) {
  return const UrlLauncherExternalLinkService();
});

/// Purpose: Open external URLs with the shared url_launcher implementation.
final class UrlLauncherExternalLinkService implements ExternalLinkService {
  /// Purpose: Create the default external link opener implementation.
  const UrlLauncherExternalLinkService();

  /// Purpose: Delegate external browser opening to url_launcher.
  @override
  Future<bool> openExternal(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
