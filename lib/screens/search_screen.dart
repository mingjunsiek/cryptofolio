import 'package:cryptofolio/blocs/blocs.dart';
import 'package:cryptofolio/blocs/search/search_bloc.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/widgets/home/coin_card/current_price.dart';
import 'package:cryptofolio/widgets/home/coin_card/title_with_button_bar.dart';
import 'package:cryptofolio/widgets/home/coin_card/twenty_four_percentage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchLoadError)
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.errorMessage}, could not retrieve data'),
            ),
          );
      },
      builder: (context, state) {
        if (state is SearchIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SearchLoadSuccess) {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: MediaQuery.of(context).padding,
              child: Container(
                width: displayWidth(context) * 0.95,
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                            labelText: 'Search CryptoFolio',
                            filled: true,
                            fillColor: Theme.of(context).cardTheme.color,
                            isDense: true,
                            labelStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                          controller: searchController,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:
                                Text("Top 100 Coins by Market Capitalization")),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: (displayHeight(context) -
                                  MediaQuery.of(context).padding.top -
                                  kToolbarHeight) *
                              0.70,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              itemCount: state.coinList.length,
                              itemBuilder: (context, index) {
                                final currentCoin = state.coinList[index];
                                return (filter == null || filter == "")
                                    ? SearchCoinCard(
                                        index: index, currentCoin: currentCoin)
                                    : currentCoin.name.toLowerCase().contains(
                                                filter.toLowerCase()) ||
                                            currentCoin.symbol
                                                .toLowerCase()
                                                .contains(filter.toLowerCase())
                                        ? SearchCoinCard(
                                            index: index,
                                            currentCoin: currentCoin)
                                        : Container();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is SearchLoadError) {
          return Center(
            child: Text(
              "Search loading error, please try again later",
            ),
          );
        }
        return Center(child: Text('Fail All'));
      },
    );
  }
}

class SearchCoinCard extends StatelessWidget {
  const SearchCoinCard({
    Key key,
    @required this.currentCoin,
    @required this.index,
  }) : super(key: key);

  final Coin currentCoin;
  final index;

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
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 30,
                child: Text(
                  (index + 1).toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Image.network(
                  currentCoin.image.replaceAll("large", "small"),
                  alignment: Alignment.center,
                  scale: 1.7,
                ),
              ),
              Container(
                width: 65,
                child: Text(
                  currentCoin.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TwentyFourPercentage(
                percentage: currentCoin.price_change_percentage_24h,
              ),
              CurrentPrice(
                currentPrice: currentCoin.current_price,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
