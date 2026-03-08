import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_search_field.dart';
import '../copy/onboarding_ui_copy.dart';

/// Purpose: Provide a first-run digest preview with explainability cues before home.
class FirstDigestPreviewScreen extends StatelessWidget {
  /// Purpose: Create first digest preview screen widget.
  const FirstDigestPreviewScreen({super.key});

  /// Purpose: Build deterministic preview UI demonstrating why-items and citation trace.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: OnboardingUiCopy.previewTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PscStepHeader(
              step: 4,
              totalSteps: AppOnboardingPolicy.totalSteps,
              title: OnboardingUiCopy.previewStep.title,
              description: OnboardingUiCopy.previewStep.description,
              tags: OnboardingUiCopy.previewStep.tags,
            ),
            const SizedBox(height: 16),
            const PscSearchField(hintText: OnboardingUiCopy.previewSearchHint),
            const SizedBox(height: 12),
            ...OnboardingUiCopy.previewCards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == OnboardingUiCopy.previewCards.length - 1
                      ? 0
                      : AppUiSpacing.md,
                ),
                child: PscDigestCard(
                  topic: card.topic,
                  whyReason: card.whyReason,
                  summary: card.summary,
                  freshness: card.freshness,
                  sourceMix: card.sourceMix,
                ),
              );
            }),
            const SizedBox(height: 12),
            PscStatusBanner(
              message: OnboardingUiCopy.previewStatusMessage,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.home),
              child: const Text(OnboardingUiCopy.looksGoodGoHomeAction),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingToneFrequency),
              child: const Text(OnboardingUiCopy.backToToneFrequencyAction),
            ),
          ],
        ),
      ),
    );
  }
}
