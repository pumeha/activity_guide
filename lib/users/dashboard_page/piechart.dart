import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWithPercentages extends StatelessWidget {
  final Map<String, double> inputData;

  const PieChartWithPercentages({super.key, required this.inputData});

  @override
  Widget build(BuildContext context) {
    // Filter out entries with 0 value
    final filteredData = inputData.entries.where((e) => e.value > 0).toList();

    // If all values are zero or the list is empty, show a placeholder
    if (filteredData.isEmpty) {
      return const Center(
        child: Text("No data to display"),
      );
    }

    // Calculate total
    double total = filteredData.fold(0, (sum, entry) => sum + entry.value);

    // Build chart data with percentages
    final List<ChartData> chartData = filteredData.map((entry) {
      final percent = ((entry.value / total) * 100).toStringAsFixed(1);
      return ChartData(
        entry.key,
        entry.value,
        '$percent%',
      );
    }).toList();

    return SizedBox(
      width: 400,
      child: SfCircularChart(
        title: ChartTitle(
          text: 'Challenges',
          backgroundColor: Colors.black,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.auto,
        ),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => data.text,
            explodeAll: true,
            explode: true,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.text, [this.color]);
  final String x;
  final double y;
  final String text;
  final Color? color;
}
