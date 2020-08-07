part of 'top20coins_bloc.dart';

@immutable
abstract class Top20coinsEvent extends Equatable {
  const Top20coinsEvent();

  @override
  List<Object> get props => [];
}

class TopCoinsLoaded extends Top20coinsEvent {
  const TopCoinsLoaded();

  @override
  List<Object> get props => [];
}
