import 'package:cryptofolio/blocs/blocs.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePortfolioCard extends StatelessWidget {
  final double portfolioTotalValue;
  final double portfolioTotalSpent;
  final double portfolioTotalGain;
  final double portfolioTotalGainPercentage;
  final bool isHidden;
  const HomePortfolioCard({
    Key key,
    this.portfolioTotalValue,
    this.portfolioTotalSpent,
    this.isHidden,
    this.portfolioTotalGain,
    this.portfolioTotalGainPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: displayWidth(context) * 0.95,
      height: (displayHeight(context) -
              MediaQuery.of(context).padding.top -
              kToolbarHeight) *
          0.30,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Portfolio',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        isHidden
                            ? '********'
                            : '\$${this.portfolioTotalValue.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).buttonColor,
                    ),
                    onPressed: () {
                      final portfolioBloc = context.bloc<PortfolioBloc>();
                      if (!isHidden)
                        portfolioBloc.add(PortfolioHide());
                      else
                        portfolioBloc.add(PortfolioUnHide());
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total gain'),
                  if (!isHidden && portfolioTotalGain >= 0)
                    Text(
                      '+\$${portfolioTotalGain.toStringAsFixed(2)} (+${portfolioTotalGainPercentage.toStringAsFixed(2)})',
                      style: TextStyle(color: Color(0xFF00AB5E)),
                    ),
                  if (!isHidden && portfolioTotalGain < 0 && !isHidden)
                    Text(
                      '\$${portfolioTotalGain.toStringAsFixed(2)} (+${portfolioTotalGainPercentage.toStringAsFixed(2)})',
                      style: TextStyle(color: Color(0xFFF80E0E)),
                    ),
                  if (isHidden) Text("***** (*****)"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'As of ${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.now())}',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
