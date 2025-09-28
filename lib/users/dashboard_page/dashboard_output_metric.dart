class DashboardOutputMetric {
  final String dept;
  final String unit;
  final String output;
  final List<String> months;
  final List<String> values;

  DashboardOutputMetric({
    required this.dept,
    required this.unit,
    required this.output,
    required this.months,
    required this.values,
  });

  factory DashboardOutputMetric.fromJson(Map<String, dynamic> json) {
    return DashboardOutputMetric(
      dept: json['dept'] ?? '',
      unit: json['unit'] ?? '',
      output: json['output'] ?? '',
      months: List<String>.from(json['months'] ?? []),
      values: List<String>.from(json['values'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dept': dept,
      'unit': unit,
      'output': output,
      'months': months,
      'values': values,
    };
  }
}

List<DashboardOutputMetric> processRawData(List<Map<String, dynamic>> rawData) {
  const monthKeys = [
    "january", "february", "march", "april", "may", "june",
    "july", "august", "september", "october", "november", "december"
  ];

  List<DashboardOutputMetric> results = [];

  for (var item in rawData) {
    List<String> validMonths = [];
    List<String> validValues = [];

    for (var month in monthKeys) {
      final value = item[month];
      if (value != null && value.toString().trim().isNotEmpty && value != "0") {
        validMonths.add(month);
        validValues.add(value.toString());
      }
    }

    if (validMonths.isNotEmpty) {
      results.add(DashboardOutputMetric(
        dept: item['dept'],
        unit: item['unit'],
        output: item['output'],
        months: validMonths,
        values: validValues,
      ));
    }
  }

  return results;
}
