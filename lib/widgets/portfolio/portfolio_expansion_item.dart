import 'package:cryptofolio/blocs/portfolio/portfolio_bloc.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'colored_box.dart';

class PortfolioExpansionItem extends StatefulWidget {
  final PortfolioItem item;
  final double currentPrice;

  const PortfolioExpansionItem({
    Key key,
    this.item,
    this.currentPrice,
  }) : super(key: key);

  @override
  _PortfolioExpansionItemState createState() => _PortfolioExpansionItemState();
}

class _PortfolioExpansionItemState extends State<PortfolioExpansionItem> {
  final double fontSize = 12;

  final _editKey = GlobalKey<FormState>();

  TextEditingController _coinFieldController = TextEditingController();

  TextEditingController _amountFieldController = TextEditingController();

  TextEditingController _priceFieldController = TextEditingController();

  TextEditingController _purchaseDateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.portfolioId),
      background: Container(
        color: Colors.green,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Text(
                " Edit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).cardTheme.color,
                  content: Text("Are you sure you want to delete this item?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        context.bloc<PortfolioBloc>().add(
                            PortfolioPageDeleteItem(
                                portfolioId: widget.item.portfolioId));
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                );
              });
          return res;
        } else {
          return await context.bloc<PortfolioBloc>().addDialog(
                context,
                _editKey,
                _coinFieldController,
                _amountFieldController,
                _priceFieldController,
                _purchaseDateFieldController,
                true,
                widget.item,
              ) as bool;
        }
      },
      child: InkWell(
        onTap: () {},
        child: Container(
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
                    DateFormat('dd MMM yyy').format(widget.item.purchaseDate),
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Container(
                  width: 55,
                  child: Text(
                    'Amt: ${widget.item.coinAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Container(
                  width: 85,
                  child: Text(
                    'Cost: \$${widget.item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
                if (widget.item.price <
                    (widget.currentPrice * widget.item.coinAmount))
                  PortfolioColoredBox(
                    item: widget.item,
                    currentPrice: widget.currentPrice,
                    fontSize: fontSize,
                    width: 60,
                    height: 30,
                    color: Colors.green[300],
                    body:
                        '\$${((widget.currentPrice * widget.item.coinAmount) - widget.item.price).toStringAsFixed(2)}',
                  ),
                if (widget.item.price >=
                    (widget.currentPrice * widget.item.coinAmount))
                  PortfolioColoredBox(
                    item: widget.item,
                    currentPrice: widget.currentPrice,
                    fontSize: fontSize,
                    width: 60,
                    height: 30,
                    color: Colors.red[700],
                    body:
                        '-\$${(widget.item.price - (widget.currentPrice * widget.item.coinAmount)).toStringAsFixed(2)}',
                  ),
                if (widget.item.price <
                    (widget.currentPrice * widget.item.coinAmount))
                  PortfolioColoredBox(
                    item: widget.item,
                    currentPrice: widget.currentPrice,
                    fontSize: fontSize,
                    width: 50,
                    height: 30,
                    color: Colors.green[300],
                    body:
                        '${(((widget.currentPrice * widget.item.coinAmount) / widget.item.price * 100) - 100).toStringAsFixed(2)}%',
                  ),
                if (widget.item.price >=
                    (widget.currentPrice * widget.item.coinAmount))
                  PortfolioColoredBox(
                    item: widget.item,
                    currentPrice: widget.currentPrice,
                    fontSize: fontSize,
                    width: 50,
                    height: 30,
                    color: Colors.red[700],
                    body:
                        '${(((widget.currentPrice * widget.item.coinAmount) / widget.item.price * 100) - 100).toStringAsFixed(2)}%',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
