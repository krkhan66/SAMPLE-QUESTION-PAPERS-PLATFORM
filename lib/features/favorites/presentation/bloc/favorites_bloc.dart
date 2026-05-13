import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../papers/domain/entities/paper_entity.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final favorites = <PaperEntity>[
        PaperEntity(
          id: 'fav_1',
          title: 'Mathematics Final Exam 2024',
          subject: 'mathematics',
          grade: 'Grade 10',
          board: 'CBSE',
          examType: 'Final',
          year: 2024,
          fileUrl: 'https://example.com/papers/math_final_2024.pdf',
          description: 'Complete final exam paper for Mathematics.',
          difficulty: 'Hard',
          downloadCount: 2341,
          isFavorite: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        PaperEntity(
          id: 'fav_2',
          title: 'Physics Midterm 2024',
          subject: 'physics',
          grade: 'Grade 11',
          board: 'CBSE',
          examType: 'Midterm',
          year: 2024,
          fileUrl: 'https://example.com/papers/physics_mid_2024.pdf',
          description: 'Midterm examination paper for Physics.',
          difficulty: 'Medium',
          downloadCount: 1823,
          isFavorite: true,
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
        ),
      ];

      emit(state.copyWith(
        isLoading: false,
        favoritePapers: favorites,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load favorites.',
      ));
    }
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoritesState> emit) {
    final existing = state.favoritePapers.any((p) => p.id == event.paperId);
    if (!existing) {
      emit(state.copyWith(
        favoritePapers: [
          ...state.favoritePapers,
          PaperEntity(
            id: event.paperId,
            title: 'Paper',
            subject: 'unknown',
            examType: 'Unknown',
            year: DateTime.now().year,
            fileUrl: '',
            isFavorite: true,
            createdAt: DateTime.now(),
          ),
        ],
      ));
    }
  }

  void _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoritesState> emit) {
    emit(state.copyWith(
      favoritePapers:
          state.favoritePapers.where((p) => p.id != event.paperId).toList(),
    ));
  }
}
