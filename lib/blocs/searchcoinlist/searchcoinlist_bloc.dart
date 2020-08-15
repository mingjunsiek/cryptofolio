import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'searchcoinlist_event.dart';
part 'searchcoinlist_state.dart';

class SearchcoinlistBloc
    extends Bloc<SearchcoinlistEvent, SearchcoinlistState> {
  List<Coin> coinList;
  Favourites favouriteList;
  SharedPreferences _prefs;
  SearchcoinlistBloc() : super(SearchCoinListIsLoading()) {
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    try {
      this._prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey("favourites"))
        favouriteList = Favourites([]);
      else {
        favouriteList = Favourites(_prefs.getStringList("favourites"));
      }
    } catch (e) {
      print("Error in SearchCoinListBloc: getSharedPreferences");
    }
  }

  @override
  Stream<SearchcoinlistState> mapEventToState(
    SearchcoinlistEvent event,
  ) async* {
    if (event is InitializeSearchList) {
      yield SearchCoinListIsLoading();
      final coinRepo = event.context.repository<CoinRepository>();
      this.coinList = coinRepo.coinList;

      yield SearchCoinListLoadSuccess(
        coinList: coinList,
        favouriteList: favouriteList,
      );
    }

    if (event is AddCoinToFavourites) {
      // yield SearchCoinListFavouriteAdded();
      print('Before: ${favouriteList.favouriteList}');
      favouriteList.favouriteList.add(event.coinId);
      print(favouriteList.favouriteList);
      await _prefs.setStringList("favourites", favouriteList.favouriteList);
    }

    if (event is RemoveCoinFromFavourites) {
      // yield SearchCoinListFavouriteRemoved();
      favouriteList.favouriteList.remove(event.coinId);
      print(favouriteList.favouriteList);
      if (favouriteList.favouriteList.isEmpty)
        await _prefs.remove("favourites");
      else
        await _prefs.setStringList("favourites", favouriteList.favouriteList);
    }
  }
}
