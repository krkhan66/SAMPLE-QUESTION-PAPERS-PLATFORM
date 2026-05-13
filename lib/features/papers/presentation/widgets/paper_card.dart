import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/paper_entity.dart';

class PaperCard extends StatelessWidget {
  final PaperEntity paper;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDownload;

  const PaperCard({
    super.key,
    required this.paper,
    required this.index,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              _buildPdfIcon(context),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paper.title,
                      style: AppTextStyles.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.subject_rounded,
                          paper.subject.capitalize,
                          isDark,
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        _buildInfoChip(
                          Icons.calendar_today_rounded,
                          paper.year.toString(),
                          isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.download_rounded,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${paper.downloadCount.formatCount} downloads',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: AppDimensions.md),
                        _buildDifficultyBadge(),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      paper.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: paper.isFavorite
                          ? AppColors.secondary
                          : AppColors.textHint,
                      size: AppDimensions.iconMd,
                    ),
                  ),
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(
                      Icons.download_rounded,
                      color: AppColors.primary,
                      size: AppDimensions.iconMd,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(
            duration: AppConstants.pageTransitionDuration,
            delay: (index * 50).ms,
          ).slideX(
            begin: 0.1,
            duration: AppConstants.pageTransitionDuration,
            delay: (index * 50).ms,
          ),
    );
  }

  Widget _buildPdfIcon(BuildContext context) {
    return Container(
      width: 52,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_rounded,
            color: AppColors.secondary,
            size: AppDimensions.iconLg,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge() {
    Color badgeColor;
    switch (paper.difficulty) {
      case 'Easy':
        badgeColor = AppColors.success;
      case 'Hard':
        badgeColor = AppColors.error;
      default:
        badgeColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        paper.difficulty ?? 'Medium',
        style: AppTextStyles.labelSmall.copyWith(
          color: badgeColor,
          fontSize: 10,
        ),
      ),
    );
  }
}
