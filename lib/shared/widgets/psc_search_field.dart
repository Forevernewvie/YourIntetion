import 'package:flutter/material.dart';

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
        prefixIcon: const Icon(Icons.search_rounded, size: 18),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        filled: true,
        fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
      ),
    );
  }
}
