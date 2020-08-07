import 'package:flutter/material.dart';

class DefaultTextCard extends StatelessWidget {
  final text;
  const DefaultTextCard({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 15,
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
