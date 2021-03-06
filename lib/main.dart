import 'package:bloc/bloc.dart';
import 'package:cryptofolio/blocs/home/home_bloc.dart';
import 'package:cryptofolio/blocs/search/search_bloc.dart';
import 'package:cryptofolio/data_provider/coin_gecko_api_client.dart';
import 'package:cryptofolio/models/routes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:cryptofolio/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/simple_bloc_observer.dart';
import 'package:http/http.dart' as http;

import 'blocs/portfolio/portfolio_bloc.dart';
import 'blocs/tabs/tabs_bloc.dart';
import 'screens/screens.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(RepositoryProvider(
      create: (context) => CoinRepository(
            CoinGeckoApiClient(http.Client()),
          ),
      child: CryotofolioApp()));
}

class CryotofolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptofolio',
      theme: ThemeData(
        timePickerTheme: ThemeData.dark().timePickerTheme,
        dialogTheme: ThemeData.dark().dialogTheme,
        primaryColor: Color(0xFF101518),
        accentColor: Colors.cyan[300],
        buttonColor: Color(0xFFC7CDD2),
        textSelectionColor: Colors.cyan[100],
        backgroundColor: Color(0xFF101518),
        scaffoldBackgroundColor: Color(0xFF101518),
        bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xFFFC440F),
          unselectedItemColor: Color(0xFFC7CDD2),
        ),
        cardTheme: CardTheme().copyWith(
          color: Color(0xFF1D2228),
        ),
        toggleableActiveColor: Colors.cyan[300],
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText2: ThemeData.dark().textTheme.bodyText2.copyWith(
                    decorationColor: Colors.transparent,
                  ),
            ),
      ),
      routes: {
        CryptofolioRoutes.home: (context) {
          final CoinRepository coinRepository =
              context.repository<CoinRepository>();

          return MultiBlocProvider(
            providers: [
              BlocProvider<TabsBloc>(
                create: (context) => TabsBloc(),
              ),
              BlocProvider<HomeBloc>(
                create: (context) => HomeBloc(coinRepository),
              ),
              BlocProvider<SearchBloc>(
                create: (context) => SearchBloc(),
              ),
              BlocProvider<PortfolioBloc>(
                create: (context) => PortfolioBloc(coinRepository.coinList)
                  ..add(PortfolioFetch()),
              ),
            ],
            child: NavigationScreen(),
          );
        },
        CryptofolioRoutes.search: (context) {
          return SearchScreen();
        },
        CryptofolioRoutes.portfolio: (context) {
          return PortfolioScreen();
        },
        CryptofolioRoutes.settings: (context) {
          return SettingsScreen();
        },
      },
    );
  }
}
