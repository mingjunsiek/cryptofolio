import 'package:cryptofolio/blocs/blocs.dart';
import 'package:cryptofolio/widgets/home/home_favourites_bloc_consumer.dart';
import 'package:cryptofolio/widgets/home/home_portfolio_bloc_consumer.dart';
import 'package:cryptofolio/widgets/home/home_top_coins_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.errorMessage}, could not retrieve data'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is HomeIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is HomeLoadSuccess) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<Top20coinsBloc>(
                create: (context) =>
                    Top20coinsBloc(state.coinList)..add(TopCoinsLoaded()),
              ),
              BlocProvider<FavouritesBloc>(
                create: (context) => FavouritesBloc()..add(FavouritesFetch()),
              ),
              BlocProvider<PortfolioBloc>(
                create: (context) =>
                    PortfolioBloc(state.coinList)..add(PortfolioFetch()),
              ),
            ],
            child: Scaffold(
              body: Container(
                margin: MediaQuery.of(context).padding,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomePortfolio(),
                      HomeFavourites(),
                      HomeTopCoins(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is HomeLoadError)
          return Center(
            child: Text(
              "Home loading error, please try again later",
            ),
          );
        return Center(child: Text('Fail All'));
      },
    );
  }
}
