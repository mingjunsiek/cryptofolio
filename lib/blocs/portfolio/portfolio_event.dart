part of 'portfolio_bloc.dart';

@immutable
abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class PortfolioFetch extends PortfolioEvent {
  const PortfolioFetch();
}

class PortfolioHide extends PortfolioEvent {
  const PortfolioHide();
}

class PortfolioUnHide extends PortfolioEvent {
  const PortfolioUnHide();
}
