import 'package:cryptofolio/blocs/portfolio/portfolio_bloc.dart';
import 'package:cryptofolio/widgets/default_text_card.dart';
import 'package:cryptofolio/widgets/home_portfolio_card.dart';
import 'package:cryptofolio/widgets/is_loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePortfolio extends StatelessWidget {
  const HomePortfolio({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PortfolioBloc, PortfolioState>(
      listener: (context, state) {
        if (state is PortfolioLoadFailure) {
          return DefaultTextCard(
              text: "PortfolioLoadFailure: Fail to load portfolio");
        }
      },
      builder: (context, state) {
        if (state is PortfolioInitial) {
          return IsLoadingCard();
        }
        if (state is PortfolioInProgress) {
          return IsLoadingCard();
        }
        if (state is PortfolioIsEmpty) {
          return DefaultTextCard(text: "PortfolioIsEmpty");
        }
        if (state is PortfolioIsUnhidden) {
          return HomePortfolioCard(
            portfolioTotalValue: state.portfolioValue,
            portfolioTotalSpent: state.portfolioTotalSpent,
            portfolioTotalGain: state.portfolioTotalGain,
            portfolioTotalGainPercentage: state.portfolioTotalGainPercentage,
            isHidden: false,
          );
        }

        if (state is PortfolioIsHidden) {
          return HomePortfolioCard(
            isHidden: true,
          );
        }

        return DefaultTextCard(text: "Catch All Fail: Fail to load portfolio");
      },
    );
  }
}
