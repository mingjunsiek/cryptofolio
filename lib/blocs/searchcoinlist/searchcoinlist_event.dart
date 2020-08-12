part of 'searchcoinlist_bloc.dart';

@immutable
abstract class SearchcoinlistEvent extends Equatable {
  const SearchcoinlistEvent();

  @override
  List<Object> get props => [];
}

class InitializeSearchList extends SearchcoinlistEvent {
  final BuildContext context;
  const InitializeSearchList(this.context);
}

class AddCoinToFavourites extends SearchcoinlistEvent {
  final String coinId;
  const AddCoinToFavourites(this.coinId);
}

class RemoveCoinFromFavourites extends SearchcoinlistEvent {
  final String coinId;
  const RemoveCoinFromFavourites(this.coinId);
}
