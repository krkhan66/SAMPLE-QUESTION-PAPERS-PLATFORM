import 'package:equatable/equatable.dart';

class SubjectCategory {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final int paperCount;

  const SubjectCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.paperCount,
  });
}

class PaperCategory {
  final String id;
  final String name;
  final String icon;
  final int paperCount;

  const PaperCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.paperCount,
  });
}

class HomeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<SubjectCategory> subjects;
  final List<PaperCategory> categories;
  final List<PaperCategory> recentPapers;
  final String searchQuery;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.subjects = const [],
    this.categories = const [],
    this.recentPapers = const [],
    this.searchQuery = '',
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<SubjectCategory>? subjects,
    List<PaperCategory>? categories,
    List<PaperCategory>? recentPapers,
    String? searchQuery,
    bool clearError = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      subjects: subjects ?? this.subjects,
      categories: categories ?? this.categories,
      recentPapers: recentPapers ?? this.recentPapers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, subjects, categories, recentPapers, searchQuery];
}
