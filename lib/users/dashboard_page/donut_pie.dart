import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InteractivePieChart extends StatefulWidget {
  final Map<String, double> dataMap;

  /// Format:
  /// {
  ///   'SUBMISSION': 40,
  ///   'COMPLETE': 30,
  ///   'EXECUTING': 15,
  ///   'PLANNING': 15,
  ///   'PROPOSAL': 0,
  ///   'N/A': 0,
  /// }
  const InteractivePieChart({Key? key, required this.dataMap}) : super(key: key);

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  int touchedIndex = -1;

  // Define colors for each milestone
  final Map<String, Color> milestoneColors = const {
    'SUBMISSION': Color(0xff0293ee),
    'COMPLETE': Color(0xfff8b250),
    'EXECUTING': Color(0xff845bef),
    'PLANNING': Color(0xff13d38e),
    'PROPOSAL': Color(0xfff95d6a),
    'N/A': Color(0xff9e9e9e),
  };

  @override
  Widget build(BuildContext context) {
    final milestoneList = widget.dataMap.entries
        .where((entry) => entry.value > 0)
        .toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          // Pie Chart
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: _buildChartSections(milestoneList),
                ),
              ),
            ),
          ),






          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(
      List<MapEntry<String, double>> dataList) {
    return List.generate(dataList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12.0 : 8.0;
      final radius = isTouched ? 60.0 : 50.0;

      final label = dataList[i].key;
      final value = dataList[i].value;

      return PieChartSectionData(
        color: milestoneColors[label] ?? Colors.grey,
        value: value,
        title: '${label}\n${value.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
