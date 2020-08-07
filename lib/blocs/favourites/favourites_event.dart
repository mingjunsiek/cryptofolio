part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();

  @override
  List<Object> get props => [];
}

class FavouritesFetch extends FavouritesEvent {
  const FavouritesFetch();
}
