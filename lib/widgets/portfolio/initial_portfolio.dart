import 'package:cryptofolio/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'date_textfield.dart';
import 'dialog_textfield.dart';

class InitialPortfolio extends StatefulWidget {
  final PortfolioBloc portfolioBloc;
  InitialPortfolio(
    this.portfolioBloc, {
    Key key,
  }) : super(key: key);

  @override
  _InitialPortfolioState createState() => _InitialPortfolioState();
}

class _InitialPortfolioState extends State<InitialPortfolio> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _coinFieldController = TextEditingController();
  TextEditingController _amountFieldController = TextEditingController();
  TextEditingController _priceFieldController = TextEditingController();
  TextEditingController _purchaseDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          // color: Colors.blueAccent,
          textColor: Colors.white,
          child: Text("Add New Item"),
          onPressed: () {
            addDialog(context);
          },
        ),
      ),
    );
  }

  Future<void> addDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text('Add coin'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  DialogTextField(
                    controller: _coinFieldController,
                    icon: null,
                    title: 'Coin Symbol',
                    isText: true,
                    validator: 'a symbol',
                  ),
                  DialogTextField(
                    controller: _amountFieldController,
                    icon: null,
                    title: 'Amount',
                    isText: false,
                    validator: 'an amount',
                  ),
                  DialogTextField(
                    controller: _priceFieldController,
                    icon: null,
                    title: 'Price',
                    isText: false,
                    validator: 'a price',
                  ),
                  DateTextField(
                    controller: _purchaseDateFieldController,
                    icon: null,
                    title: 'Purchase Date',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  final _enteredSymbol =
                      _coinFieldController.text.toLowerCase();
                  final _enteredAmount =
                      double.parse(_amountFieldController.text);
                  final _enteredPrice =
                      double.parse(_priceFieldController.text);
                  final DateTime _enteredDate = DateFormat('dd/MM/yyyy')
                      .parse(_purchaseDateFieldController.text);
                  print(
                      '$_enteredSymbol $_enteredAmount $_enteredPrice $_enteredDate');

                  widget.portfolioBloc.add(
                    AddPortfolioItem(
                        coinAmount: _enteredAmount,
                        coindId: _enteredSymbol,
                        price: _enteredPrice,
                        purchaseDate: _enteredDate),
                  );
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
