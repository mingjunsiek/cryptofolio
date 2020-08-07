part of 'top20coins_bloc.dart';

@immutable
abstract class Top20coinsState extends Equatable {
  const Top20coinsState();

  @override
  List<Object> get props => [];
}

class Top20coinsIsLoading extends Top20coinsState {}

class Top20coinsLoadSuccess extends Top20coinsState {
  final List<Coin> top20CoinList;

  const Top20coinsLoadSuccess({this.top20CoinList = const []});

  @override
  List<Object> get props => [top20CoinList];

  @override
  String toString() => 'Top20coinsLoaded { todos: $top20CoinList }';
}

class Top20coinsLoadError extends Top20coinsState {
  final String errorMessage;
  const Top20coinsLoadError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Top20coinsError { todos: $errorMessage }';
}
