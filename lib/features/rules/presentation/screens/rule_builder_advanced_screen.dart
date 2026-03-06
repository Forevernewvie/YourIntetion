import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';

/// Purpose: Render advanced deterministic rule controls and precedence explanation.
class RuleBuilderAdvancedScreen extends ConsumerStatefulWidget {
  /// Purpose: Create advanced rule builder screen widget.
  const RuleBuilderAdvancedScreen({super.key});

  /// Purpose: Create mutable state instance.
  @override
  ConsumerState<RuleBuilderAdvancedScreen> createState() =>
      _RuleBuilderAdvancedScreenState();
}

/// Purpose: Manage advanced rule toggles.
class _RuleBuilderAdvancedScreenState
    extends ConsumerState<RuleBuilderAdvancedScreen> {
  bool _strictMode = true;

  /// Purpose: Build advanced rule screen.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Advanced Rules',
      bottomNavigation: const PscBottomNav(currentIndex: 1),
      body: ListView(
        children: [
          PscSurfaceCard(
            emphasize: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscInfoPill(
                  label: 'Expert Console',
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: 16),
                Text(
                  'Inspect the ranking pipeline without ambiguity.',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'This view exposes precedence and lets you simulate how a rule change will ripple through the digest before it becomes the default behavior.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const PscSectionTitle('Evaluation Order'),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: '1. Hard Filters',
            description:
                'Remove banned topics, low-trust patterns, and known noise.',
            status: 'Highest priority',
            hint: 'Nothing below can override this stage',
          ),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: '2. Source Allow / Block',
            description:
                'Bias the feed toward verified outlets and away from weak evidence.',
            status: 'Second pass',
            hint: 'Trust calibration happens before scoring',
          ),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: '3. Topic, Tone, Length, Rank',
            description:
                'Score the remaining set and shape the final reading experience.',
            status: 'Third and below',
            hint: 'This is where nuance enters the brief',
          ),
          const SizedBox(height: 16),
          PscSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscSectionTitle('Deterministic Chain'),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PscInfoPill(
                      label: 'Hard',
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    PscInfoPill(
                      label: 'Source',
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.2,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    PscInfoPill(
                      label: 'Topic',
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.2,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    PscInfoPill(
                      label: 'Tone',
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.2,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    PscInfoPill(
                      label: 'Length',
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.2,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    PscInfoPill(
                      label: 'Rank',
                      backgroundColor: theme.colorScheme.tertiary.withValues(
                        alpha: 0.1,
                      ),
                      foregroundColor: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'The order is intentionally rigid so a saved profile behaves the same way every time new content arrives.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PscSurfaceCard(
            child: SwitchListTile(
              value: _strictMode,
              contentPadding: EdgeInsets.zero,
              title: const Text('Strict deterministic mode'),
              subtitle: const Text(
                'Lock the entire ranking chain so preview and production outputs stay aligned.',
              ),
              onChanged: (value) => setState(() => _strictMode = value),
            ),
          ),
          const SizedBox(height: 10),
          PscStatusBanner(
            message:
                'Simulation is the safest place to test aggressive ranking changes before they affect the home brief.',
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 14),
          FilledButton(onPressed: () {}, child: const Text('Simulate Result')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('View Impacted Digest'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: null,
            child: const Text('Run Batch Test (Disabled)'),
          ),
        ],
      ),
    );
  }
}
