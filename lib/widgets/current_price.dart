import 'package:flutter/material.dart';

class CurrentPrice extends StatelessWidget {
  final double currentPrice;

  const CurrentPrice({Key key, this.currentPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Price"),
          if (currentPrice < 1)
            Text(
              currentPrice.toStringAsFixed(5),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (currentPrice >= 1)
            Text(
              currentPrice.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
