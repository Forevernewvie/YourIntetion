import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/digest_card_tile.dart';
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
          final first = digest.items.first;
          return ListView(
            children: [
              Text(
                'Readable in 45 seconds • ${first.citations.length} traceable citations',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DigestCardTile(item: first, onTap: () {}),
              const SizedBox(height: 12),
              const PscSectionTitle('Citations'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: first.citations
                    .map(
                      (citation) => _CitationChip(label: citation.sourceName),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why am I seeing this?',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      first.whyReason,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.go('/feedback'),
                      child: const Text('Useful'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/feedback'),
                      child: const Text('Needs Tuning'),
                    ),
                  ),
                ],
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

/// Purpose: Render compact citation pill.
class _CitationChip extends StatelessWidget {
  /// Purpose: Construct citation pill with source label.
  const _CitationChip({required this.label});

  final String label;

  /// Purpose: Build source citation chip.
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link, size: 12, color: theme.textTheme.labelSmall?.color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
