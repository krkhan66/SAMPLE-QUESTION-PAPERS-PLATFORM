import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppDimensions.radiusSm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor:
          isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlightLight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading(
              height: 160,
              borderRadius: AppDimensions.radiusMd,
            ),
            const SizedBox(height: AppDimensions.md),
            ShimmerLoading(
              width: 200,
              height: 20,
            ),
            const SizedBox(height: AppDimensions.sm),
            ShimmerLoading(
              width: 140,
              height: 14,
            ),
            const SizedBox(height: AppDimensions.sm),
            ShimmerLoading(
              width: 100,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  final int itemCount;

  const ShimmerGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppDimensions.md,
        mainAxisSpacing: AppDimensions.md,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => ShimmerCard(),
    );
  }
}
