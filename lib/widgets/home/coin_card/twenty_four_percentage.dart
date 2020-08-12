import 'package:flutter/material.dart';

class TwentyFourPercentage extends StatelessWidget {
  final double percentage;

  const TwentyFourPercentage({Key key, this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("24hr"),
          if (percentage == null)
            Text(
              "-",
              style: TextStyle(
                color: Colors.grey[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          if (percentage != null && percentage < 0)
            Text(
              percentage.toStringAsFixed(2),
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          if (percentage != null && percentage >= 0)
            Text(
              percentage.toStringAsFixed(2),
              style: TextStyle(
                color: Colors.green[300],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
