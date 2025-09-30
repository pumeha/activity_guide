import 'package:activity_guide/shared/custom_widgets/app_text.dart';
import 'package:activity_guide/shared/custom_widgets/my_card.dart';
import 'package:activity_guide/shared/custom_widgets/reuseable_dropdown.dart';
import 'package:activity_guide/users/dashboard_page/custom_dashboard_page.dart';
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
  List<ActivityAndValues> data;
  HorizontalColumnChart(
      {super.key, required this.barColor, required this.title,required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SfCartesianChart(
        title: ChartTitle(
            text: title,
            backgroundColor: Colors.black,
            textStyle: TextStyle(color: Colors.white)),
        primaryXAxis: CategoryAxis(
          majorGridLines:
              const MajorGridLines(width: 0), // Remove vertical grid lines
        ),
        primaryYAxis: NumericAxis(
          majorGridLines:
              const MajorGridLines(width: 0), // Remove horizontal grid lines
          minimum: 0,
          maximum: 100,
        ),
        series: <BarSeries<ActivityAndValues, String>>[
          BarSeries<ActivityAndValues, String>(
            dataSource: data,
            xValueMapper: (ActivityAndValues data, _) => data.output,
            yValueMapper: (ActivityAndValues data, _) => data.percentCompleted,
            color: barColor,
            dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.middle, // or .top / .auto / .center
        textStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),

          ),
        ],
      ),
    );
  }


}

class DataTableWidget extends StatelessWidget {
  final List<String> detailsList;

  const DataTableWidget({Key? key, required this.detailsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('S/N')),
            DataColumn(label: Text('Details')),
          ],
          rows: List.generate(detailsList.length, (index) {
            return DataRow(cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text(detailsList[index])),
            ]);
          }),
        ),
      ),
    );
  }
}

class ColumnChart extends StatelessWidget {
  Color barColor;
  String title;
  double target,achieved;
  ColumnChart({super.key, required this.barColor, required this.title,required this.target,required this.achieved});
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: title,
          backgroundColor: Colors.black,
          textStyle: TextStyle(color: Colors.white)),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: <ColumnSeries<SalesData, String>>[
        ColumnSeries<SalesData, String>(
          dataSource: getChartData(),
          xValueMapper: (SalesData data, _) => data.year,
          yValueMapper: (SalesData data, _) => data.sales,
          color: barColor,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.middle, // or .top / .auto / .center
            textStyle: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  List<SalesData> getChartData() {
    return [
      SalesData('Target', target),
      SalesData('Achieved', achieved),
    ];
  }
}

class DoughnutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
          text: 'Milestone Weight',
          backgroundColor: Colors.black,
          textStyle: TextStyle(color: Colors.white)),
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
      ChartData('N/A', 35),
      ChartData('PROPOSAL', 0),
      ChartData('PLANNING', 0),
      ChartData('EXECUTING', 0),
      ChartData('COMPLETE', 12),
      ChartData('SUBMISSION', 0),
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
          endAngle: 360, // End at the bottom
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
  final double value;

  const QualitativeSpeedometer({super.key,required this.value});

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
      title: const GaugeTitle(
          text: 'Status of Milestone',
          backgroundColor: Colors.black,
          textStyle: TextStyle(color: Colors.white)),
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
            NeedlePointer(
              value: value,
            ),
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                category,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        )
      ],
    );
  }
}
