import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  static const _topics = [
    'AI Productivity',
    'Product Strategy',
    'Creator Economy',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Pick 3-8 topics. Priority controls digest ordering.'),
          const SizedBox(height: 12),
          const PscSearchField(),
          const SizedBox(height: 12),
          ..._topics.map((topic) {
            final selected = _selected.contains(topic);
            final priority = switch (topic) {
              'AI Productivity' => 'High',
              'Product Strategy' => 'Medium',
              _ => 'Low',
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PscRuleSectionCard(
                title: topic,
                description: 'Priority: $priority | Tone inherited',
                status: selected ? 'Selected' : 'Not selected',
                hint: selected ? 'Why: profile fit' : 'Tap to select',
                statusColor: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.labelSmall?.color,
                onTap: () => _toggleTopic(topic),
              ),
            );
          }),
          const SizedBox(height: 4),
          Text(
            'Selected ${_selected.length}/8 topics',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _selected.isEmpty
                ? null
                : () => context.go('/onboarding/sources'),
            child: const Text('Next: Sources'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/welcome'),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
