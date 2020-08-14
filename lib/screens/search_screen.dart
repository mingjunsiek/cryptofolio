import 'package:cryptofolio/blocs/search/search_bloc.dart';
import 'package:cryptofolio/blocs/searchcoinlist/searchcoinlist_bloc.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:cryptofolio/widgets/search_coin_list_bloc_consumer.dart';
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
          return BlocProvider(
            create: (context) =>
                SearchcoinlistBloc()..add(InitializeSearchList(context)),
            child: Scaffold(
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
                        SearchBar(searchController: searchController),
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
                              child: Text(
                                  "Top 100 Coins by Market Capitalization")),
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
                              child: SearchCoinList(
                                filter: filter,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.searchController,
  }) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.headline1.color,
          ),
          labelText: 'Search CryptoFolio',
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
          isDense: true,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.headline1.color,
          ),
        ),
        controller: searchController,
      ),
    );
  }
}
