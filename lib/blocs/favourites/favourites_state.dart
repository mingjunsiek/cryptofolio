part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class FavouriteIsEmpty extends FavouritesState {}

class FavouritesInProgess extends FavouritesState {}

class FavouritesLoadSuccess extends FavouritesState {
  final Favourites favourites;

  const FavouritesLoadSuccess([this.favourites = const Favourites([])]);

  @override
  List<Object> get props => [favourites];

  @override
  String toString() => 'FavouritesLoadSuccess { todos: $favourites }';
}

class FavouritesLoadFailure extends FavouritesState {
  final String errorMessage;
  const FavouritesLoadFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'FavouritesLoadFailure { todos: $errorMessage }';
}
