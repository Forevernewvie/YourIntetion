import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
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
      padding: const EdgeInsets.all(AppUiSpacing.section),
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
                size: AppUiSize.iconMd,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppUiSpacing.xxl),
          Text(item.topic, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppUiSpacing.sm),
          Text(
            item.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppUiSpacing.lg),
          Text(
            item.whyReason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppUiSpacing.xl),
          Wrap(
            spacing: AppUiSpacing.sm,
            runSpacing: AppUiSpacing.sm,
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
