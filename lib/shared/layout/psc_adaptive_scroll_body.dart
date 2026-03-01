import 'package:flutter/material.dart';

/// Purpose: Provide keyboard-aware scroll body that preserves bottom-aligned actions when space allows.
class PscAdaptiveScrollBody extends StatelessWidget {
  /// Purpose: Construct adaptive scroll container for column-style screen bodies.
  const PscAdaptiveScrollBody({
    required this.child,
    this.extraBottomPadding = 0,
    super.key,
  });

  final Widget child;
  final double extraBottomPadding;

  /// Purpose: Build a constrained scroll view to avoid RenderFlex overflows on small screens and large text scales.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final bottomInset = mediaQuery.viewInsets.bottom;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(bottom: bottomInset + extraBottomPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}
