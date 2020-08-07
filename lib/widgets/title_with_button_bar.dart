import 'package:flutter/material.dart';

class TitleWithButtonBar extends StatelessWidget {
  final title;
  final buttonText;
  final Function buttonFunction;

  const TitleWithButtonBar({
    Key key,
    this.title,
    this.buttonFunction,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            child: Text(buttonText),
            onTap: buttonFunction,
          ),
        ],
      ),
    );
  }
}
