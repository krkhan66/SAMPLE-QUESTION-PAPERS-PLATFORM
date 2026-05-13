import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../bloc/paper_bloc.dart';
import '../bloc/paper_event.dart';
import '../bloc/paper_state.dart';
import '../widgets/paper_card.dart';

class PaperListPage extends StatefulWidget {
  final String? subject;
  final String? category;

  const PaperListPage({super.key, this.subject, this.category});

  @override
  State<PaperListPage> createState() => _PaperListPageState();
}

class _PaperListPageState extends State<PaperListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PaperBloc>().add(
          LoadPapers(
            subject: widget.subject,
            category: widget.category,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PaperBloc>().add(const LoadMorePapers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject?.capitalize ?? widget.category?.replaceAll('_', ' ').capitalize ?? 'All Papers',
        ),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: BlocBuilder<PaperBloc, PaperState>(
        builder: (context, state) {
          if (state.isLoading) {
            return ListView.builder(
              itemCount: 6,
              padding: const EdgeInsets.only(top: AppDimensions.sm),
              itemBuilder: (context, index) => const ShimmerCard(),
            );
          }
          if (state.errorMessage != null && state.papers.isEmpty) {
            return ErrorDisplay(
              message: state.errorMessage!,
              actionLabel: 'Retry',
              onAction: () => context.read<PaperBloc>().add(
                    LoadPapers(
                      subject: widget.subject,
                      category: widget.category,
                    ),
                  ),
            );
          }
          if (state.papers.isEmpty) {
            return const EmptyDisplay(
              message: 'No papers found',
              icon: Icons.description_rounded,
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PaperBloc>().add(const RefreshPapers());
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.papers.length + (state.isLoadingMore ? 1 : 0),
              padding: const EdgeInsets.only(
                top: AppDimensions.sm,
                bottom: AppDimensions.lg,
              ),
              itemBuilder: (context, index) {
                if (index == state.papers.length) {
                  return const Padding(
                    padding: EdgeInsets.all(AppDimensions.md),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final paper = state.papers[index];
                return PaperCard(
                  paper: paper,
                  index: index,
                  onTap: () => context.pushNamed(
                    'paperDetail',
                    queryParameters: {'id': paper.id},
                  ),
                  onToggleFavorite: () {
                    context
                        .read<PaperBloc>()
                        .add(ToggleFavorite(paperId: paper.id));
                    context.showSnackBar(
                      paper.isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                    );
                  },
                  onDownload: () {
                    context.read<PaperBloc>().add(
                          DownloadPaper(
                            paperId: paper.id,
                            fileUrl: paper.fileUrl,
                            title: paper.title,
                          ),
                        );
                    context.showSnackBar('Download started');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Papers',
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.lg),
              Text('Exam Type', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppDimensions.sm),
              Wrap(
                spacing: AppDimensions.sm,
                children: ['Midterm', 'Final', 'Practice', 'Board']
                    .map((type) => FilterChip(
                          label: Text(type),
                          selected: false,
                          onSelected: (selected) {
                            context.read<PaperBloc>().add(
                                  FilterPapers(examType: type),
                                );
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppDimensions.md),
              Text('Difficulty', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppDimensions.sm),
              Wrap(
                spacing: AppDimensions.sm,
                children: ['Easy', 'Medium', 'Hard']
                    .map((level) => FilterChip(
                          label: Text(level),
                          selected: false,
                          onSelected: (selected) {
                            context.read<PaperBloc>().add(
                                  FilterPapers(difficulty: level),
                                );
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppDimensions.lg),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context
                        .read<PaperBloc>()
                        .add(const FilterPapers());
                    Navigator.pop(context);
                  },
                  child: const Text('Clear Filters'),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
            ],
          ),
        );
      },
    );
  }
}
