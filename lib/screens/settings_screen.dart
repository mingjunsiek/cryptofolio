import 'package:cryptofolio/models/routes.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("PORTFOLIO"),
          onPressed: () {
            // print(Navigator.of(context).canPop());
            Navigator.pushNamed(context, CryptofolioRoutes.portfolio);
          },
        ),
      ),
    );
  }
}
