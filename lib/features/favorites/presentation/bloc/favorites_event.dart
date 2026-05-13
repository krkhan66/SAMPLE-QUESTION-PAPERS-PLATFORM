import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddFavorite extends FavoritesEvent {
  final String paperId;

  const AddFavorite({required this.paperId});

  @override
  List<Object?> get props => [paperId];
}

class RemoveFavorite extends FavoritesEvent {
  final String paperId;

  const RemoveFavorite({required this.paperId});

  @override
  List<Object?> get props => [paperId];
}
