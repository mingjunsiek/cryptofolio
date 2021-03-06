part of 'portfolio_bloc.dart';

@immutable
abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class PortfolioFetch extends PortfolioEvent {}

class PortfolioHide extends PortfolioEvent {}

class PortfolioUnHide extends PortfolioEvent {}

class InitializePortfolioPage extends PortfolioEvent {}

class PortfolioPageHide extends PortfolioEvent {}

class PortfolioPageUnHide extends PortfolioEvent {}

class PortfolioPageEditItem extends PortfolioEvent {
  final PortfolioItem item;
  const PortfolioPageEditItem({
    this.item,
  });
}

class PortfolioPageDeleteItem extends PortfolioEvent {
  final String portfolioId;
  const PortfolioPageDeleteItem({
    this.portfolioId,
  });
}

class AddPortfolioItem extends PortfolioEvent {
  final String coindId;
  final double coinAmount;
  final double price;
  final DateTime purchaseDate;
  const AddPortfolioItem({
    this.coindId,
    this.coinAmount,
    this.price,
    this.purchaseDate,
  });
}
