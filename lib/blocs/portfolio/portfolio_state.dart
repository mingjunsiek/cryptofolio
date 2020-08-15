part of 'portfolio_bloc.dart';

@immutable
abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object> get props => [];
}

class PortfolioInProgress extends PortfolioState {}

class PortfolioIsEmpty extends PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioIsInitialized extends PortfolioState {
  final double portfolioValue;
  final double portfolioTotalSpent;
  final double portfolioTotalGain;
  final double portfolioTotalGainPercentage;
  final bool isHidden;

  PortfolioIsInitialized(
    this.portfolioValue,
    this.portfolioTotalSpent,
    this.portfolioTotalGain,
    this.portfolioTotalGainPercentage,
    this.isHidden,
  );
  @override
  List<Object> get props => [
        portfolioValue,
        portfolioTotalSpent,
        portfolioTotalGain,
        portfolioTotalGainPercentage,
      ];

  @override
  String toString() =>
      'PortfolioIsInitialized { todos: $portfolioValue $portfolioTotalSpent }';
}

class PortfolioIsHidden extends PortfolioState {}

class PortfolioLoadFailure extends PortfolioState {
  final String errorMessage;
  const PortfolioLoadFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'PortfolioLoadFailure { todos: $errorMessage }';
}

class PortfolioPageInProgess extends PortfolioState {}

class PortfolioPageLoadSuccess extends PortfolioState {
  final List<PortfolioItem> portfolioItemList;
  final double portfolioTotalSpent;
  final double portfolioValue;
  final double portfolioTotalGain;
  final double portfolioTotalGainPercentage;
  final bool isHidden;
  final Map<String, Map<String, dynamic>> pieChartInfo;

  const PortfolioPageLoadSuccess({
    this.portfolioItemList,
    this.portfolioTotalSpent,
    this.portfolioValue,
    this.portfolioTotalGain,
    this.portfolioTotalGainPercentage,
    this.isHidden,
    this.pieChartInfo,
  });
}

class PortfolioPageLoadFailure extends PortfolioState {
  final String errorMessage;
  const PortfolioPageLoadFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'PortfolioPageLoadFailure { todos: $errorMessage }';
}
