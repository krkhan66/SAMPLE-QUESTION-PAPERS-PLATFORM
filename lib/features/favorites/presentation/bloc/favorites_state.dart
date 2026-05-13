import 'package:equatable/equatable.dart';
import '../../../papers/domain/entities/paper_entity.dart';

class FavoritesState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<PaperEntity> favoritePapers;

  const FavoritesState({
    this.isLoading = false,
    this.errorMessage,
    this.favoritePapers = const [],
  });

  FavoritesState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<PaperEntity>? favoritePapers,
    bool clearError = false,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      favoritePapers: favoritePapers ?? this.favoritePapers,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, favoritePapers];
}
