import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/blocs/blocs.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final List<Coin> coinList;
  List<Coin> portfolioCoinsList;
  double portfolioTotalSpent = 0.0;
  double portfolioValue = 0.0;
  double portfolioDaysGain = 0.0;
  double portfolioDaysGainPercentage = 0.0;
  double portfolioTotalGain = 0.0;
  double portfolioTotalGainPercentage = 0.0;
  // DateTime currentDateTime = DateTime.now();

  PortfolioBloc(this.coinList) : super(PortfolioInitial());

  @override
  Stream<PortfolioState> mapEventToState(
    PortfolioEvent event,
  ) async* {
    if (event is PortfolioFetch) {
      yield PortfolioInProgress();

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<PortfolioItem> tempItems = [
          PortfolioItem("bitcoin", 0.3, 3553.8, DateTime(2020, 1, 20)),
          PortfolioItem("bitcoin", 0.1, 1125.8, DateTime(2020, 2, 3)),
          PortfolioItem("ethereum", 2, 745.1, DateTime(2020, 1, 20)),
        ];
        String jsonTags = jsonEncode(tempItems);
        print('After Encode: $jsonTags');
        final List<dynamic> decodedItems = jsonDecode(jsonTags);
        List<PortfolioItem> portfolioItems =
            decodedItems.map((item) => PortfolioItem.fromJson(item)).toList();
        print('After Decode: $portfolioItems');
        portfolioCoinsList = coinList.where((coin) {
          final result = portfolioItems.where((portfolioCoin) {
            if (portfolioCoin.coindId == coin.id) {
              this.portfolioValue +=
                  portfolioCoin.coinAmount * coin.current_price;
              this.portfolioTotalSpent += portfolioCoin.price;
              return true;
            }
            return false;
          });
          print('Results: $result');
          if (result != null)
            return true;
          else
            return false;
        }).toList();
        print('portfolioTotalSpent: $portfolioTotalSpent');
        print('portfolioValue: $portfolioValue');

        this.portfolioTotalGain =
            this.portfolioValue - this.portfolioTotalSpent;
        this.portfolioTotalGainPercentage =
            ((this.portfolioValue / this.portfolioTotalSpent) * 100) - 100;

        yield PortfolioIsUnhidden(
          portfolioValue,
          portfolioTotalSpent,
          portfolioTotalGain,
          portfolioTotalGainPercentage,
        );
      } catch (e) {
        yield PortfolioLoadFailure(e);
      }
    }

    if (event is PortfolioHide) {
      yield PortfolioIsHidden();
    }

    if (event is PortfolioUnHide) {
      yield PortfolioIsUnhidden(
        portfolioValue,
        portfolioTotalSpent,
        portfolioTotalGain,
        portfolioTotalGainPercentage,
      );
    }
  }
}
