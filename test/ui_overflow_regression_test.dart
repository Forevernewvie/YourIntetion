import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibecodingexpert/app/theme/app_theme.dart';
import 'package:vibecodingexpert/features/auth/presentation/screens/login_screen.dart';
import 'package:vibecodingexpert/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:vibecodingexpert/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/citation.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/digest.dart';
import 'package:vibecodingexpert/features/digest/domain/entities/digest_item.dart';
import 'package:vibecodingexpert/features/digest/presentation/providers/digest_providers.dart';
import 'package:vibecodingexpert/features/digest/presentation/screens/home_digest_feed_screen.dart';
import 'package:vibecodingexpert/features/onboarding/presentation/screens/first_digest_preview_screen.dart';
import 'package:vibecodingexpert/features/onboarding/presentation/screens/topic_selection_screen.dart';
import 'package:vibecodingexpert/shared/widgets/psc_blocks.dart';

typedef _ScreenBuilder = Widget Function();

const _portraitSizes = <Size>[
  Size(320, 568),
  Size(360, 640),
  Size(390, 844),
  Size(412, 915),
  Size(768, 1024),
  Size(1024, 768),
];

const _textScales = <double>[1.0, 1.3, 1.6, 2.0];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('Critical screen overflow regression', () {
    final screens = <String, _ScreenBuilder>{
      'login': () => const LoginScreen(),
      'signup': () => const SignUpScreen(),
      'reset_password': () => const ResetPasswordScreen(initialToken: ''),
      'topics': () => const TopicSelectionScreen(),
      'first_digest_preview': () => const FirstDigestPreviewScreen(),
    };

    testWidgets('no overflow across size/orientation/textScale/keyboard matrix', (
      tester,
    ) async {
      for (final entry in screens.entries) {
        for (final baseSize in _portraitSizes) {
          for (final isLandscape in const [false, true]) {
            final scenarioSize = isLandscape
                ? Size(baseSize.height, baseSize.width)
                : baseSize;
            for (final textScale in _textScales) {
              for (final keyboardOpen in const [false, true]) {
                await _pumpAndAssertNoOverflow(
                  tester: tester,
                  scenarioLabel:
                      '${entry.key}|${scenarioSize.width}x${scenarioSize.height}|text:$textScale|kb:${keyboardOpen ? 'open' : 'closed'}',
                  surfaceSize: scenarioSize,
                  textScale: textScale,
                  keyboardOpen: keyboardOpen,
                  child: entry.value(),
                );
              }
            }
          }
        }
      }
    });
  });

  group('Long localized text regression', () {
    testWidgets('shared cards wrap/ellipsize without overflow', (tester) async {
      const deLong =
          'Deterministische Zusammenfassung mit nachvollziehbarer Quellenkette und regelbasierter Priorisierung.';
      const koLong = '이 항목이 표시되는 이유를 명확하게 설명하고, 출처 추적 가능성을 항상 보장합니다.';

      await _pumpAndAssertNoOverflow(
        tester: tester,
        scenarioLabel: 'shared_cards_long_localized_text',
        surfaceSize: const Size(320, 568),
        textScale: 2.0,
        keyboardOpen: false,
        child: ListView(
          children: const [
            PscRuleSectionCard(
              title: deLong,
              description: deLong,
              status: 'Aktiviert',
              hint: koLong,
            ),
            SizedBox(height: 8),
            PscStateRowCard(label: deLong, value: koLong),
            SizedBox(height: 8),
            PscDigestCard(
              topic: deLong,
              whyReason: koLong,
              summary: deLong,
              freshness: 'Vor 120 Minuten',
              sourceMix: 'Mix: News 12 / Community 8 / Video 5',
            ),
          ],
        ),
      );
    });
  });

  group('Home digest runtime states', () {
    testWidgets('loading state does not overflow on small device', (
      tester,
    ) async {
      final loadingCompleter = Completer<Digest>();
      await _pumpAndAssertNoOverflow(
        tester: tester,
        scenarioLabel: 'home_loading',
        surfaceSize: const Size(320, 568),
        textScale: 2.0,
        keyboardOpen: false,
        overrides: [
          latestDigestProvider.overrideWith((ref) async {
            return loadingCompleter.future;
          }),
        ],
        child: const HomeDigestFeedScreen(),
      );
    });

    testWidgets('empty and error states do not overflow', (tester) async {
      await _pumpAndAssertNoOverflow(
        tester: tester,
        scenarioLabel: 'home_empty',
        surfaceSize: const Size(320, 568),
        textScale: 2.0,
        keyboardOpen: false,
        overrides: [
          latestDigestProvider.overrideWith((ref) async {
            return _sampleDigest(withItems: false);
          }),
        ],
        child: const HomeDigestFeedScreen(),
      );

      await _pumpAndAssertNoOverflow(
        tester: tester,
        scenarioLabel: 'home_error',
        surfaceSize: const Size(320, 568),
        textScale: 2.0,
        keyboardOpen: false,
        overrides: [
          latestDigestProvider.overrideWith((ref) async {
            throw StateError('simulated_failure');
          }),
        ],
        child: const HomeDigestFeedScreen(),
      );
    });
  });
}

/// Purpose: Pump one scenario with deterministic media params and assert zero overflow exceptions.
Future<void> _pumpAndAssertNoOverflow({
  required WidgetTester tester,
  required String scenarioLabel,
  required Size surfaceSize,
  required double textScale,
  required bool keyboardOpen,
  required Widget child,
  List<Override> overrides = const <Override>[],
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);

  final capturedErrors = <FlutterErrorDetails>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    capturedErrors.add(details);
  };

  try {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: surfaceSize,
              devicePixelRatio: 1,
              textScaler: TextScaler.linear(textScale),
              viewInsets: keyboardOpen
                  ? const EdgeInsets.only(bottom: 280)
                  : EdgeInsets.zero,
            ),
            child: KeyedSubtree(key: UniqueKey(), child: child),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
  } finally {
    FlutterError.onError = previousOnError;
    await tester.binding.setSurfaceSize(null);
  }

  final exceptionMessages = <String>[];
  Object? exception;
  while ((exception = tester.takeException()) != null) {
    exceptionMessages.add(exception.toString());
  }

  final flutterErrorMessages = capturedErrors
      .map((details) => details.exceptionAsString())
      .toList(growable: false);

  final combined = <String>[...exceptionMessages, ...flutterErrorMessages];
  final overflowMessages = combined
      .where(
        (message) =>
            message.contains('A RenderFlex overflowed by') ||
            message.contains('BOTTOM OVERFLOWED BY'),
      )
      .toList(growable: false);

  expect(
    overflowMessages,
    isEmpty,
    reason: 'Overflow detected in scenario: $scenarioLabel',
  );
}

/// Purpose: Build stable digest fixture used by runtime-state overflow tests.
Digest _sampleDigest({required bool withItems}) {
  final items = withItems
      ? <DigestItem>[
          DigestItem(
            id: 'item_1',
            topic: 'AI productivity signals',
            whyReason: 'Topic priority matched and source allowlist passed',
            summary: 'Deterministic summary block for overflow verification.',
            freshnessMinutes: 12,
            citations: [
              Citation(
                id: 'cit_1',
                sourceName: 'Reuters',
                canonicalUrl: Uri.parse('https://example.com/reuters'),
                publishedAt: DateTime.utc(2026, 1, 1, 10),
              ),
            ],
          ),
        ]
      : const <DigestItem>[];

  return Digest(
    id: 'digest_1',
    profileId: 'profile_1',
    generatedAt: DateTime.utc(2026, 1, 1, 10),
    qualityScore: 0.8,
    items: items,
  );
}
