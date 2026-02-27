import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibecodingexpert/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  group('OnboardingStatusController', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('loads false by default, then persists complete and reset', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = await container.read(onboardingStatusProvider.future);
      expect(initial, isFalse);

      await container.read(onboardingStatusProvider.notifier).markCompleted();
      final completed = container.read(onboardingStatusProvider).valueOrNull;
      expect(completed, isTrue);

      await container.read(onboardingStatusProvider.notifier).reset();
      final reset = container.read(onboardingStatusProvider).valueOrNull;
      expect(reset, isFalse);
    });
  });
}
