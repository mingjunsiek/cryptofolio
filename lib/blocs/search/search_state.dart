part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchIsLoading extends SearchState {}

class SearchLoadSuccess extends SearchState {}

class SearchLoadError extends SearchState {
  final String errorMessage;
  const SearchLoadError(this.errorMessage);

  @override
  String toString() => 'SearchLoadError { todos: $errorMessage }';
}
