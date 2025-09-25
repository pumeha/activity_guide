import 'package:activity_guide/shared/custom_widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWithPercentages extends StatelessWidget {
  const PieChartWithPercentages({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25, '25%'),
      ChartData('Steve', 38, '38%'),
      ChartData('Jack', 34, '34%'),
      ChartData('Others', 52, '52%')
    ];
    return MyCard(
      child: SfCircularChart(
        title: ChartTitle(
            text: '\t   Challenges  \t \t',backgroundColor: Colors.black,
            textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        legend: Legend(
            isVisible: true,
            // Legend will be placed at the left
            position: LegendPosition.left),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
              dataSource: chartData,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelMapper: (ChartData data, _) => data.text,
              explodeAll: true,
              explode: true,
              dataLabelSettings: DataLabelSettings(
                // Renders the data label
                isVisible: true,
              ))
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.text, [this.color]);
  final String x;
  final double y;
  final Color? color;
  final String text;
}
