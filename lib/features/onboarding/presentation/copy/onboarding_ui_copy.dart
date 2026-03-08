import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Purpose: Describe reusable onboarding step header content outside screen widgets.
final class OnboardingStepContent {
  /// Purpose: Construct immutable onboarding step header copy.
  const OnboardingStepContent({
    required this.title,
    required this.description,
    required this.tags,
  });

  final String title;
  final String description;
  final List<String> tags;
}

/// Purpose: Describe a reusable onboarding bullet point with iconography.
final class OnboardingBulletContent {
  /// Purpose: Construct immutable onboarding bullet content.
  const OnboardingBulletContent({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Purpose: Describe one onboarding topic option outside widget state.
final class OnboardingTopicOption {
  /// Purpose: Construct immutable topic option content.
  const OnboardingTopicOption({
    required this.title,
    required this.priority,
    required this.description,
  });

  final String title;
  final String priority;
  final String description;
}

/// Purpose: Describe one onboarding source mix option outside widget trees.
final class OnboardingSourceOption {
  /// Purpose: Construct immutable source option content.
  const OnboardingSourceOption({
    required this.title,
    required this.description,
    required this.status,
    required this.hint,
    required this.weight,
  });

  final String title;
  final String description;
  final String status;
  final String hint;
  final int weight;
}

/// Purpose: Describe one preview digest card shown during onboarding.
final class OnboardingPreviewDigestCardContent {
  /// Purpose: Construct immutable preview digest card content.
  const OnboardingPreviewDigestCardContent({
    required this.topic,
    required this.whyReason,
    required this.summary,
    required this.freshness,
    required this.sourceMix,
  });

  final String topic;
  final String whyReason;
  final String summary;
  final String freshness;
  final String sourceMix;
}

/// Purpose: Centralize onboarding screen copy, options, and labels for reuse.
abstract final class OnboardingUiCopy {
  static const welcomeTitle = 'Welcome';
  static const topicsTitle = 'Choose Topics';
  static const sourcesTitle = 'Source Preferences';
  static const toneFrequencyTitle = 'Tone & Frequency';
  static const previewTitle = 'Digest Preview';

  static const welcomeEyebrow = 'Explainable AI Digest';
  static const welcomeHeadline = 'A calmer brief, trained on your rules.';
  static const welcomeDescription =
      'Set a few preferences and this app will rank what matters, show why it surfaced, and attach the sources behind every summary.';
  static const welcomeSignalTraceable = 'Traceable citations';
  static const welcomeSignalRules = 'Rule-first ranking';
  static const setupSectionTitle = 'What You Will Set Up';
  static const setupStatusMessage =
      'Four short steps. You can revise everything later in the rules console.';
  static const startPersonalizingAction = 'Start Personalizing';
  static const previewSampleDigestAction = 'Preview Sample Digest';
  static const backAction = 'Back';
  static const previewSampleInsteadAction = 'Preview Sample Instead';
  static const previewCurrentSetupAction = 'Preview Current Setup';
  static const nextSourcesAction = 'Next: Sources';
  static const nextToneFrequencyAction = 'Next: Tone & Frequency';
  static const finishPreviewAction = 'Finish & Preview Digest';
  static const looksGoodGoHomeAction = 'Looks Good, Go Home';
  static const backToToneFrequencyAction = 'Back to Tone & Frequency';
  static const previewDigestAlertLabel = 'Preview digest alert';

  static const welcomeSetupBullets = [
    OnboardingBulletContent(
      label: 'Choose a focused set of topics to guide the ranking order.',
      icon: Icons.interests_outlined,
    ),
    OnboardingBulletContent(
      label: 'Shape which source types earn trust in the feed.',
      icon: Icons.fact_check_outlined,
    ),
    OnboardingBulletContent(
      label: 'Adjust tone and cadence before previewing your first brief.',
      icon: Icons.schedule_outlined,
    ),
  ];

  static const topicStep = OnboardingStepContent(
    title: 'Train the brief around your real interests.',
    description:
        'Pick a small set of focus areas. Higher-priority topics rise first, but you can adjust the ranking later.',
    tags: ['Pick 3-8 topics', 'Priority shapes order'],
  );
  static const topicSearchHint = 'Search or add a topic signal';
  static const topicOptions = [
    OnboardingTopicOption(
      title: 'AI Productivity',
      priority: 'High',
      description:
          'Tools, workflows, and applied automation that reduce friction.',
    ),
    OnboardingTopicOption(
      title: 'Product Strategy',
      priority: 'Medium',
      description:
          'Signals on roadmap thinking, positioning, and product bets.',
    ),
    OnboardingTopicOption(
      title: 'Creator Economy',
      priority: 'Low',
      description:
          'Monetization shifts, audience strategy, and platform changes.',
    ),
  ];
  static const defaultSelectedTopics = [
    'AI Productivity',
    'Product Strategy',
    'Creator Economy',
  ];

  static const sourceStep = OnboardingStepContent(
    title: 'Tell the brief which sources earn trust.',
    description:
        'You are not blocking content blindly. You are choosing which signal types deserve the most weight in a calm, credible digest.',
    tags: ['Rebalance later', 'Trust is explicit'],
  );
  static const sourceMixSectionTitle = 'Default Mix';
  static const sourceMixDescription =
      'A heavier news mix keeps the feed grounded in primary sources while still allowing commentary and community signals to surface.';
  static const sourceOptions = [
    OnboardingSourceOption(
      title: 'News Sources',
      description: 'High traceability and cleaner attribution for lead items.',
      status: '70% allowed',
      hint: 'Best for original reporting and citation confidence',
      weight: AppOnboardingPolicy.defaultNewsSourceWeight,
    ),
    OnboardingSourceOption(
      title: 'Video Channels',
      description: 'Useful for commentary, but capped to avoid recap overload.',
      status: '20% limited',
      hint: 'Strong context, lighter direct evidence',
      weight: AppOnboardingPolicy.defaultVideoSourceWeight,
    ),
    OnboardingSourceOption(
      title: 'Communities',
      description: 'Helpful for early signals and sentiment, but not dominant.',
      status: '10% allowed',
      hint: 'Trend detection without replacing primary sources',
      weight: AppOnboardingPolicy.defaultCommunitySourceWeight,
    ),
  ];

  static const toneStep = OnboardingStepContent(
    title: 'Set how the brief should sound and arrive.',
    description:
        'Choose a cadence that feels sustainable. The goal is a digest you actually return to, not another noisy notification stream.',
    tags: ['Daily by default', 'Tone can evolve'],
  );
  static const digestToneSectionTitle = 'Digest Tone';
  static const digestToneDescription =
      'Neutral is the default because it lowers cognitive load while keeping room for analytical context when a story needs it.';
  static const deliveryCadenceTitle = 'Delivery Cadence';
  static const deliveryCadenceDescription =
      'Daily 08:00 brief with a weekly deeper scan on Friday.';
  static const deliveryCadenceStatus = 'Active';
  static const deliveryCadenceHint =
      'Designed for a calm, predictable reading habit';
  static const toneNeutral = 'Neutral';
  static const toneAnalytical = 'Analytical';
  static const toneBrief = 'Brief';
  static const previewAlertOn = 'ON';
  static const previewAlertOff = 'OFF';

  static const previewStep = OnboardingStepContent(
    title: 'Preview how your brief will feel.',
    description:
        'This is not a generic news feed. It is a ranked reading surface that explains why each item earned attention.',
    tags: ['Review before home', 'Tune if needed'],
  );
  static const previewSearchHint = 'What changed from your default feed';
  static const previewStatusMessage =
      'Not quite right? Adjust the tone or source mix now before this becomes your default home feed.';
  static const previewCards = [
    OnboardingPreviewDigestCardContent(
      topic: 'AI assistants in productivity tools',
      whyReason: 'Why this appears: Topic AI (High) + Allowed sources',
      summary:
          'Rule-based summary with citation trace. Tap details to verify sources and understand the ranking logic.',
      freshness: '18m ago',
      sourceMix: 'News 2 / Community 1',
    ),
    OnboardingPreviewDigestCardContent(
      topic: 'Creator economy monetization shifts',
      whyReason: 'Why this appears: Creator Economy (Low)',
      summary:
          'Lower-priority topics still surface, but they sit behind your stronger focus areas and source preferences.',
      freshness: '44m ago',
      sourceMix: 'Video 1 / News 1 / Community 1',
    ),
  ];

  /// Purpose: Build the selected-topic summary label from centralized onboarding policy.
  static String selectedTopicsLabel(int selectedCount) {
    return 'Selected $selectedCount/${AppOnboardingPolicy.maxTopicSelections} topics';
  }
}
