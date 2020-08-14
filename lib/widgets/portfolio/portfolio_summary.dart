import 'package:cryptofolio/blocs/portfolio/portfolio_bloc.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final PortfolioPageLoadSuccess state;
  final PortfolioBloc portfolioBloc;
  const PortfolioSummaryCard({
    Key key,
    this.state,
    this.portfolioBloc,
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Current Portfolio',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      state.isHidden
                          ? '********'
                          : '\$${state.portfolioValue.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                    if (!state.isHidden && state.portfolioTotalGain >= 0)
                      Text(
                        '+\$${state.portfolioTotalGain.toStringAsFixed(2)} (+${state.portfolioTotalGainPercentage.toStringAsFixed(2)}%)',
                        style: TextStyle(color: Color(0xFF00AB5E)),
                      ),
                    if (!state.isHidden && state.portfolioTotalGain < 0)
                      Text(
                        '\$${state.portfolioTotalGain.toStringAsFixed(2)} (+${state.portfolioTotalGainPercentage.toStringAsFixed(2)}%)',
                        style: TextStyle(color: Color(0xFFF80E0E)),
                      ),
                    if (state.isHidden) Text("***** (*****)"),
                    Text(
                      'As of ${DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.now())}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(
                    state.isHidden ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).buttonColor,
                  ),
                  onPressed: () {
                    if (state.isHidden)
                      BlocProvider.of<PortfolioBloc>(context)
                          .add(PortfolioPageUnHide());
                    else
                      BlocProvider.of<PortfolioBloc>(context)
                          .add(PortfolioPageHide());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
