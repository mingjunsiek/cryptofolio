import 'package:cryptofolio/blocs/portfolio/portfolio_bloc.dart';
import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PortfolioPieChart extends StatefulWidget {
  final PortfolioPageLoadSuccess state;
  const PortfolioPieChart({
    Key key,
    this.state,
  }) : super(key: key);

  @override
  _PortfolioPieChartState createState() => _PortfolioPieChartState();
}

class _PortfolioPieChartState extends State<PortfolioPieChart> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 30),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              "Breakdown of Coins",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          width: displayWidth(context) * 0.95,
          height: (displayHeight(context) -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight) *
              0.35,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: PieChart(
                      PieChartData(
                        pieTouchData:
                            PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex =
                                  pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: loadSections(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._loadLegend(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> loadSections() {
    List<PieChartSectionData> pieChartData = [];
    int i = 0;

    widget.state.pieChartInfo.forEach((key, value) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 23 : 12;
      final double radius = isTouched ? 50 : 40;
      pieChartData.add(PieChartSectionData(
        color: value['color'],
        value: ((value['price'] / widget.state.portfolioTotalSpent) * 100)
            .truncateToDouble(),
        title:
            '${((value['price'] / widget.state.portfolioTotalSpent) * 100 as double).toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      ));
      i++;
    });

    return pieChartData;
  }

  List<Widget> _loadLegend() {
    List<Widget> widgets = [];
    widget.state.pieChartInfo.forEach((key, value) {
      widgets.add(
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: value['color'],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value['coinSymbol'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
    return widgets;
  }
}
