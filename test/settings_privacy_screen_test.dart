import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/app/theme/app_theme.dart';
import 'package:vibecodingexpert/core/constants/app_constants.dart';
import 'package:vibecodingexpert/core/navigation/external_link_service.dart';
import 'package:vibecodingexpert/features/settings/presentation/copy/settings_privacy_copy.dart';
import 'package:vibecodingexpert/features/settings/presentation/screens/settings_privacy_screen.dart';

void main() {
  group('SettingsPrivacyScreen', () {
    testWidgets('opens privacy policy with the configured GitHub Pages URL', (
      tester,
    ) async {
      final linkService = _FakeExternalLinkService(result: true);
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            externalLinkServiceProvider.overrideWithValue(linkService),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsPrivacyScreen(),
          ),
        ),
      );

      final actionFinder = find.text(
        SettingsPrivacyCopy.privacyPolicyOpenAction,
      );
      await tester.scrollUntilVisible(actionFinder, 200);
      await tester.tap(actionFinder);
      await tester.pump();

      expect(linkService.openedUris, [AppLegalUrl.privacyPolicyUri]);
    });

    testWidgets('shows feedback when privacy policy cannot be opened', (
      tester,
    ) async {
      final linkService = _FakeExternalLinkService(result: false);
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            externalLinkServiceProvider.overrideWithValue(linkService),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsPrivacyScreen(),
          ),
        ),
      );

      final actionFinder = find.text(
        SettingsPrivacyCopy.privacyPolicyOpenAction,
      );
      await tester.scrollUntilVisible(actionFinder, 200);
      await tester.tap(actionFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        find.text(SettingsPrivacyCopy.privacyPolicyOpenFailed),
        findsOneWidget,
      );
    });
  });
}

/// Purpose: Capture requested external URLs without invoking platform launchers in tests.
final class _FakeExternalLinkService implements ExternalLinkService {
  /// Purpose: Create a deterministic fake opener from the desired launch result.
  _FakeExternalLinkService({required bool result}) : _result = result;

  final bool _result;
  final openedUris = <Uri>[];

  /// Purpose: Record the requested URI and return the configured launch outcome.
  @override
  Future<bool> openExternal(Uri uri) async {
    openedUris.add(uri);
    return _result;
  }
}
