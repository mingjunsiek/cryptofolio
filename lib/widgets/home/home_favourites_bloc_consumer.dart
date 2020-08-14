import 'package:cryptofolio/blocs/favourites/favourites_bloc.dart';
import 'package:cryptofolio/blocs/tabs/tabs_bloc.dart';
import 'package:cryptofolio/models/app_tab.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:cryptofolio/widgets/home/coin_card/coin_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../default_text_card.dart';
import '../is_loading_card.dart';

class HomeFavourites extends StatelessWidget {
  final Favourites favourites;
  const HomeFavourites({Key key, this.favourites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavouritesBloc, FavouritesState>(
      listener: (context, state) {
        if (state is FavouritesLoadFailure) {
          return DefaultTextCard(
              text: "FavouritesLoadFailure: Fail to load favourites");
        }
      },
      builder: (context, state) {
        if (state is FavouritesInProgess) {
          return IsLoadingCard();
        }
        if (state is FavouritesLoadSuccess) {
          final top20Bloc = context.repository<CoinRepository>();
          return CoinLists(
            coinList: top20Bloc.coinList,
            favourites: state.favourites,
            title: "Favourite List",
            buttonText: "See All",
            buttonFunction: () {
              BlocProvider.of<TabsBloc>(context)
                  .add(TabsUpdated(AppTab.search));
            },
          );
        }
        if (state is FavouriteIsEmpty) {
          return Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: DefaultTextCard(text: "Favourite is empty"));
        }

        return Container(
            margin: EdgeInsets.only(
              top: 30,
            ),
            child: DefaultTextCard(text: "Could not fetch favourites"));
        // return IsLoadingCard();
      },
    );
  }
}
