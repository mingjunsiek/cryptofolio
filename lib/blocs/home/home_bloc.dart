import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CoinRepository coinRepository;
  List<Coin> coinList;
  HomeBloc(this.coinRepository) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is FetchTop100Coins) {
      yield HomeIsLoading();
      try {
        coinList = await coinRepository.fetchTop100Coins();
        print("Finish loading coinlist");
        yield HomeLoadSuccess(coinList: coinList);
      } catch (e) {
        yield HomeLoadError("Home Load Error");
      }
    }
  }
}
