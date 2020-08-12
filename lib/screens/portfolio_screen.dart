import 'package:cryptofolio/models/routes.dart';
import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("SETTINGS"),
          onPressed: () {
            // print(Navigator.of(context).canPop());
            Navigator.pushNamed(context, CryptofolioRoutes.settings);
          },
        ),
      ),
    );
  }
}
