import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/app_tab.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tabs_event.dart';

class TabsBloc extends Bloc<TabsEvent, AppTab> {
  // final GlobalKey<NavigatorState> navigatorKey;
  TabsBloc() : super(AppTab.home);

  @override
  Stream<AppTab> mapEventToState(
    TabsEvent event,
  ) async* {
    if (event is TabsUpdated) {
      yield event.tab;
    }

    // if (event is NavigatorActionPop) {
    //   navigatorKey.currentState.pop();
    // }

    // if (event is NavigateToHomeEvent) {
    //   navigatorKey.currentState.pushNamed(CryptofolioRoutes.home);
    // }

    // if (event is NavigateToSearchEvent) {
    //   navigatorKey.currentState.pushNamed(CryptofolioRoutes.portfolio);
    // }

    // if (event is NavigateToPortfolioEvent) {
    //   navigatorKey.currentState.pushNamed(CryptofolioRoutes.portfolio);
    // }

    // if (event is NavigateToSettingEvent) {
    //   navigatorKey.currentState.pushNamed(CryptofolioRoutes.settings);
    // }
  }
}
