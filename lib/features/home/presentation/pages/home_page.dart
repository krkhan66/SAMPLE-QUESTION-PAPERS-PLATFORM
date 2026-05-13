import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/category_card.dart';
import '../widgets/subject_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const RefreshHomeData());
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.isLoading && state.subjects.isEmpty) {
                return _buildLoadingState();
              }
              if (state.errorMessage != null && state.subjects.isEmpty) {
                return ErrorDisplay(
                  message: state.errorMessage!,
                  actionLabel: 'Retry',
                  onAction: () =>
                      context.read<HomeBloc>().add(const LoadHomeData()),
                );
              }
              return _buildContent(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.md),
      children: [
        const SizedBox(height: AppDimensions.lg),
        ShimmerLoading(width: 200, height: 28),
        const SizedBox(height: AppDimensions.sm),
        ShimmerLoading(width: 160, height: 16),
        const SizedBox(height: AppDimensions.lg),
        ShimmerLoading(height: 48, borderRadius: AppDimensions.radiusMd),
        const SizedBox(height: AppDimensions.xl),
        ShimmerLoading(width: 120, height: 18),
        const SizedBox(height: AppDimensions.md),
        ShimmerGrid(itemCount: 4),
        const SizedBox(height: AppDimensions.lg),
        ShimmerLoading(width: 120, height: 18),
        const SizedBox(height: AppDimensions.md),
        ShimmerGrid(itemCount: 4),
      ],
    );
  }

  Widget _buildContent(HomeState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(state)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.md,
              AppDimensions.md,
              AppDimensions.md,
              AppDimensions.sm,
            ),
            child: _buildSearchBar(),
          ),
        ),
        if (state.searchQuery.isEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader('Subjects', Icons.book_rounded),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: AppDimensions.sm,
                mainAxisSpacing: AppDimensions.sm,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final subject = state.subjects[index];
                  return SubjectCard(
                    name: subject.name,
                    icon: _getSubjectIcon(subject.icon),
                    paperCount: subject.paperCount.toString(),
                    color: Color(
                      int.parse('0x${subject.colorHex}'),
                    ),
                    onTap: () => context.pushNamed(
                      'papers',
                      queryParameters: {'subject': subject.name.toLowerCase()},
                    ),
                  ).animate().fadeIn(
                        duration: AppConstants.pageTransitionDuration,
                        delay: (index * 50).ms,
                      );
                },
                childCount: state.subjects.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Categories', Icons.category_rounded),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: AppDimensions.sm,
                mainAxisSpacing: AppDimensions.sm,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = state.categories[index];
                  return CategoryCard(
                    title: category.name,
                    icon: _getCategoryIcon(category.icon),
                    count: category.paperCount.toString(),
                    color: AppColors.subjectColors[
                        index % AppColors.subjectColors.length],
                    onTap: () => context.pushNamed(
                      'papers',
                      queryParameters: {
                        'category': category.name.toLowerCase().replaceAll(' ', '_')
                      },
                    ),
                  ).animate().fadeIn(
                        duration: AppConstants.pageTransitionDuration,
                        delay: (index * 50).ms,
                      );
                },
                childCount: state.categories.length,
              ),
            ),
          ),
          if (state.recentPapers.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                  'Recent Papers', Icons.history_rounded),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppDimensions.md,
                bottom: AppDimensions.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recentPapers.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      final paper = state.recentPapers[index];
                      return _buildRecentPaperCard(paper);
                    },
                  ),
                ),
              ),
            ),
          ],
        ] else ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              'Results for "${state.searchQuery}"',
              Icons.search_rounded,
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(
                'Search results will appear here',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.bottomNavHeight + AppDimensions.lg),
        ),
      ],
    );
  }

  Widget _buildHeader(HomeState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Student',
                    style: AppTextStyles.displaySmall,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    'Practice with sample papers',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.pushNamed('login'),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: AppDimensions.iconMd,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        context.read<HomeBloc>().add(SearchPapers(query: value));
      },
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Search papers by subject, topic...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textHint,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear_rounded,
                  color: AppColors.textHint,
                ),
                onPressed: () {
                  _searchController.clear();
                  context
                      .read<HomeBloc>()
                      .add(const SearchPapers(query: ''));
                },
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          Text(
            title,
            style: AppTextStyles.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPaperCard(PaperCategory paper) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.picture_as_pdf_rounded, color: AppColors.secondary),
          const Spacer(),
          Text(
            paper.name,
            style: AppTextStyles.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String icon) {
    switch (icon) {
      case 'calculate':
        return Icons.calculate_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'biotech':
        return Icons.biotech_rounded;
      case 'grass':
        return Icons.grass_rounded;
      case 'book':
        return Icons.book_rounded;
      case 'history':
        return Icons.history_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  IconData _getCategoryIcon(String icon) {
    switch (icon) {
      case 'fact_check':
        return Icons.fact_check_rounded;
      case 'assignment':
        return Icons.assignment_rounded;
      case 'quiz':
        return Icons.quiz_rounded;
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.folder_rounded;
    }
  }
}
