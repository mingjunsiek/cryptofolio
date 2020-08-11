import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptofolio/models/app_tab.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tabs_event.dart';

class TabsBloc extends Bloc<TabsEvent, AppTab> {
  TabsBloc() : super(AppTab.home);

  @override
  Stream<AppTab> mapEventToState(
    TabsEvent event,
  ) async* {
    if (event is TabsUpdated) {
      yield event.tab;
    }
  }
}
