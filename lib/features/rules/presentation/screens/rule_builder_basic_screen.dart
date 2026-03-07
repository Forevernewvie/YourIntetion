import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/digest/presentation/providers/digest_providers.dart';
import '../../../../shared/feedback/app_feedback_messenger.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';

/// Purpose: Render basic rule controls for topic/tone/length updates.
class RuleBuilderBasicScreen extends ConsumerStatefulWidget {
  /// Purpose: Create basic rule builder screen widget.
  const RuleBuilderBasicScreen({super.key});

  /// Purpose: Create mutable state instance.
  @override
  ConsumerState<RuleBuilderBasicScreen> createState() =>
      _RuleBuilderBasicScreenState();
}

/// Purpose: Manage local form state before saving profile updates.
class _RuleBuilderBasicScreenState
    extends ConsumerState<RuleBuilderBasicScreen> {
  late double _aiPriority;
  bool _hideDuplicates = true;

  /// Purpose: Initialize local controls from active profile.
  @override
  void initState() {
    super.initState();
    final profile = ref.read(activeRuleProfileProvider);
    _aiPriority = (profile.topicPriorities['AI'] ?? 90).toDouble();
  }

  /// Purpose: Persist edited profile via use case controller.
  Future<void> _saveProfile() async {
    final profile = ref.read(activeRuleProfileProvider);
    final nextProfile = profile.copyWith(
      version: profile.version + 1,
      topicPriorities: {...profile.topicPriorities, 'AI': _aiPriority.toInt()},
      hardFilters: _hideDuplicates
          ? {
              ...profile.hardFilters,
              'duplicate_cross_post',
            }.toList(growable: false)
          : profile.hardFilters
                .where((item) => item != 'duplicate_cross_post')
                .toList(growable: false),
      updatedAt: DateTime.now().toUtc(),
    );

    await ref.read(saveRuleProfileControllerProvider).save(nextProfile);
    if (!mounted) {
      return;
    }
    AppFeedbackMessenger.showSuccess(
      context,
      message: AppFeedbackMessage.basicRulesSaved,
      event: 'rules_basic_saved',
      fields: {
        'aiPriority': _aiPriority.toInt(),
        'hideDuplicates': _hideDuplicates,
      },
    );
  }

  /// Purpose: Build basic rule editor interface.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Rule Console',
      bottomNavigation: const PscBottomNav(currentIndex: 1),
      body: ListView(
        children: [
          PscSurfaceCard(
            emphasize: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscInfoPill(
                  label: 'Personal Curation Console',
                  icon: Icons.tune_outlined,
                ),
                const SizedBox(height: 16),
                Text(
                  'Shape what earns your attention.',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'These rules decide which topics rise, which duplicates disappear, and how the brief stays calm without becoming bland.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PscInfoPill(
                      label: 'AI priority ${_aiPriority.toInt()}',
                      icon: Icons.auto_graph_outlined,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    PscInfoPill(
                      label: _hideDuplicates ? 'Dedupe on' : 'Dedupe off',
                      icon: Icons.filter_alt_outlined,
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.18,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const PscSectionTitle('Active Rule Profiles'),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: 'AI Productivity',
            description: 'Neutral tone, daily cadence, highest ranking weight.',
            status: 'Enabled',
            hint: 'Primary lens for the home brief',
          ),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: 'Product Strategy',
            description: 'Analytical framing with weekday emphasis.',
            status: 'Enabled',
            hint: 'Secondary pattern for strategic context',
          ),
          const SizedBox(height: 10),
          PscRuleSectionCard(
            title: 'Creator Economy',
            description: _hideDuplicates
                ? 'Brief weekly pulse with duplicate protection.'
                : 'Brief weekly pulse without duplicate protection.',
            status: _hideDuplicates ? 'Enabled' : 'Review',
            hint: _hideDuplicates
                ? 'Recaps stay compressed into a single signal'
                : 'Duplicate recap risk is currently higher',
            statusColor: _hideDuplicates
                ? theme.colorScheme.primary
                : theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          PscSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscSectionTitle('Priority Tuning'),
                const SizedBox(height: 12),
                Text(
                  'AI topic priority: ${_aiPriority.toInt()}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Raise this if you want AI workflow signals to outrank everything else in the brief.',
                  style: theme.textTheme.bodySmall,
                ),
                Slider(
                  min: 60,
                  max: 180,
                  value: _aiPriority,
                  onChanged: (value) => setState(() => _aiPriority = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PscSurfaceCard(
            child: SwitchListTile(
              value: _hideDuplicates,
              contentPadding: EdgeInsets.zero,
              title: const Text('Hide duplicate stories'),
              subtitle: const Text(
                'Keep repeated recaps and cross-posts from flooding the brief.',
              ),
              onChanged: (value) => setState(() => _hideDuplicates = value),
            ),
          ),
          const SizedBox(height: 12),
          PscStatusBanner(
            message:
                'Hard filters still win over softer ranking rules when conflicts appear.',
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _saveProfile,
            child: const Text('Save Tuning'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go(AppRoutePath.rulesAdvanced),
            child: const Text('Open Advanced Builder'),
          ),
        ],
      ),
    );
  }
}
