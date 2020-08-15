import 'package:cryptofolio/models/routes.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Developed by MJ Siek",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Powered by CoinGecko",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}
