import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_display.dart';
import '../../domain/entities/paper_entity.dart';
import '../bloc/paper_bloc.dart';
import '../bloc/paper_event.dart';
import '../bloc/paper_state.dart';

class PaperDetailPage extends StatelessWidget {
  final String paperId;

  const PaperDetailPage({super.key, required this.paperId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PaperBloc, PaperState>(
        builder: (context, state) {
          final paper = state.papers.where((p) => p.id == paperId).firstOrNull;

          if (paper == null) {
            return const ErrorDisplay(
              message: 'Paper not found',
              icon: Icons.search_off_rounded,
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              paper.title,
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            Row(
                              children: [
                                _buildMeta(
                                  Icons.subject_rounded,
                                  paper.subject.capitalize,
                                ),
                                const SizedBox(width: AppDimensions.md),
                                _buildMeta(
                                  Icons.calendar_today_rounded,
                                  paper.year.toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(context, paper),
                      const SizedBox(height: AppDimensions.lg),
                      _buildDescription(paper),
                      const SizedBox(height: AppDimensions.lg),
                      _buildActions(context, paper),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, PaperEntity paper) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.school_rounded,
            'Board',
            paper.board ?? 'Not specified',
          ),
          const Divider(),
          _buildInfoRow(
            Icons.grade_rounded,
            'Grade',
            paper.grade ?? 'Not specified',
          ),
          const Divider(),
          _buildInfoRow(
            Icons.quiz_rounded,
            'Exam Type',
            paper.examType,
          ),
          const Divider(),
          _buildInfoRow(
            Icons.bar_chart_rounded,
            'Difficulty',
            paper.difficulty ?? 'Medium',
          ),
          const Divider(),
          _buildInfoRow(
            Icons.download_rounded,
            'Downloads',
            paper.downloadCount.formatCount,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(PaperEntity paper) {
    if (paper.description == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          paper.description!,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, PaperEntity paper) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.showSnackBar('Opening PDF...');
            },
            icon: const Icon(Icons.visibility_rounded),
            label: const Text('View Paper'),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<PaperBloc>().add(
                    DownloadPaper(
                      paperId: paper.id,
                      fileUrl: paper.fileUrl,
                      title: paper.title,
                    ),
                  );
              context.showSnackBar('Download started');
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download'),
          ),
        ),
      ],
    );
  }
}
