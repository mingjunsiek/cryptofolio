part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeIsLoading extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final List<Coin> coinList;

  const HomeLoadSuccess({this.coinList = const []});

  @override
  List<Object> get props => [coinList];

  @override
  String toString() => 'HomeLoadSuccess { todos: $coinList }';
}

class HomeLoadError extends HomeState {
  final String errorMessage;
  const HomeLoadError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'HomeLoadError { todos: $errorMessage }';
}
