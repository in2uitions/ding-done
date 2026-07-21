import 'package:flutter/material.dart';

/// Lightweight loading placeholder used instead of the unmaintained
/// `skeletons` package (incompatible with current Flutter ThemeData API).
class SkeletonListView extends StatelessWidget {
  const SkeletonListView({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Container(
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
