import 'package:cryptofolio/blocs/blocs.dart';
import 'package:cryptofolio/widgets/portfolio/initial_portfolio.dart';
import 'package:cryptofolio/widgets/portfolio/portfolio_list.dart';
import 'package:cryptofolio/widgets/portfolio/portfolio_pie_chart.dart';
import 'package:cryptofolio/widgets/portfolio/portfolio_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PortfolioBloc, PortfolioState>(
      listener: (context, state) {
        if (state is PortfolioPageLoadFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.errorMessage}, could not retrieve data'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PortfolioInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PortfolioInitial) {
          return InitialPortfolio(context.bloc<PortfolioBloc>());
        }

        if (state is PortfolioPageLoadSuccess) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              margin: MediaQuery.of(context).padding,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PortfolioSummaryCard(
                      state: state,
                      portfolioBloc: context.bloc<PortfolioBloc>(),
                    ),
                    PortfolioPieChart(state: state),
                    PortfolioList(
                      state: state,
                      portfolioBloc: context.bloc<PortfolioBloc>(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: Text("Fail to load portfolios"),
        );
      },
    );
  }
}
