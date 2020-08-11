part of 'portfolio_bloc.dart';

@immutable
abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioIsEmpty extends PortfolioState {}

class PortfolioInProgress extends PortfolioState {}

class PortfolioIsUnhidden extends PortfolioState {
  final double portfolioValue;
  final double portfolioTotalSpent;
  final double portfolioTotalGain;
  final double portfolioTotalGainPercentage;

  PortfolioIsUnhidden(
    this.portfolioValue,
    this.portfolioTotalSpent,
    this.portfolioTotalGain,
    this.portfolioTotalGainPercentage,
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
      'PortfolioLoadSuccess { todos: $portfolioValue $portfolioTotalSpent }';
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
