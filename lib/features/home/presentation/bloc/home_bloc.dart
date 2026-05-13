import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<SearchPapers>(_onSearchPapers);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final subjects = [
        const SubjectCategory(
          id: '1',
          name: 'Mathematics',
          icon: 'calculate',
          colorHex: 'FF6C63FF',
          paperCount: 24,
        ),
        const SubjectCategory(
          id: '2',
          name: 'Physics',
          icon: 'science',
          colorHex: 'FFFF6584',
          paperCount: 18,
        ),
        const SubjectCategory(
          id: '3',
          name: 'Chemistry',
          icon: 'biotech',
          colorHex: 'FF10B981',
          paperCount: 15,
        ),
        const SubjectCategory(
          id: '4',
          name: 'Biology',
          icon: 'grass',
          colorHex: 'FFF59E0B',
          paperCount: 12,
        ),
        const SubjectCategory(
          id: '5',
          name: 'English',
          icon: 'book',
          colorHex: 'FF3B82F6',
          paperCount: 20,
        ),
        const SubjectCategory(
          id: '6',
          name: 'History',
          icon: 'history',
          colorHex: 'FF8B5CF6',
          paperCount: 10,
        ),
      ];

      final categories = [
        const PaperCategory(
          id: '1',
          name: 'Midterm Exams',
          icon: 'fact_check',
          paperCount: 45,
        ),
        const PaperCategory(
          id: '2',
          name: 'Final Exams',
          icon: 'assignment',
          paperCount: 38,
        ),
        const PaperCategory(
          id: '3',
          name: 'Practice Tests',
          icon: 'quiz',
          paperCount: 62,
        ),
        const PaperCategory(
          id: '4',
          name: 'Board Exams',
          icon: 'workspace_premium',
          paperCount: 28,
        ),
      ];

      final recentPapers = [
        const PaperCategory(
          id: '101',
          name: 'Mathematics 2024 Final',
          icon: 'description',
          paperCount: 1,
        ),
        const PaperCategory(
          id: '102',
          name: 'Physics Midterm 2024',
          icon: 'description',
          paperCount: 1,
        ),
        const PaperCategory(
          id: '103',
          name: 'Chemistry Practice Set 5',
          icon: 'description',
          paperCount: 1,
        ),
      ];

      emit(state.copyWith(
        isLoading: false,
        subjects: subjects,
        categories: categories,
        recentPapers: recentPapers,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load data. Please try again.',
      ));
    }
  }

  Future<void> _onRefreshHomeData(
      RefreshHomeData event, Emitter<HomeState> emit) async {
    add(const LoadHomeData());
  }

  void _onSearchPapers(SearchPapers event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
