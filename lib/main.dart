import 'package:bloc/bloc.dart';
import 'package:cryptofolio/blocs/home/home_bloc.dart';
import 'package:cryptofolio/data_provider/coin_gecko_api_client.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:cryptofolio/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/simple_bloc_observer.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = SimpleBlocObserver();
  final CoinRepository coinRepository =
      CoinRepository(CoinGeckoApiClient(http.Client()));

  runApp(
    BlocProvider<HomeBloc>(
      create: (context) {
        return HomeBloc(
          coinRepository,
        )..add(FetchTop20Coins());
      },
      child: CryotofolioApp(),
    ),
  );
}

class CryotofolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF101518),
        accentColor: Colors.cyan[300],
        buttonColor: Color(0xFFC7CDD2),
        textSelectionColor: Colors.cyan[100],
        backgroundColor: Color(0xFF101518),
        scaffoldBackgroundColor: Color(0xFF101518),
        cardTheme: CardTheme().copyWith(
          color: Color(0xFF1D2228),
        ),
        toggleableActiveColor: Colors.cyan[300],
        textTheme: ThemeData.dark().textTheme.copyWith(
            bodyText2: ThemeData.dark().textTheme.bodyText2.copyWith(
                  decorationColor: Colors.transparent,
                )),
      ),
      home: Scaffold(
        body: HomeScreen(),
      ),
      // routes: {
      //   '/': (context){
      //     return BlocProvider(create: (context) => ,)
      //   }
      // },
    );
  }
}
