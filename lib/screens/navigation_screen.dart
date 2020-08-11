import 'package:cryptofolio/blocs/tabs/tabs_bloc.dart';
import 'package:cryptofolio/models/app_tab.dart';
import 'package:cryptofolio/widgets/tab_selector.dart';
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
            if (activeTab == AppTab.search) return SearchScreen();
            if (activeTab == AppTab.portfolio) return PortfolioScreen();
            if (activeTab == AppTab.settings) return SettingsScreen();
            return HomeScreen();
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
}
