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
    return PscPageScaffold(
      title: 'First Digest Preview',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PscSearchField(
              hintText: 'What changed from your default feed',
            ),
            const SizedBox(height: 10),
            const PscDigestCard(
              topic: 'AI assistants in productivity tools',
              whyReason: 'Why this appears: Topic AI (High) + Allowed sources',
              summary:
                  'Rule-based summary with citation trace. Tap details to verify sources.',
              freshness: '18m ago',
              sourceMix: 'Mix: News 2 / Community 1',
            ),
            const SizedBox(height: 8),
            const PscDigestCard(
              topic: 'Creator economy monetization shifts',
              whyReason: 'Why this appears: Creator Economy (Low)',
              summary:
                  'Lower-priority topics rank lower than your focus topics.',
              freshness: '44m ago',
              sourceMix: 'Mix: Video 1 / News 1 / Community 1',
            ),
            const SizedBox(height: 8),
            PscStatusBanner(
              message:
                  'Not right yet? Adjust tone or source rules before continuing.',
              color: Theme.of(context).colorScheme.error,
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.home),
              child: const Text('Looks good, go to Home'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingToneFrequency),
              child: const Text('Back to Tone + Frequency'),
            ),
          ],
        ),
      ),
    );
  }
}
