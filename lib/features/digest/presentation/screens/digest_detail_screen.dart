import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../features/digest/domain/entities/citation.dart';
import '../../../../features/digest/domain/entities/digest_item.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../providers/digest_providers.dart';

/// Purpose: Render digest detail including reason trace and citation links.
class DigestDetailScreen extends ConsumerWidget {
  /// Purpose: Create digest detail screen widget.
  const DigestDetailScreen({required this.digestId, super.key});

  final String digestId;

  /// Purpose: Build detail screen from digest detail provider.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digestAsync = ref.watch(digestDetailProvider(digestId));

    return PscPageScaffold(
      title: 'Digest Detail',
      body: digestAsync.when(
        data: (digest) {
          if (digest.items.isEmpty) {
            return Center(
              child: PscStatusBanner(
                message: 'No digest detail is available yet.',
                color: Theme.of(context).colorScheme.error,
              ),
            );
          }

          final first = digest.items.first;
          return ListView(
            children: [
              _DetailHero(item: first),
              const SizedBox(height: 16),
              _ReasonCard(reason: first.whyReason),
              const SizedBox(height: 16),
              _CitationCard(citations: first.citations),
              const SizedBox(height: 16),
              _FeedbackCard(
                onFeedback: () => context.go(AppRoutePath.feedback),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: PscStatusBanner(
            message: 'Failed to load digest detail.',
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

/// Purpose: Render the detail hero with reading promise and quick actions.
class _DetailHero extends StatelessWidget {
  /// Purpose: Construct detail hero.
  const _DetailHero({required this.item});

  final DigestItem item;

  /// Purpose: Build detail hero.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estimatedSeconds = (item.summary.split(RegExp(r'\s+')).length * 2)
        .clamp(30, 90);

    return PscSurfaceCard(
      emphasize: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const PscInfoPill(
                label: 'Traceable Brief',
                icon: Icons.verified_outlined,
              ),
              PscInfoPill(
                label: '${item.citations.length} sources',
                icon: Icons.link_outlined,
                backgroundColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(item.topic, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(item.summary, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PscInfoPill(
                label: '$estimatedSeconds sec read',
                icon: Icons.schedule_outlined,
                backgroundColor: theme.colorScheme.secondary.withValues(
                  alpha: 0.18,
                ),
                foregroundColor: theme.colorScheme.onSurface,
              ),
              PscInfoPill(
                label: '${item.freshnessMinutes}m freshness',
                icon: Icons.update_rounded,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Purpose: Render the personalization rationale for the current digest.
class _ReasonCard extends StatelessWidget {
  /// Purpose: Construct reason explanation card.
  const _ReasonCard({required this.reason});

  final String reason;

  /// Purpose: Build reason explanation card.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PscSectionTitle('Why This Matters To You'),
          const SizedBox(height: 12),
          Text(
            'This item appears because your current rule profile prioritized a signal that matched both topic intent and source trust.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            reason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Purpose: Render the traceable source list with publication details.
class _CitationCard extends StatelessWidget {
  /// Purpose: Construct citation card.
  const _CitationCard({required this.citations});

  final List<Citation> citations;

  /// Purpose: Build citation card.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PscSectionTitle('Traceable Sources'),
              const Spacer(),
              Text(
                '${citations.length} attached',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...citations.asMap().entries.map((entry) {
            final index = entry.key;
            final citation = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == citations.length - 1 ? 0 : 12,
              ),
              child: _CitationRow(citation: citation),
            );
          }),
        ],
      ),
    );
  }
}

/// Purpose: Render one citation row with source, host, and publish date.
class _CitationRow extends StatelessWidget {
  /// Purpose: Construct citation row.
  const _CitationRow({required this.citation});

  final Citation citation;

  /// Purpose: Build the citation row.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final host = citation.canonicalUrl.host.replaceFirst('www.', '');
    final published = _formatDate(citation.publishedAt.toLocal());

    return PscSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.08),
      borderColor: theme.dividerColor.withValues(alpha: 0.45),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.link_outlined,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(citation.sourceName, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(host, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            published,
            textAlign: TextAlign.end,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

/// Purpose: Render feedback actions with clear next-step framing.
class _FeedbackCard extends StatelessWidget {
  /// Purpose: Construct feedback action card.
  const _FeedbackCard({required this.onFeedback});

  final VoidCallback onFeedback;

  /// Purpose: Build feedback action card.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PscSectionTitle('Close The Loop'),
          const SizedBox(height: 12),
          Text(
            'A quick signal here helps the next brief rank better items and explain itself more clearly.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onFeedback,
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                  label: const Text('Useful'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onFeedback,
                  icon: const Icon(Icons.tune_outlined, size: 18),
                  label: const Text('Needs Tuning'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[value.month - 1]} ${value.day}';
}
