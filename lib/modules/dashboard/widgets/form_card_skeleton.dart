import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_shimmer.dart';

class FormCardSkeleton extends StatelessWidget {
  const FormCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading form card',
      child: AppShimmer(
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
              Flexible(child: const SkeletonBox(width: 40, height: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final titleWidth = constraints.maxWidth * 0.75;
                    final subtitleWidth = constraints.maxWidth * 0.45;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: titleWidth, height: 16),
                        const SizedBox(height: 8),
                        SkeletonBox(width: subtitleWidth, height: 12),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: const SkeletonBox(
                    width: 80,
                    height: 24,
                    borderRadius: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
