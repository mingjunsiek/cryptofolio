part of 'searchcoinlist_bloc.dart';

@immutable
abstract class SearchcoinlistState extends Equatable {
  const SearchcoinlistState();

  @override
  List<Object> get props => [];
}

class SearchCoinListInitial extends SearchcoinlistState {}

class SearchCoinListIsLoading extends SearchcoinlistState {}

class SearchCoinListLoadSuccess extends SearchcoinlistState {
  final List<Coin> coinList;
  final Favourites favouriteList;
  SearchCoinListLoadSuccess({
    this.favouriteList,
    this.coinList = const [],
  });

  @override
  String toString() => 'HomeLoadSuccess { todos: $coinList }';
}

class SearchCoinListLoadError extends SearchcoinlistState {
  final String errorMessage;
  const SearchCoinListLoadError(this.errorMessage);

  @override
  String toString() => 'SearchLoadError { todos: $errorMessage }';
}

class SearchCoinListFavouriteAdded extends SearchcoinlistState {}

class SearchCoinListFavouriteRemoved extends SearchcoinlistState {}
