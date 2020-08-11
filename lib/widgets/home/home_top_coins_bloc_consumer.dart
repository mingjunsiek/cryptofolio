import 'package:cryptofolio/blocs/top20coins/top20coins_bloc.dart';
import 'package:cryptofolio/widgets/default_text_card.dart';
import 'package:cryptofolio/widgets/home/coin_card/coin_lists.dart';
import 'package:cryptofolio/widgets/is_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTopCoins extends StatelessWidget {
  const HomeTopCoins({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Top20coinsBloc, Top20coinsState>(
      listener: (context, state) {
        if (state is Top20coinsLoadError) {
          return DefaultTextCard(
              text: "Top20coinsLoadError: Fail to load top 20 coins");
        }
      },
      builder: (context, state) {
        if (state is Top20coinsIsLoading) {
          return IsLoadingCard();
        }
        if (state is Top20coinsLoadSuccess) {
          return CoinLists(
            coinList: state.top20CoinList,
            title: "Top 20 Coins by Market Capitalization",
            buttonText: "See All",
            buttonFunction: () {
              print('Top 20 Coins Button Click');
            },
          );
        }
        return DefaultTextCard(text: "Could not fetch top coins");
      },
    );
  }
}
