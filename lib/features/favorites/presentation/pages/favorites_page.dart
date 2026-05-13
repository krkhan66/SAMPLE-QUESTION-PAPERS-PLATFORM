import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/error_display.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../papers/presentation/widgets/paper_card.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(const LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.md,
                AppDimensions.lg,
                AppDimensions.md,
                AppDimensions.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorites',
                    style: AppTextStyles.displaySmall,
                  ),
                  SizedBox(height: AppDimensions.xs),
                  Text(
                    'Your saved question papers',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return ListView.builder(
                      itemCount: 4,
                      padding:
                          const EdgeInsets.only(top: AppDimensions.sm),
                      itemBuilder: (context, index) =>
                          const ShimmerCard(),
                    );
                  }
                  if (state.errorMessage != null &&
                      state.favoritePapers.isEmpty) {
                    return ErrorDisplay(
                      message: state.errorMessage!,
                      actionLabel: 'Retry',
                      onAction: () => context
                          .read<FavoritesBloc>()
                          .add(const LoadFavorites()),
                    );
                  }
                  if (state.favoritePapers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.secondary
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                size: 40,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.lg),
                            Text(
                              'No favorites yet',
                              style: AppTextStyles.headlineMedium,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            Text(
                              'Start adding papers to your favorites\nby tapping the heart icon',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimensions.lg),
                            ElevatedButton(
                              onPressed: () => context.pushNamed('papers'),
                              child: const Text('Browse Papers'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<FavoritesBloc>()
                          .add(const LoadFavorites());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.sm,
                        bottom: AppDimensions.lg,
                      ),
                      itemCount: state.favoritePapers.length,
                      itemBuilder: (context, index) {
                        final paper = state.favoritePapers[index];
                        return PaperCard(
                          paper: paper,
                          index: index,
                          onTap: () => context.pushNamed(
                            'paperDetail',
                            queryParameters: {'id': paper.id},
                          ),
                          onToggleFavorite: () {
                            context.read<FavoritesBloc>().add(
                                  RemoveFavorite(paperId: paper.id),
                                );
                            context.showSnackBar(
                                'Removed from favorites');
                          },
                          onDownload: () {
                            context.showSnackBar('Download started');
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
