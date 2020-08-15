import 'package:cryptofolio/blocs/searchcoinlist/searchcoinlist_bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'default_text_card.dart';
import 'home/coin_card/current_price.dart';
import 'home/coin_card/twenty_four_percentage.dart';

class SearchCoinList extends StatelessWidget {
  final filter;
  const SearchCoinList({
    Key key,
    this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchcoinlistBloc, SearchcoinlistState>(
      listener: (context, state) {
        if (state is SearchCoinListLoadError) {
          return DefaultTextCard(
              text: "FavouritesLoadFailure: Fail to load favourites");
        }
      },
      builder: (context, state) {
        if (state is SearchCoinListInitial) {
          return Center();
        }
        if (state is SearchCoinListIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SearchCoinListLoadSuccess) {
          List<Coin> coinList = context.repository<CoinRepository>().coinList;
          return ListView.builder(
            itemCount: coinList.length,
            itemBuilder: (context, index) {
              final currentCoin = coinList[index];
              return (this.filter == null || this.filter == "")
                  ? SearchCoinCard(
                      index: index,
                      currentCoin: currentCoin,
                      favourites: state.favouriteList,
                    )
                  : currentCoin.name
                              .toLowerCase()
                              .contains(this.filter.toLowerCase()) ||
                          currentCoin.symbol
                              .toLowerCase()
                              .contains(this.filter.toLowerCase())
                      ? SearchCoinCard(
                          index: index,
                          currentCoin: currentCoin,
                          favourites: state.favouriteList,
                        )
                      : Container();
            },
          );
        }
        return DefaultTextCard(text: "Could not fetch coin list");
      },
    );
  }
}

class SearchCoinCard extends StatefulWidget {
  const SearchCoinCard({
    Key key,
    @required this.currentCoin,
    @required this.index,
    @required this.favourites,
  }) : super(key: key);

  final Coin currentCoin;
  final index;
  final Favourites favourites;

  @override
  _SearchCoinCardState createState() => _SearchCoinCardState();
}

class _SearchCoinCardState extends State<SearchCoinCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 25,
                child: Text(
                  (widget.index + 1).toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 25,
                child: Image.network(
                  widget.currentCoin.image.replaceAll("large", "small"),
                  alignment: Alignment.center,
                  scale: 1.7,
                ),
              ),
              Container(
                width: 70,
                child: Text(
                  widget.currentCoin.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 40,
                child: TwentyFourPercentage(
                  percentage: widget.currentCoin.price_change_percentage_24h,
                ),
              ),
              Container(
                width: 65,
                child: CurrentPrice(
                  currentPrice: widget.currentCoin.current_price,
                ),
              ),
              if (widget.favourites.favouriteList
                  .contains(widget.currentCoin.id))
                Container(
                  width: 40,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Color(0xFF8BAB0D),
                    ),
                    onPressed: () {
                      setState(() {
                        final searchBloc = context.bloc<SearchcoinlistBloc>();
                        searchBloc.add(
                            RemoveCoinFromFavourites(widget.currentCoin.id));
                      });
                    },
                  ),
                ),
              if (!widget.favourites.favouriteList
                  .contains(widget.currentCoin.id))
                Container(
                  width: 40,
                  child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Color(0xFF98A2A8),
                      ),
                      onPressed: () {
                        setState(() {
                          final searchBloc = context.bloc<SearchcoinlistBloc>();
                          searchBloc
                              .add(AddCoinToFavourites(widget.currentCoin.id));
                        });
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
