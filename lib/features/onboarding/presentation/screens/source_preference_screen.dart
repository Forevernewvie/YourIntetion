import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';

/// Purpose: Collect source trust preferences for allowlist/blocklist setup.
class SourcePreferenceScreen extends StatelessWidget {
  /// Purpose: Create source preference screen widget.
  const SourcePreferenceScreen({super.key});

  /// Purpose: Build source preference interface.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Source Preferences',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PscStepHeader(
              step: 2,
              totalSteps: 4,
              title: 'Tell the brief which sources earn trust.',
              description:
                  'You are not blocking content blindly. You are choosing which signal types deserve the most weight in a calm, credible digest.',
              tags: ['Rebalance later', 'Trust is explicit'],
            ),
            const SizedBox(height: 16),
            const PscRuleSectionCard(
              title: 'News Sources',
              description:
                  'High traceability and cleaner attribution for lead items.',
              status: '70% allowed',
              hint: 'Best for original reporting and citation confidence',
            ),
            const SizedBox(height: 10),
            const PscRuleSectionCard(
              title: 'Video Channels',
              description:
                  'Useful for commentary, but capped to avoid recap overload.',
              status: '20% limited',
              hint: 'Strong context, lighter direct evidence',
            ),
            const SizedBox(height: 10),
            const PscRuleSectionCard(
              title: 'Communities',
              description:
                  'Helpful for early signals and sentiment, but not dominant.',
              status: '10% allowed',
              hint: 'Trend detection without replacing primary sources',
            ),
            const SizedBox(height: 16),
            PscSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PscSectionTitle('Default Mix'),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 70,
                            child: Container(color: theme.colorScheme.primary),
                          ),
                          Flexible(
                            flex: 20,
                            child: ColoredBox(
                              color: theme.colorScheme.secondaryContainer,
                            ),
                          ),
                          Flexible(
                            flex: 10,
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
                    'A heavier news mix keeps the feed grounded in primary sources while still allowing commentary and community signals to surface.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.onboardingToneFrequency),
              child: const Text('Next: Tone & Frequency'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingTopics),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutePath.onboardingPreview),
              child: const Text('Preview Current Setup'),
            ),
          ],
        ),
      ),
    );
  }
}
