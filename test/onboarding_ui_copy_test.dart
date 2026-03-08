import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/constants/app_constants.dart';
import 'package:vibecodingexpert/features/onboarding/presentation/copy/onboarding_ui_copy.dart';

void main() {
  group('OnboardingUiCopy', () {
    test(
      'builds selected topic label from centralized max-selection policy',
      () {
        final label = OnboardingUiCopy.selectedTopicsLabel(3);

        expect(
          label,
          'Selected 3/${AppOnboardingPolicy.maxTopicSelections} topics',
        );
      },
    );

    test('default source weights remain balanced to 100 percent', () {
      final totalWeight = OnboardingUiCopy.sourceOptions.fold<int>(
        0,
        (total, option) => total + option.weight,
      );

      expect(totalWeight, 100);
    });

    test(
      'default topic identifiers remain unique for stable selection state',
      () {
        final titles = OnboardingUiCopy.topicOptions.map(
          (option) => option.title,
        );

        expect(titles.toSet().length, OnboardingUiCopy.topicOptions.length);
      },
    );
  });
}
