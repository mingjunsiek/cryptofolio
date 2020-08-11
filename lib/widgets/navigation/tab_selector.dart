import 'package:cryptofolio/models/app_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: AppTabKeys.tabs,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            key: AppTabKeys.hometab,
          ),
          title: Text("Home"),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            key: AppTabKeys.searchtab,
          ),
          title: Text("Search"),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.format_list_bulleted,
            key: AppTabKeys.portfoliotab,
          ),
          title: Text("Portfolio"),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            key: AppTabKeys.settingstab,
          ),
          title: Text("Settings"),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        ),
      ],
    );
  }
}
