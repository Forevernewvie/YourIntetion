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
      title: 'Rule Builder (Advanced)',
      bottomNavigation: const PscBottomNav(currentIndex: 1),
      body: ListView(
        children: [
          const Text('Tune precedence and ranking tweaks without ambiguity.'),
          const SizedBox(height: 12),
          const PscRuleSectionCard(
            title: 'Hard Filters',
            description: 'Exclude: politics, celebrity gossip',
            status: 'Highest',
            hint: 'Stage 1',
          ),
          const SizedBox(height: 8),
          const PscRuleSectionCard(
            title: 'Source Allow / Block',
            description: 'Allow: verified outlets only',
            status: 'Second',
            hint: 'Stage 2',
          ),
          const SizedBox(height: 8),
          const PscRuleSectionCard(
            title: 'Topic Priority + Tone + Length',
            description: 'Priority High > Tone Neutral > 120 words',
            status: 'Third+',
            hint: 'Stages 3-5',
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deterministic Order',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hard > Source > Topic > Tone > Length > Rank',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _strictMode,
            contentPadding: EdgeInsets.zero,
            title: const Text('Strict deterministic mode'),
            onChanged: (value) => setState(() => _strictMode = value),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: () {}, child: const Text('Simulate Result')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('View Impacted Digest'),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Run Batch Test (Disabled)',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.textTheme.labelSmall?.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
