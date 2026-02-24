import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/digest/presentation/providers/digest_providers.dart';
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
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Basic rules saved.')));
    }
  }

  /// Purpose: Build basic rule editor interface.
  @override
  Widget build(BuildContext context) {
    return PscPageScaffold(
      title: 'Rule Builder (Basic)',
      bottomNavigation: const PscBottomNav(currentIndex: 1),
      body: ListView(
        children: [
          PscRuleSectionCard(
            title: 'Rule 01: AI Productivity',
            description:
                'Tone Neutral • Daily • Max ${_aiPriority.toInt()} words',
            status: 'Enabled',
            hint: 'Priority: High',
          ),
          const SizedBox(height: 8),
          const PscRuleSectionCard(
            title: 'Rule 02: Product Strategy',
            description: 'Tone Analytical • Weekdays',
            status: 'Enabled',
            hint: 'Priority: Medium',
          ),
          const SizedBox(height: 8),
          PscRuleSectionCard(
            title: 'Rule 03: Creator Economy',
            description: _hideDuplicates
                ? 'Tone Brief • Weekly • Dedupe ON'
                : 'Tone Brief • Weekly • Dedupe OFF',
            status: _hideDuplicates ? 'Enabled' : 'Paused',
            hint: 'Priority: Low',
          ),
          const SizedBox(height: 8),
          PscStatusBanner(
            message: 'Conflict rule: hard filters always win.',
            color: const Color(0xFFA86A00),
          ),
          const SizedBox(height: 12),
          Text(
            'AI topic priority: ${_aiPriority.toInt()}',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Slider(
            min: 60,
            max: 180,
            value: _aiPriority,
            onChanged: (value) => setState(() => _aiPriority = value),
          ),
          SwitchListTile(
            value: _hideDuplicates,
            contentPadding: EdgeInsets.zero,
            title: const Text('Hide duplicate stories'),
            onChanged: (value) => setState(() => _hideDuplicates = value),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _saveProfile, child: const Text('Add Rule')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _saveProfile,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
