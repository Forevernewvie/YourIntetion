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
      title: 'Set Source Preferences',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Allow or block source types. Feed remains deterministic.',
            ),
            const SizedBox(height: 12),
            const PscRuleSectionCard(
              title: 'News Sources',
              description: 'Allow: 70% | Block: 0',
              status: 'Allowed',
              hint: 'Why: highest traceability',
            ),
            const SizedBox(height: 8),
            const PscRuleSectionCard(
              title: 'Video Channels',
              description: 'Allow: 20% | Block: 2',
              status: 'Limited',
              hint: 'Why: avoid recap spam',
            ),
            const SizedBox(height: 8),
            const PscRuleSectionCard(
              title: 'Communities',
              description: 'Allow: 10% | Block: 1',
              status: 'Allowed',
              hint: 'Why: trend signals',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(999),
                ),
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
                      child: ColoredBox(color: theme.colorScheme.tertiary),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.onboardingToneFrequency),
              child: const Text('Next: Tone & Frequency'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingTopics),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
