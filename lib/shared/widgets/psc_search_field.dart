import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Purpose: Provide a compact search field matching the editorial app style.
class PscSearchField extends StatelessWidget {
  /// Purpose: Construct search field with optional callback.
  const PscSearchField({this.hintText, this.onChanged, super.key});

  final String? hintText;
  final ValueChanged<String>? onChanged;

  /// Purpose: Build search field UI.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search topics or sources',
        prefixIcon: const Icon(Icons.search_rounded, size: AppUiSize.iconMd),
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppUiSize.searchFieldMinWidth,
        ),
        filled: true,
        fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
      ),
    );
  }
}
