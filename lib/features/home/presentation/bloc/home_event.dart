import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

class SearchPapers extends HomeEvent {
  final String query;

  const SearchPapers({required this.query});

  @override
  List<Object?> get props => [query];
}
