import 'package:cryptofolio/blocs/portfolio/portfolio_bloc.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/widgets/home/coin_card/title_with_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'colored_text_column.dart';
import 'date_textfield.dart';
import 'dialog_textfield.dart';

class PortfolioList extends StatefulWidget {
  final PortfolioPageLoadSuccess state;
  final PortfolioBloc portfolioBloc;
  const PortfolioList({
    Key key,
    this.state,
    this.portfolioBloc,
  }) : super(key: key);

  @override
  _PortfolioListState createState() => _PortfolioListState();
}

class _PortfolioListState extends State<PortfolioList> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _coinFieldController = TextEditingController();
  TextEditingController _amountFieldController = TextEditingController();
  TextEditingController _priceFieldController = TextEditingController();
  TextEditingController _purchaseDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 30,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current Holdings",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  child: Text("Add"),
                  onTap: () {
                    addDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          width: displayWidth(context) * 0.95,
          height: (displayHeight(context) -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight) *
              0.50,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemCount: widget.state.pieChartInfo.length,
              itemBuilder: (context, index) {
                final map = widget.state.pieChartInfo;
                String portKey = map.keys.elementAt(index);

                return Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Container(
                    child: ExpansionTile(
                      title: PortfolioTitle(map: map, portKey: portKey),
                      children: [
                        ...(map[portKey]['coinList'] as List).map((item) {
                          return PortfolioExpansionItem(
                            item: item,
                            currentPrice: map[portKey]['currentPrice'],
                          );
                        })
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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

class PortfolioExpansionItem extends StatelessWidget {
  final PortfolioItem item;
  final double currentPrice;
  final double fontSize = 12;

  const PortfolioExpansionItem({
    Key key,
    this.item,
    this.currentPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white38,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 70,
              child: Text(
                DateFormat('dd MMM yyy').format(item.purchaseDate),
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ),
            Container(
              width: 55,
              child: Text(
                'Amt: ${item.coinAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ),
            Container(
              width: 85,
              child: Text(
                'Cost: \$${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ),
            if (item.price < (currentPrice * item.coinAmount))
              ColoredBox(
                item: item,
                currentPrice: currentPrice,
                fontSize: fontSize,
                width: 60,
                height: 30,
                color: Colors.green[300],
                body:
                    '\$${((currentPrice * item.coinAmount) - item.price).toStringAsFixed(2)}',
              ),
            if (item.price >= (currentPrice * item.coinAmount))
              ColoredBox(
                item: item,
                currentPrice: currentPrice,
                fontSize: fontSize,
                width: 60,
                height: 30,
                color: Colors.red[700],
                body:
                    '-\$${(item.price - (currentPrice * item.coinAmount)).toStringAsFixed(2)}',
              ),
            if (item.price < (currentPrice * item.coinAmount))
              ColoredBox(
                item: item,
                currentPrice: currentPrice,
                fontSize: fontSize,
                width: 50,
                height: 30,
                color: Colors.green[300],
                body:
                    '${(((currentPrice * item.coinAmount) / item.price * 100) - 100).toStringAsFixed(2)}%',
              ),
            if (item.price >= (currentPrice * item.coinAmount))
              ColoredBox(
                item: item,
                currentPrice: currentPrice,
                fontSize: fontSize,
                width: 50,
                height: 30,
                color: Colors.red[700],
                body:
                    '${(((currentPrice * item.coinAmount) / item.price * 100) - 100).toStringAsFixed(2)}%',
              ),
          ],
        ),
      ),
    );
  }
}

class ColoredBox extends StatelessWidget {
  const ColoredBox({
    Key key,
    @required this.item,
    @required this.currentPrice,
    @required this.fontSize,
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.body,
  }) : super(key: key);

  final PortfolioItem item;
  final double currentPrice;
  final double fontSize;
  final double width;
  final double height;
  final Color color;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            body,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioTitle extends StatelessWidget {
  const PortfolioTitle({
    Key key,
    @required this.map,
    @required this.portKey,
  }) : super(key: key);

  final Map<String, Map<String, dynamic>> map;
  final String portKey;
  final double fontSize = 11;
  final double titleFontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          child: Image.network(
            map[portKey]['coinImage'].replaceAll("large", "small"),
            // alignment: Alignment.center,
            scale: 1.7,
          ),
        ),
        Container(
          width: 65,
          child: Text(
            '${map[portKey]['coinName']} (${map[portKey]['coinSymbol']})',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: this.titleFontSize,
            ),
          ),
        ),
        Container(
          width: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Amount",
                style: TextStyle(
                  fontSize: this.fontSize,
                ),
              ),
              Text(
                '${(map[portKey]['amount'] as double).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: this.titleFontSize,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 55,
          child: Column(
            children: [
              Text(
                "Value",
                style: TextStyle(
                  fontSize: this.fontSize,
                ),
              ),
              Text(
                '\$${(map[portKey]['currentValue'] as double).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: this.titleFontSize,
                ),
              ),
            ],
          ),
        ),
        ColoredTextColumn(
          fontSize: fontSize,
          portKey: portKey,
          titleFontSize: titleFontSize,
          title: 'PnL',
          leading: '\$',
          profit: (map[portKey]['PnL'] as double) >= 0 ? true : false,
          body: '${(map[portKey]['PnL'] as double).toStringAsFixed(2)}',
        ),
        ColoredTextColumn(
          fontSize: fontSize,
          portKey: portKey,
          titleFontSize: titleFontSize,
          title: '%',
          tail: '%',
          profit: (map[portKey]['PnLPercentage'] as double) >= 0 ? true : false,
          body:
              '${(map[portKey]['PnLPercentage'] as double).toStringAsFixed(2)}',
        ),
      ],
    );
  }
}
