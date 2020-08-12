import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  Favourites favourites;
  FavouritesBloc() : super(FavouritesInProgess());

  @override
  Stream<FavouritesState> mapEventToState(
    FavouritesEvent event,
  ) async* {
    if (event is FavouritesFetch) {
      try {
        yield FavouritesInProgess();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (!prefs.containsKey("favourites"))
          yield FavouriteIsEmpty();
        else {
          favourites = Favourites(prefs.getStringList("favourites"));
          print('favourite_bloc: ${favourites.favouriteList}');
          yield FavouritesLoadSuccess(favourites);
        }
      } catch (e) {
        yield FavouritesLoadFailure(e);
      }
    }
  }
}
