import 'package:flutter/material.dart';

import 'colored_text_column.dart';

class PortfolioTitle extends StatelessWidget {
  const PortfolioTitle({
    Key key,
    @required this.map,
    @required this.portKey,
  }) : super(key: key);

  final Map<String, Map<String, dynamic>> map;
  final String portKey;
  final double fontSize = 11;
  final double titleFontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          child: Image.network(
            map[portKey]['coinImage'].replaceAll("large", "small"),
            // alignment: Alignment.center,
            scale: 1.7,
          ),
        ),
        Container(
          width: 65,
          child: Text(
            '${map[portKey]['coinName']} (${map[portKey]['coinSymbol']})',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: this.titleFontSize,
            ),
          ),
        ),
        Container(
          width: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Amount",
                style: TextStyle(
                  fontSize: this.fontSize,
                ),
              ),
              Text(
                '${(map[portKey]['amount'] as double).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: this.titleFontSize,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 55,
          child: Column(
            children: [
              Text(
                "Value",
                style: TextStyle(
                  fontSize: this.fontSize,
                ),
              ),
              Text(
                '\$${(map[portKey]['currentValue'] as double).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: this.titleFontSize,
                ),
              ),
            ],
          ),
        ),
        ColoredTextColumn(
          fontSize: fontSize,
          portKey: portKey,
          titleFontSize: titleFontSize,
          title: 'PnL',
          leading: '\$',
          profit: (map[portKey]['PnL'] as double) >= 0 ? true : false,
          body: '${(map[portKey]['PnL'] as double).toStringAsFixed(2)}',
        ),
        ColoredTextColumn(
          fontSize: fontSize,
          portKey: portKey,
          titleFontSize: titleFontSize,
          title: '%',
          tail: '%',
          profit: (map[portKey]['PnLPercentage'] as double) >= 0 ? true : false,
          body:
              '${(map[portKey]['PnLPercentage'] as double).toStringAsFixed(2)}',
        ),
      ],
    );
  }
}
