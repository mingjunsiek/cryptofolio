part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchTop100Coins extends HomeEvent {
  const FetchTop100Coins();

  @override
  List<Object> get props => [];
}
