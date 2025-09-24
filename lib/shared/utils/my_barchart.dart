import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class ColumnChartExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Sales Analysis'),

      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}k',
      ),
      series: <CartesianSeries>[
        ColumnSeries<SalesData, String>(
          dataSource: getChartData(),
          xValueMapper: (SalesData data, _) => data.year,
          yValueMapper: (SalesData data, _) => data.sales,
          name: 'Sales',
          color: Colors.blue,
        ),
      ],
    );
  }

  List<SalesData> getChartData() {
    return [
      SalesData('2018', 25),
      SalesData('2019', 38),
      SalesData('2020', 34),
      SalesData('2021', 52),
      SalesData('2022', 40),
    ];
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}


class HorizontalColumnChart extends StatelessWidget {
  Color barColor;
  String title;
  HorizontalColumnChart({super.key,required this.barColor,required this.title});
  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,
      child: SfCartesianChart(
        title: ChartTitle(text: title,backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white)),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <BarSeries<SalesData, String>>[
          BarSeries<SalesData, String>(
            dataSource: getChartData(),
            xValueMapper: (SalesData data, _) => data.year,
            yValueMapper: (SalesData data, _) => data.sales,
            color: barColor,
          ),
        ],
      ),
    );
  }

  List<SalesData> getChartData() {
    return [
      SalesData('2018', 35),
      SalesData('2019', 28),
      SalesData('2020', 34),
    ];
  }
}

class DoughnutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
     title: ChartTitle(text: 'Milestone Weight',backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white)),
      tooltipBehavior: TooltipBehavior(enable: true),
     legend: Legend(isVisible: true),
      series: <DoughnutSeries<ChartData, String>>[
        DoughnutSeries<ChartData, String>(
          dataSource: getChartData(),
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  List<ChartData> getChartData() {
    return [
      ChartData('Electronics', 35),
      ChartData('Groceries', 28),
      ChartData('Clothing', 34),
      ChartData('Books', 12),
    ];
  }
}

class ChartData {
  ChartData(this.category, this.value);
  final String category;
  final double value;
}


class HalfmoonChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: <PieSeries<_ChartData, String>>[
        PieSeries<_ChartData, String>(
          dataSource: [
            _ChartData('Category A', 40),
            _ChartData('Category B', 30),
            _ChartData('Category C', 30),
          ],
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
          startAngle: 180, // Start from the middle
          endAngle: 360,   // End at the bottom
        ),
      ],
    );
  }
}

class _ChartData {
  final String category;
  final double value;

  _ChartData(this.category, this.value);
}



class QualitativeSpeedometer extends StatelessWidget {
  // Example value: from 0 to 100 (you can adjust range)
  final double value = 30;

  // Helper to convert numeric value to category text
  String getCategory(double val) {
    if (val < 40) return 'Poor';
    if (val < 60) return 'Average';
    if (val < 80) return 'Good';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    final category = getCategory(value);
    return SfRadialGauge(
     title: const GaugeTitle(text: 'Status of Milestone',backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white)),
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showTicks: true,
          showLabels: true,
          startAngle: 180,
          endAngle: 0,
          ranges: [
            GaugeRange(startValue: 0, endValue: 40, color: Colors.red),
            GaugeRange(startValue: 40, endValue: 60, color: Colors.orange),
            GaugeRange(startValue: 60, endValue: 80, color: Colors.lightGreen),
            GaugeRange(startValue: 80, endValue: 100, color: Colors.green),
          ],
          pointers: [
            NeedlePointer(value: value),
            MarkerPointer(
              value: value,
              markerType: MarkerType.text,
              text: category,
              textStyle: const GaugeTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              markerOffset: 40,
            ),
          ],

        )
      ],
    );
  }
}
