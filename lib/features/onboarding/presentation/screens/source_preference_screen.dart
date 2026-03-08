import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../copy/onboarding_ui_copy.dart';

/// Purpose: Collect source trust preferences for allowlist/blocklist setup.
class SourcePreferenceScreen extends StatelessWidget {
  /// Purpose: Create source preference screen widget.
  const SourcePreferenceScreen({super.key});

  /// Purpose: Build source preference interface.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: OnboardingUiCopy.sourcesTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PscStepHeader(
              step: 2,
              totalSteps: AppOnboardingPolicy.totalSteps,
              title: OnboardingUiCopy.sourceStep.title,
              description: OnboardingUiCopy.sourceStep.description,
              tags: OnboardingUiCopy.sourceStep.tags,
            ),
            const SizedBox(height: 16),
            for (
              var index = 0;
              index < OnboardingUiCopy.sourceOptions.length;
              index++
            ) ...[
              PscRuleSectionCard(
                title: OnboardingUiCopy.sourceOptions[index].title,
                description: OnboardingUiCopy.sourceOptions[index].description,
                status: OnboardingUiCopy.sourceOptions[index].status,
                hint: OnboardingUiCopy.sourceOptions[index].hint,
              ),
              if (index != OnboardingUiCopy.sourceOptions.length - 1)
                const SizedBox(height: 10),
            ],
            const SizedBox(height: 16),
            PscSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PscSectionTitle(OnboardingUiCopy.sourceMixSectionTitle),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          Flexible(
                            flex: OnboardingUiCopy.sourceOptions[0].weight,
                            child: Container(color: theme.colorScheme.primary),
                          ),
                          Flexible(
                            flex: OnboardingUiCopy.sourceOptions[1].weight,
                            child: ColoredBox(
                              color: theme.colorScheme.secondaryContainer,
                            ),
                          ),
                          Flexible(
                            flex: OnboardingUiCopy.sourceOptions[2].weight,
                            child: ColoredBox(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    OnboardingUiCopy.sourceMixDescription,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.onboardingToneFrequency),
              child: const Text(OnboardingUiCopy.nextToneFrequencyAction),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingTopics),
              child: const Text(OnboardingUiCopy.backAction),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutePath.onboardingPreview),
              child: const Text(OnboardingUiCopy.previewCurrentSetupAction),
            ),
          ],
        ),
      ),
    );
  }
}
