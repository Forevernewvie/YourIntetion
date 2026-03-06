import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_search_field.dart';

/// Purpose: Provide a first-run digest preview with explainability cues before home.
class FirstDigestPreviewScreen extends StatelessWidget {
  /// Purpose: Create first digest preview screen widget.
  const FirstDigestPreviewScreen({super.key});

  /// Purpose: Build deterministic preview UI demonstrating why-items and citation trace.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Digest Preview',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PscStepHeader(
              step: 4,
              totalSteps: 4,
              title: 'Preview how your brief will feel.',
              description:
                  'This is not a generic news feed. It is a ranked reading surface that explains why each item earned attention.',
              tags: ['Review before home', 'Tune if needed'],
            ),
            const SizedBox(height: 16),
            const PscSearchField(
              hintText: 'What changed from your default feed',
            ),
            const SizedBox(height: 12),
            const PscDigestCard(
              topic: 'AI assistants in productivity tools',
              whyReason: 'Why this appears: Topic AI (High) + Allowed sources',
              summary:
                  'Rule-based summary with citation trace. Tap details to verify sources and understand the ranking logic.',
              freshness: '18m ago',
              sourceMix: 'News 2 / Community 1',
            ),
            const SizedBox(height: 10),
            const PscDigestCard(
              topic: 'Creator economy monetization shifts',
              whyReason: 'Why this appears: Creator Economy (Low)',
              summary:
                  'Lower-priority topics still surface, but they sit behind your stronger focus areas and source preferences.',
              freshness: '44m ago',
              sourceMix: 'Video 1 / News 1 / Community 1',
            ),
            const SizedBox(height: 12),
            PscStatusBanner(
              message:
                  'Not quite right? Adjust the tone or source mix now before this becomes your default home feed.',
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.home),
              child: const Text('Looks Good, Go Home'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingToneFrequency),
              child: const Text('Back to Tone & Frequency'),
            ),
          ],
        ),
      ),
    );
  }
}
