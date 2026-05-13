import 'package:equatable/equatable.dart';

abstract class PaperEvent extends Equatable {
  const PaperEvent();

  @override
  List<Object?> get props => [];
}

class LoadPapers extends PaperEvent {
  final String? subject;
  final String? category;
  final int page;

  const LoadPapers({this.subject, this.category, this.page = 1});

  @override
  List<Object?> get props => [subject, category, page];
}

class RefreshPapers extends PaperEvent {
  const RefreshPapers();
}

class LoadMorePapers extends PaperEvent {
  const LoadMorePapers();
}

class ToggleFavorite extends PaperEvent {
  final String paperId;

  const ToggleFavorite({required this.paperId});

  @override
  List<Object?> get props => [paperId];
}

class DownloadPaper extends PaperEvent {
  final String paperId;
  final String fileUrl;
  final String title;

  const DownloadPaper({
    required this.paperId,
    required this.fileUrl,
    required this.title,
  });

  @override
  List<Object?> get props => [paperId, fileUrl, title];
}

class FilterPapers extends PaperEvent {
  final String? examType;
  final int? year;
  final String? difficulty;

  const FilterPapers({this.examType, this.year, this.difficulty});

  @override
  List<Object?> get props => [examType, year, difficulty];
}

class SearchPapersEvent extends PaperEvent {
  final String query;

  const SearchPapersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
