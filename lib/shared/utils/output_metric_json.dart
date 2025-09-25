class OutputMetricJson {
  final String output;
  final String? monthValue;
  final String dept;
  final String unit;

  OutputMetricJson({
    required this.output,
    this.monthValue,
    required this.dept,
    required this.unit
  });

  factory OutputMetricJson.fromJson(Map<String, dynamic> json) {
    // Detect which key is the month (e.g., "september")
    final monthKey = json.keys.firstWhere(
          (key) => _months.contains(key.toLowerCase()),
      orElse: () => '',
    );

    return OutputMetricJson(
      output: json['output'] ?? '',
      monthValue: monthKey.isNotEmpty ? json[monthKey]?.toString() : null, dept: json['dept'] ?? '', unit:json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      // Serialize monthValue back to a fixed key or dynamic one
      // For simplicity, assuming 'month' as key
      'month': monthValue,
    };
  }

  static const List<String> _months = [
    "january", "february", "march", "april", "may", "june",
    "july", "august", "september", "october", "november", "december"
  ];
}
