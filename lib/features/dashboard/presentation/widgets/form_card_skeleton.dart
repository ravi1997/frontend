import 'package:flutter/material.dart';
import '../../../../core/widgets/app_shimmer.dart';

class FormCardSkeleton extends StatelessWidget {
  const FormCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            const SkeletonBox(width: 40, height: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 200, height: 16),
                  SizedBox(height: 8),
                  SkeletonBox(width: 120, height: 12),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const SkeletonBox(width: 80, height: 24, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
