import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_search_field.dart';
import '../copy/onboarding_ui_copy.dart';

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
  final Set<String> _selected = {...OnboardingUiCopy.defaultSelectedTopics};

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
      title: OnboardingUiCopy.topicsTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PscStepHeader(
              step: 1,
              totalSteps: AppOnboardingPolicy.totalSteps,
              title: OnboardingUiCopy.topicStep.title,
              description: OnboardingUiCopy.topicStep.description,
              tags: OnboardingUiCopy.topicStep.tags,
            ),
            const SizedBox(height: 16),
            const PscSearchField(hintText: OnboardingUiCopy.topicSearchHint),
            const SizedBox(height: 16),
            ...OnboardingUiCopy.topicOptions.map((topic) {
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
              label: OnboardingUiCopy.selectedTopicsLabel(_selected.length),
              icon: Icons.checklist_rtl_outlined,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () => context.go(AppRoutePath.onboardingSources),
              child: const Text(OnboardingUiCopy.nextSourcesAction),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.welcome),
              child: const Text(OnboardingUiCopy.backAction),
            ),
            TextButton(
              onPressed: () => context.go(AppRoutePath.onboardingPreview),
              child: const Text(OnboardingUiCopy.previewSampleInsteadAction),
            ),
          ],
        ),
      ),
    );
  }
}
