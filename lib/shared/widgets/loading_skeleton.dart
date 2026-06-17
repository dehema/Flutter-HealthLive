import 'package:flutter/material.dart';
import 'package:healthlive/app/theme/app_colors.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 108,
            decoration: const BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 180,
                    color: AppColors.divider,
                  ),
                  const Spacer(),
                  Container(
                    height: 10,
                    width: 80,
                    color: AppColors.divider,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
