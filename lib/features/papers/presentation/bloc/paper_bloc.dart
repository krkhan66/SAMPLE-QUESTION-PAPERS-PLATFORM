import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/paper_entity.dart';
import 'paper_event.dart';
import 'paper_state.dart';

class PaperBloc extends Bloc<PaperEvent, PaperState> {
  PaperBloc() : super(const PaperState()) {
    on<LoadPapers>(_onLoadPapers);
    on<RefreshPapers>(_onRefreshPapers);
    on<LoadMorePapers>(_onLoadMorePapers);
    on<ToggleFavorite>(_onToggleFavorite);
    on<DownloadPaper>(_onDownloadPaper);
    on<FilterPapers>(_onFilterPapers);
    on<SearchPapersEvent>(_onSearchPapers);
  }

  Future<void> _onLoadPapers(
      LoadPapers event, Emitter<PaperState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      selectedSubject: event.subject,
      selectedCategory: event.category,
      currentPage: 1,
    ));

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final papers = _generateMockPapers(
        subject: event.subject,
        category: event.category,
      );

      emit(state.copyWith(
        isLoading: false,
        papers: papers,
        hasMorePages: papers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load papers. Please try again.',
      ));
    }
  }

  Future<void> _onRefreshPapers(
      RefreshPapers event, Emitter<PaperState> emit) async {
    add(LoadPapers(
      subject: state.selectedSubject,
      category: state.selectedCategory,
    ));
  }

  Future<void> _onLoadMorePapers(
      LoadMorePapers event, Emitter<PaperState> emit) async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final morePapers = _generateMockPapers(
        subject: state.selectedSubject,
        category: state.selectedCategory,
        offset: state.papers.length,
      );

      emit(state.copyWith(
        isLoadingMore: false,
        papers: [...state.papers, ...morePapers],
        currentPage: state.currentPage + 1,
        hasMorePages: morePapers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load more papers.',
      ));
    }
  }

  void _onToggleFavorite(
      ToggleFavorite event, Emitter<PaperState> emit) {
    final updatedPapers = state.papers.map((paper) {
      if (paper.id == event.paperId) {
        return paper.copyWith(isFavorite: !paper.isFavorite);
      }
      return paper;
    }).toList();

    emit(state.copyWith(papers: updatedPapers));
  }

  Future<void> _onDownloadPaper(
      DownloadPaper event, Emitter<PaperState> emit) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Implement actual file download
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to download paper.',
      ));
    }
  }

  void _onFilterPapers(
      FilterPapers event, Emitter<PaperState> emit) {
    emit(state.copyWith(
      filterExamType: event.examType,
      filterYear: event.year,
      filterDifficulty: event.difficulty,
    ));
    add(LoadPapers(
      subject: state.selectedSubject,
      category: state.selectedCategory,
    ));
  }

  void _onSearchPapers(
      SearchPapersEvent event, Emitter<PaperState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  List<PaperEntity> _generateMockPapers({
    String? subject,
    String? category,
    int offset = 0,
  }) {
    final subjects = [
      'mathematics', 'physics', 'chemistry', 'biology',
      'english', 'history', 'geography', 'computer_science'
    ];
    final examTypes = ['Midterm', 'Final', 'Practice', 'Board'];
    final difficulties = ['Easy', 'Medium', 'Hard'];
    final papers = <PaperEntity>[];

    for (int i = 0; i < 10; i++) {
      final idx = offset + i;
      final subj = subject ?? subjects[idx % subjects.length];

      papers.add(PaperEntity(
        id: 'paper_$idx',
        title: '${subj.capitalize} ${examTypes[idx % examTypes.length]} Exam ${2024 - (idx % 5)}',
        subject: subj,
        grade: 'Grade ${(idx % 12) + 1}',
        board: 'CBSE',
        examType: examTypes[idx % examTypes.length],
        year: 2024 - (idx % 5),
        fileUrl: 'https://example.com/papers/paper_$idx.pdf',
        thumbnailUrl: null,
        description: 'Complete question paper for ${subj} ${examTypes[idx % examTypes.length]} examination.',
        difficulty: difficulties[idx % difficulties.length],
        downloadCount: (100 + idx * 23) % 5000,
        isFavorite: idx % 5 == 0,
        createdAt: DateTime.now().subtract(Duration(days: idx * 7)),
      ));
    }

    return papers;
  }
}

extension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
