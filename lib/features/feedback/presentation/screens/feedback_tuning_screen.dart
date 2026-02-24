import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/digest/domain/entities/citation.dart';
import '../../../../features/digest/domain/entities/digest_item.dart';
import '../../../../features/digest/domain/entities/feedback_event.dart';
import '../../../../features/digest/presentation/providers/digest_providers.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/digest_card_tile.dart';
import '../../../../shared/widgets/psc_blocks.dart';

/// Purpose: Render digest feedback and one-tap tuning actions.
class FeedbackTuningScreen extends ConsumerWidget {
  /// Purpose: Create feedback and tuning screen widget.
  const FeedbackTuningScreen({super.key});

  /// Purpose: Build feedback interface and submit actions.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewItem = DigestItem(
      id: 'preview_item',
      topic: 'Sample digest under review',
      whyReason: 'Why this appears: Rule #4',
      summary: 'Use feedback to tune next digest.',
      freshnessMinutes: 0,
      citations: [
        Citation(
          id: 'preview_citation',
          sourceName: 'Reuters',
          canonicalUrl: Uri.parse('https://example.com'),
          publishedAt: DateTime.now().toUtc(),
        ),
      ],
    );

    return PscPageScaffold(
      title: 'Feedback + Tuning',
      body: ListView(
        children: [
          const Text(
            'Tell us what felt off. Next digest adapts deterministically.',
          ),
          const SizedBox(height: 12),
          DigestCardTile(item: previewItem, onTap: () {}),
          const SizedBox(height: 12),
          const PscSectionTitle('What should improve?'),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeedbackChip(label: 'Too long'),
              _FeedbackChip(label: 'Off-topic'),
              _FeedbackChip(label: 'Low quality source'),
            ],
          ),
          const SizedBox(height: 10),
          const PscStateRowCard(
            label: 'Tone shift',
            value: 'Neutral → More concise',
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => _submit(context, ref, 4, 'helpful_but_long'),
            child: const Text('Submit Feedback'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _submit(context, ref, 2, 'off_topic'),
            child: const Text('Preview Updated Rule'),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Submitting... (Pressed)',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Purpose: Submit feedback event through provider controller.
  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    int rating,
    String reason,
  ) async {
    final event = FeedbackEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: '',
      rating: rating,
      reason: reason,
      createdAt: DateTime.now().toUtc(),
    );

    await ref.read(submitFeedbackControllerProvider).submit(event);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Feedback submitted.')));
    }
  }
}

/// Purpose: Render one selectable feedback chip.
class _FeedbackChip extends StatelessWidget {
  /// Purpose: Construct chip with label.
  const _FeedbackChip({required this.label});

  final String label;

  /// Purpose: Build chip-like pill using surface colors.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
