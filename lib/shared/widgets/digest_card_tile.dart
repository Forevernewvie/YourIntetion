import 'package:flutter/material.dart';

import '../../features/digest/domain/entities/digest_item.dart';
import 'psc_blocks.dart';

/// Purpose: Render digest item with explainability and citation metadata.
class DigestCardTile extends StatelessWidget {
  /// Purpose: Construct card widget with required item and tap callback.
  const DigestCardTile({required this.item, required this.onTap, super.key});

  final DigestItem item;
  final VoidCallback onTap;

  /// Purpose: Build digest card UI for feed and detail previews.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PscInfoPill(
                label: '${item.freshnessMinutes}m ago',
                icon: Icons.schedule_outlined,
                backgroundColor: theme.colorScheme.secondary.withValues(
                  alpha: 0.18,
                ),
                foregroundColor: theme.colorScheme.primary,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_outward_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(item.topic, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            item.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            item.whyReason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PscInfoPill(
                label: '${item.citations.length} traceable sources',
                icon: Icons.link_outlined,
                backgroundColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.tertiary,
              ),
              PscInfoPill(
                label: 'Personalized by rules',
                icon: Icons.tune_outlined,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.09,
                ),
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
