import 'package:cryptofolio/blocs/blocs.dart';
import 'package:cryptofolio/blocs/search/search_bloc.dart';
import 'package:cryptofolio/blocs/tabs/tabs_bloc.dart';
import 'package:cryptofolio/models/app_tab.dart';
import 'package:cryptofolio/widgets/navigation/tab_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          body: ((activeTab) {
            if (activeTab == AppTab.search) return loadSearchScreen(context);
            if (activeTab == AppTab.portfolio)
              return loadPortfolioScreen(context);
            if (activeTab == AppTab.settings) return SettingsScreen();
            return loadHomeScreen(context);
          }(activeTab)),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabsBloc>(context).add(TabsUpdated(tab)),
          ),
        );
      },
    );
  }

  HomeScreen loadHomeScreen(BuildContext context) {
    print("Loading Home Screen");
    final homeBloc = context.bloc<HomeBloc>();
    homeBloc.add(FetchTop100Coins());

    return HomeScreen();
  }

  SearchScreen loadSearchScreen(BuildContext context) {
    print("Loading Search Screen");
    final searchBloc = context.bloc<SearchBloc>();
    searchBloc.add(SearchFetchTop100Coins());
    return SearchScreen();
  }

  PortfolioScreen loadPortfolioScreen(BuildContext context) {
    print("Loading Portfolio Screen");
    final portfolioBloc = context.bloc<PortfolioBloc>();
    portfolioBloc.add(InitializePortfolioPage());
    return PortfolioScreen();
  }
}
