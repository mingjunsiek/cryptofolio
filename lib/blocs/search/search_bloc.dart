import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<Coin> coinList;
  SearchBloc() : super(SearchIsLoading());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchFetchTop100Coins) {
      yield SearchIsLoading();
      try {
        coinList = event.coinRepository.coinList;
        print("Finish loading coinlist");
        yield SearchLoadSuccess(coinList: coinList);
      } catch (_) {
        yield SearchLoadError("Error");
      }
    }
  }
}
