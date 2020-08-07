import 'package:flutter/material.dart';

class IsLoadingCard extends StatelessWidget {
  const IsLoadingCard({
    Key key,
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
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
