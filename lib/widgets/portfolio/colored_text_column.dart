import 'package:flutter/material.dart';

class ColoredTextColumn extends StatelessWidget {
  const ColoredTextColumn({
    Key key,
    @required this.fontSize,
    @required this.portKey,
    @required this.titleFontSize,
    @required this.title,
    @required this.body,
    @required this.profit,
    this.leading = '',
    this.tail = '',
  }) : super(key: key);

  final double fontSize;
  final String portKey;
  final String title;
  final String body;
  final String leading;
  final String tail;
  final bool profit;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Column(
        children: [
          Text(
            this.title,
            style: TextStyle(
              fontSize: this.fontSize,
            ),
          ),
          if (profit)
            FittedBox(
              child: Text(
                '$leading${this.body}$tail',
                style: TextStyle(
                  color: Colors.green[300],
                  fontWeight: FontWeight.w600,
                  fontSize: this.titleFontSize,
                ),
              ),
            ),
          if (!profit)
            FittedBox(
              child: Text(
                '$leading${this.body}$tail',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                  fontSize: this.titleFontSize,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
