import 'package:flutter/widgets.dart';

enum AppTab { home, search, portfolio, settings }

class AppTabKeys {
  static final tabs = const Key('__tabs__');
  static final hometab = const Key('__hometab__');
  static final searchtab = const Key('__searchtab__');
  static final portfoliotab = const Key('__portfoliotab__');
  static final settingstab = const Key('__settingstab__');
}
