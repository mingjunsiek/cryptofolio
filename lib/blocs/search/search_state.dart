part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchIsLoading extends SearchState {}

class SearchLoadSuccess extends SearchState {
  final List<Coin> coinList;

  SearchLoadSuccess({this.coinList = const []});

  @override
  String toString() => 'HomeLoadSuccess { todos: $coinList }';
}

class SearchLoadError extends SearchState {
  final String errorMessage;
  const SearchLoadError(this.errorMessage);

  @override
  String toString() => 'SearchLoadError { todos: $errorMessage }';
}
