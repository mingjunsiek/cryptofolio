import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:flutter/material.dart';

class PortfolioColoredBox extends StatelessWidget {
  const PortfolioColoredBox({
    Key key,
    @required this.item,
    @required this.currentPrice,
    @required this.fontSize,
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.body,
  }) : super(key: key);

  final PortfolioItem item;
  final double currentPrice;
  final double fontSize;
  final double width;
  final double height;
  final Color color;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: Align(
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              body,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
