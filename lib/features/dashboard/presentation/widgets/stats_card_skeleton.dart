import 'package:flutter/material.dart';
import '../../../../core/widgets/app_shimmer.dart';

class StatsCardSkeleton extends StatelessWidget {
  const StatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
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
            const SkeletonCircle(size: 48),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SkeletonBox(width: 80, height: 14),
                  SizedBox(height: 8),
                  SkeletonBox(width: 40, height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
