import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_search_field.dart';

/// Purpose: Collect user topic preferences for initial profile setup.
class TopicSelectionScreen extends StatefulWidget {
  /// Purpose: Create topic selection screen widget.
  const TopicSelectionScreen({super.key});

  /// Purpose: Create mutable state instance.
  @override
  State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
}

/// Purpose: Manage chip selection state for topics.
class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  static const _topics = <_TopicOption>[
    _TopicOption(
      title: 'AI Productivity',
      priority: 'High',
      description:
          'Tools, workflows, and applied automation that reduce friction.',
    ),
    _TopicOption(
      title: 'Product Strategy',
      priority: 'Medium',
      description:
          'Signals on roadmap thinking, positioning, and product bets.',
    ),
    _TopicOption(
      title: 'Creator Economy',
      priority: 'Low',
      description:
          'Monetization shifts, audience strategy, and platform changes.',
    ),
  ];

  final Set<String> _selected = {
    'AI Productivity',
    'Product Strategy',
    'Creator Economy',
  };

  /// Purpose: Toggle selected state of a topic chip.
  void _toggleTopic(String topic) {
    setState(() {
      if (_selected.contains(topic)) {
        _selected.remove(topic);
      } else {
        _selected.add(topic);
      }
    });
  }

  /// Purpose: Build topic selection interface.
  @override
  Widget build(BuildContext context) {
    return PscPageScaffold(
      title: 'Choose Topics',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PscStepHeader(
              step: 1,
              totalSteps: 4,
              title: 'Train the brief around your real interests.',
              description:
                  'Pick a small set of focus areas. Higher-priority topics rise first, but you can adjust the ranking later.',
              tags: ['Pick 3-8 topics', 'Priority shapes order'],
            ),
            const SizedBox(height: 16),
            const PscSearchField(hintText: 'Search or add a topic signal'),
            const SizedBox(height: 16),
            ..._topics.map((topic) {
              final selected = _selected.contains(topic.title);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PscRuleSectionCard(
                  title: topic.title,
                  description:
                      '${topic.description} Priority: ${topic.priority}.',
                  status: selected ? 'Selected' : 'Available',
                  hint: selected
                      ? 'Included in your training set'
                      : 'Tap to include in the brief',
                  statusColor: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.labelSmall?.color,
                  onTap: () => _toggleTopic(topic.title),
                ),
              );
            }),
            const SizedBox(height: 6),
            PscInfoPill(
              label: 'Selected ${_selected.length}/8 topics',
              icon: Icons.checklist_rtl_outlined,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () => context.go(AppRoutePath.onboardingSources),
              child: const Text('Next: Sources'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.welcome),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutePath.onboardingPreview),
              child: const Text('Preview Sample Instead'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Represent a topic option shown in onboarding.
class _TopicOption {
  /// Purpose: Construct one topic option.
  const _TopicOption({
    required this.title,
    required this.priority,
    required this.description,
  });

  final String title;
  final String priority;
  final String description;
}
