class MonthlyValue {
  final String month;
  final String value;

  MonthlyValue({required this.month, required this.value});

  factory MonthlyValue.fromJson(Map<String, dynamic> json) {
    return MonthlyValue(
      month: json['month'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'month': month,
    'value': value,
  };
}

class DashboardOutputMetric {
  final int id;
  final String dept;
  final String unit;
  final String output;
  final List<MonthlyValue> monthlyValues;

  DashboardOutputMetric({
    required this.id,
    required this.dept,
    required this.unit,
    required this.output,
    required this.monthlyValues,
  });

  factory DashboardOutputMetric.fromJson(Map<String, dynamic> json) {
    // List of months in order
    final monthKeys = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december'
    ];

    final monthlyValues = monthKeys.map((monthKey) {
      return MonthlyValue(
        month: monthKey[0].toUpperCase() + monthKey.substring(1),
        value: json[monthKey]?.toString() ?? '',
      );
    }).toList();

    return DashboardOutputMetric(
      id: json['id'] ?? 0,
      dept: json['dept'] ?? '',
      unit: json['unit'] ?? '',
      output: json['output'] ?? '',
      monthlyValues: monthlyValues,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'dept': dept,
      'unit': unit,
      'output': output,
      'monthlyValues': monthlyValues.map((e) => e.toJson()).toList(),
    };
    return data;
  }
}
