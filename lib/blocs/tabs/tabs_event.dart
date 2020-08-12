part of 'tabs_bloc.dart';

@immutable
abstract class TabsEvent extends Equatable {
  const TabsEvent();

  @override
  List<Object> get props => [];
}

class TabsUpdated extends TabsEvent {
  final AppTab tab;

  const TabsUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'TabUpdated { tab: $tab }';
}

class NavigatorActionPop extends TabsEvent {}

class NavigateToHomeEvent extends TabsEvent {}

class NavigateToSearchEvent extends TabsEvent {}

class NavigateToPortfolioEvent extends TabsEvent {}

class NavigateToSettingEvent extends TabsEvent {}
