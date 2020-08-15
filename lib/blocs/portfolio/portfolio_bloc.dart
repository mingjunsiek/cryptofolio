import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/repositories/coin_repository.dart';
import 'package:cryptofolio/widgets/home/coin_card/coin_lists.dart';
import 'package:cryptofolio/widgets/portfolio/date_textfield.dart';
import 'package:cryptofolio/widgets/portfolio/dialog_textfield.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:random_color/random_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  List<Coin> _coinList;
  List<PortfolioItem> _portfolioItems;
  double _portfolioTotalSpent = 0.0;
  double _portfolioValue = 0.0;
  double _portfolioTotalGain = 0.0;
  double _portfolioTotalGainPercentage = 0.0;
  bool _isHidden = false;
  SharedPreferences _prefs;
  Uuid _uuid;
  Map<String, Map<String, dynamic>> pieChartInfo;
  List<PieChartSectionData> pieChartSectionData = [];

  PortfolioBloc(this._coinList) : super(PortfolioInProgress());

  void getSharedPreferences() async {
    try {
      this._prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey("portfolio"))
        _portfolioItems = [];
      else {
        final List<dynamic> _decodedItems =
            jsonDecode(_prefs.getString("portfolio"));
        _portfolioItems = _decodedItems.map((item) {
          return PortfolioItem.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print("Error in PortfolioBloc: getSharedPreferences");
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
      await _prefs.setString('portfolio', jsonTags);
      _updatePortfolio();
      yield* _mapPortfolioPageToState();
    }

    if (event is PortfolioPageEditItem) {
      yield PortfolioInProgress();
      _portfolioItems = _portfolioItems.map((currentItem) {
        if (currentItem.portfolioId == event.item.portfolioId) {
          return event.item;
        }
        return currentItem;
      }).toList();
      print('After: $_portfolioItems');
      String jsonTags = jsonEncode(_portfolioItems);
      await _prefs.setString('portfolio', jsonTags);
      _updatePortfolio();
      yield* _mapPortfolioPageToState();
    }

    if (event is PortfolioPageDeleteItem) {
      yield PortfolioInProgress();
      _portfolioItems.removeWhere((currentItem) {
        return currentItem.portfolioId == event.portfolioId;
      });
      String jsonTags = jsonEncode(_portfolioItems);
      await _prefs.setString('portfolio', jsonTags);
      _updatePortfolio();
      yield* _mapPortfolioPageToState();
    }
  }

  void setSharedPreferences() {}

  Stream<PortfolioState> _mapHomePortfolioToState() async* {
    yield PortfolioInProgress();
    _uuid = Uuid();
    _portfolioItems = [];
    _portfolioTotalSpent = 0.0;
    _portfolioValue = 0.0;
    _portfolioTotalGain = 0.0;
    _portfolioTotalGainPercentage = 0.0;
    try {
      this._prefs = await SharedPreferences.getInstance();
      if (_prefs.containsKey("portfolio")) {
        final List<dynamic> _decodedItems =
            jsonDecode(_prefs.getString("portfolio"));
        _portfolioItems = _decodedItems.map((item) {
          return PortfolioItem.fromJson(item);
        }).toList();
        _updatePortfolio();
      }

      if (_portfolioItems.isEmpty) {
        yield PortfolioIsEmpty();
      } else {
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
      _coinList.where((coin) {
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

  Future<void> addDialog(
    BuildContext ctx,
    GlobalKey<FormState> dialogKey,
    TextEditingController coinCtrl,
    TextEditingController amtCtrl,
    TextEditingController priceCtrl,
    TextEditingController dateCtrl,
    bool isEdit,
    PortfolioItem item,
  ) async {
    if (isEdit) {
      coinCtrl.text = item.coindId.toString();
      amtCtrl.text = item.coinAmount.toString();
      priceCtrl.text = item.price.toString();
      dateCtrl.text = item.purchaseDate.toString();
    }

    return showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text('Add coin'),
          content: SingleChildScrollView(
            child: Form(
              key: dialogKey,
              child: ListBody(
                children: <Widget>[
                  DialogTextField(
                    controller: coinCtrl,
                    icon: null,
                    title: 'Coin Symbol',
                    isText: true,
                    validator: 'a symbol',
                  ),
                  DialogTextField(
                    controller: amtCtrl,
                    icon: null,
                    title: 'Amount',
                    isText: false,
                    validator: 'an amount',
                  ),
                  DialogTextField(
                    controller: priceCtrl,
                    icon: null,
                    title: 'Price',
                    isText: false,
                    validator: 'a price',
                  ),
                  DateTextField(
                    controller: dateCtrl,
                    icon: null,
                    title: 'Purchase Date',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: isEdit ? Text('Edit') : Text('Add'),
              onPressed: () {
                if (dialogKey.currentState.validate()) {
                  final _enteredSymbol = coinCtrl.text.toLowerCase();
                  final _enteredAmount = double.parse(amtCtrl.text);
                  final _enteredPrice = double.parse(priceCtrl.text);
                  final DateTime _enteredDate =
                      DateFormat('dd/MM/yyyy').parse(dateCtrl.text);
                  if (!isEdit) {
                    ctx.bloc<PortfolioBloc>().add(
                          AddPortfolioItem(
                              coinAmount: _enteredAmount,
                              coindId: _enteredSymbol,
                              price: _enteredPrice,
                              purchaseDate: _enteredDate),
                        );
                  } else {
                    final portItem = PortfolioItem(
                      portfolioId: item.portfolioId,
                      coinAmount: _enteredAmount,
                      coindId: _enteredSymbol,
                      price: _enteredPrice,
                      purchaseDate: _enteredDate,
                    );
                    ctx.bloc<PortfolioBloc>().add(
                          PortfolioPageEditItem(item: portItem),
                        );
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
