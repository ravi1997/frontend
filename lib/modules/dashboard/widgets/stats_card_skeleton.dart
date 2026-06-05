import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_shimmer.dart';

class StatsCardSkeleton extends StatelessWidget {
  const StatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading dashboard statistics',
      child: AppShimmer(
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Flexible(child: const SkeletonCircle(size: 48)),
              const SizedBox(width: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final titleWidth = constraints.maxWidth * 0.55;
                    final valueWidth = constraints.maxWidth * 0.35;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeletonBox(width: titleWidth, height: 14),
                        const SizedBox(height: 8),
                        SkeletonBox(width: valueWidth, height: 24),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
