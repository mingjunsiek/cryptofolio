import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'top20coins_event.dart';
part 'top20coins_state.dart';

class Top20coinsBloc extends Bloc<Top20coinsEvent, Top20coinsState> {
  final List<Coin> coinList;

  Top20coinsBloc(this.coinList) : super(Top20coinsIsLoading());

  @override
  Stream<Top20coinsState> mapEventToState(
    Top20coinsEvent event,
  ) async* {
    if (event is TopCoinsLoaded) {
      yield Top20coinsIsLoading();
      try {
        yield Top20coinsLoadSuccess(top20CoinList: coinList);
      } catch (error) {
        yield Top20coinsLoadError(error);
      }
    }
  }
}
