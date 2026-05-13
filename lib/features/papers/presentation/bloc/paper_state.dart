import 'package:equatable/equatable.dart';
import '../../domain/entities/paper_entity.dart';

class PaperState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final List<PaperEntity> papers;
  final int currentPage;
  final bool hasMorePages;
  final String? selectedSubject;
  final String? selectedCategory;
  final String? filterExamType;
  final int? filterYear;
  final String? filterDifficulty;
  final String searchQuery;

  const PaperState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.papers = const [],
    this.currentPage = 1,
    this.hasMorePages = true,
    this.selectedSubject,
    this.selectedCategory,
    this.filterExamType,
    this.filterYear,
    this.filterDifficulty,
    this.searchQuery = '',
  });

  PaperState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    List<PaperEntity>? papers,
    int? currentPage,
    bool? hasMorePages,
    String? selectedSubject,
    String? selectedCategory,
    String? filterExamType,
    int? filterYear,
    String? filterDifficulty,
    String? searchQuery,
    bool clearError = false,
    bool clearFilters = false,
  }) {
    return PaperState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError
          ? null
          : (errorMessage ?? this.errorMessage),
      papers: papers ?? this.papers,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      filterExamType: clearFilters
          ? null
          : (filterExamType ?? this.filterExamType),
      filterYear: clearFilters ? null : (filterYear ?? this.filterYear),
      filterDifficulty: clearFilters
          ? null
          : (filterDifficulty ?? this.filterDifficulty),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        errorMessage,
        papers,
        currentPage,
        hasMorePages,
        selectedSubject,
        selectedCategory,
        filterExamType,
        filterYear,
        filterDifficulty,
        searchQuery,
      ];
}
