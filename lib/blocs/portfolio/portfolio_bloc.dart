import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:cryptofolio/widgets/home/coin_card/coin_lists.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  CoinRepository _coinRepository;
  List<Coin> _coinList;
  List<Coin> _portfolioCoinsList;
  List<PortfolioItem> _portfolioItems = [];
  double _portfolioTotalSpent = 0.0;
  double _portfolioValue = 0.0;
  double _portfolioTotalGain = 0.0;
  double _portfolioTotalGainPercentage = 0.0;
  bool _isHidden = false;
  SharedPreferences _prefs;
  Uuid _uuid;
  Map<String, Map<String, dynamic>> pieChartInfo;
  List<PieChartSectionData> pieChartSectionData = [];

  // double portfolioDaysGain = 0.0;
  // double portfolioDaysGainPercentage = 0.0;
  // DateTime currentDateTime = DateTime.now();

  PortfolioBloc(this._coinList) : super(PortfolioInProgress()) {
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    try {
      this._prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey("portfolio"))
        _portfolioItems = [];
      else {
        final _decodedItems = jsonDecode(_prefs.getString("portfolio"));
        _portfolioItems =
            _decodedItems.map((item) => PortfolioItem.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error in search bloc");
    }
  }

  @override
  Stream<PortfolioState> mapEventToState(
    PortfolioEvent event,
  ) async* {
    if (event is PortfolioFetch) {
      yield* _mapHomePortfolioToState();
    }

    if (event is PortfolioHide) {
      yield PortfolioInProgress();
      this._isHidden = true;
      yield PortfolioIsInitialized(
        _portfolioValue,
        _portfolioTotalSpent,
        _portfolioTotalGain,
        _portfolioTotalGainPercentage,
        this._isHidden,
      );
    }

    if (event is PortfolioUnHide) {
      yield PortfolioInProgress();
      this._isHidden = false;
      yield PortfolioIsInitialized(
        _portfolioValue,
        _portfolioTotalSpent,
        _portfolioTotalGain,
        _portfolioTotalGainPercentage,
        this._isHidden,
      );
    }

    if (event is PortfolioPageHide) {
      yield PortfolioInProgress();
      this._isHidden = true;
      yield* _mapPortfolioPageToState();
    }

    if (event is PortfolioPageUnHide) {
      yield PortfolioInProgress();
      this._isHidden = false;
      yield* _mapPortfolioPageToState();
    }

    if (event is InitializePortfolioPage) {
      yield PortfolioInProgress();
      yield* _mapPortfolioPageToState();
    }

    if (event is AddPortfolioItem) {
      yield PortfolioInProgress();
      final newItem = PortfolioItem(
        coinAmount: event.coinAmount,
        coindId: event.coindId,
        price: event.price,
        purchaseDate: event.purchaseDate,
        portfolioId: _uuid.v4(),
      );

      _portfolioItems.add(newItem);
      String jsonTags = jsonEncode(_portfolioItems);
      _prefs.setString('portfolio', jsonTags);
      _updatePortfolio();
      yield* _mapPortfolioPageToState();
    }
  }

  Stream<PortfolioState> _mapHomePortfolioToState() async* {
    yield PortfolioInProgress();
    _uuid = Uuid();
    try {
      // this._prefs = await SharedPreferences.getInstance();

      if (_portfolioItems.isEmpty) {
        yield PortfolioIsEmpty();
      } else {
        // final _decodedItems = jsonDecode(_prefs.getString("portfolio"));
        // _portfolioItems =
        //     _decodedItems.map((item) => PortfolioItem.fromJson(item)).toList();
        yield PortfolioIsInitialized(
          _portfolioValue,
          _portfolioTotalSpent,
          _portfolioTotalGain,
          _portfolioTotalGainPercentage,
          this._isHidden,
        );
      }
    } catch (e) {
      if (e is String)
        yield PortfolioLoadFailure(e);
      else
        yield PortfolioLoadFailure("Error in portfolio bloc");
    }
  }

  Stream<PortfolioState> _mapPortfolioPageToState() async* {
    if (_portfolioItems.isEmpty)
      yield PortfolioInitial();
    else
      yield PortfolioPageLoadSuccess(
        portfolioValue: this._portfolioValue,
        portfolioTotalSpent: _portfolioTotalSpent,
        portfolioItemList: this._portfolioItems,
        portfolioTotalGain: this._portfolioTotalGain,
        portfolioTotalGainPercentage: this._portfolioTotalGainPercentage,
        isHidden: this._isHidden,
        pieChartInfo: pieChartInfo,
      );
  }

  void _updatePortfolio() {
    try {
      RandomColor _randomColor = RandomColor();
      pieChartInfo = new Map();
      print('After Decode: $_portfolioItems');
      // print(_coinList);
      _portfolioCoinsList = _coinList.where((coin) {
        final result = _portfolioItems.where((portfolioCoin) {
          if (portfolioCoin.coindId == coin.symbol) {
            this._portfolioValue +=
                portfolioCoin.coinAmount * coin.current_price;
            this._portfolioTotalSpent += portfolioCoin.price;

            if (!pieChartInfo.containsKey(portfolioCoin.coindId)) {
              pieChartInfo[portfolioCoin.coindId] = {
                "coinId": portfolioCoin.coindId,
                "price": portfolioCoin.price,
                "amount": portfolioCoin.coinAmount,
                "color": _randomColor.randomColor(
                  colorHue: ColorHue.multiple(
                    colorHues: [ColorHue.red, ColorHue.blue],
                  ),
                ),
                "coinSymbol": coin.symbol.toUpperCase(),
                "coinList": [portfolioCoin],
                "coinImage": coin.image,
                "coinName": coin.name,
                "currentValue": portfolioCoin.coinAmount * coin.current_price,
                "currentPrice": coin.current_price,
              };
            } else {
              pieChartInfo.update(portfolioCoin.coindId, (value) {
                value.update('price', (value) => value + portfolioCoin.price);
                value.update(
                    'amount', (value) => value + portfolioCoin.coinAmount);
                value.update(
                    'currentValue',
                    (value) =>
                        value +
                        (portfolioCoin.coinAmount * coin.current_price));
                value.update('coinList', (value) {
                  List<PortfolioItem> items = value;
                  items.add(portfolioCoin);
                  return items;
                });
                return value;
              });
            }
            return true;
          }
          return false;
        }).toList();

        if (result.isNotEmpty) {
          print('Results: $result');
          pieChartInfo[coin.symbol]['PnL'] = pieChartInfo[coin.symbol]
                  ['currentValue'] -
              pieChartInfo[coin.symbol]['price'];
          pieChartInfo[coin.symbol]['PnLPercentage'] =
              ((pieChartInfo[coin.symbol]['currentValue'] /
                      pieChartInfo[coin.symbol]['price'] *
                      100) -
                  100);
          return true;
        } else
          return false;
      }).toList();

      print('portfolioTotalSpent: $_portfolioTotalSpent');
      print('portfolioValue: $_portfolioValue');
      print('pieChartInfo: $pieChartInfo');

      this._portfolioTotalGain =
          this._portfolioValue - this._portfolioTotalSpent;
      this._portfolioTotalGainPercentage =
          ((this._portfolioValue / this._portfolioTotalSpent) * 100) - 100;
    } catch (e) {
      throw "Error in _updatePortFolio";
    }
  }
}
