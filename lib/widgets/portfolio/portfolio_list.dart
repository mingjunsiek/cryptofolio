import 'package:cryptofolio/blocs/portfolio/portfolio_bloc.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/widgets/home/coin_card/title_with_button_bar.dart';
import 'package:cryptofolio/widgets/portfolio/portfolio_title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'colored_text_column.dart';
import 'date_textfield.dart';
import 'dialog_textfield.dart';
import 'portfolio_expansion_item.dart';

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
                    context.bloc<PortfolioBloc>().addDialog(
                          context,
                          _formKey,
                          _coinFieldController,
                          _amountFieldController,
                          _priceFieldController,
                          _purchaseDateFieldController,
                          false,
                          null,
                        );
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
}
