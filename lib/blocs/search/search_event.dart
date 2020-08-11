part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchFetchTop100Coins extends SearchEvent {
  final CoinRepository coinRepository;
  const SearchFetchTop100Coins(this.coinRepository);

  @override
  List<Object> get props => [];
}
