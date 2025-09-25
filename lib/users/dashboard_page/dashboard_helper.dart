import 'package:intl/intl.dart';
List<OutputActivity> filterOutputsByMonthRange(
    List<Map<String, dynamic>> data, String dateRange) {
  final monthsInRange = getMonthsInRange(dateRange);

  List<OutputActivity> filtered = [];

  for (var item in data) {
    Map<String, String> monthValues = {};

    for (var month in monthsInRange) {
      final value = item[month];
      if (value != null && value.toString().trim().isNotEmpty && value != "0") {
        monthValues[capitalize(month)] = value.toString(); // Capitalize month
      }
    }

    if (monthValues.isNotEmpty) {
      filtered.add(OutputActivity(
        output: item['output'],
        monthValues: monthValues,
      ));
    }
  }

  return filtered;
}


List<String> getMonthsInRange(String dateRange) {
  List<String> parts = dateRange.split('-');
  DateTime startDate = DateFormat('d/M/yyyy').parse(parts[0].trim());
  DateTime endDate = DateFormat('d/M/yyyy').parse(parts[1].trim());

  List<String> months = [];
  DateTime current = DateTime(startDate.year, startDate.month);
  DateTime end = DateTime(endDate.year, endDate.month + 1); // inclusive

  while (current.isBefore(end)) {
    months.add(DateFormat('MMMM').format(current).toLowerCase());
    current = DateTime(current.year, current.month + 1);
  }

  return months;
}

class OutputActivity {
  final String output;
  final Map<String, String> monthValues;

  OutputActivity({
    required this.output,
    required this.monthValues,
  });

  @override
  String toString() {
    return 'OutputActivity(output: $output, months: $monthValues)';
  }
}

String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
