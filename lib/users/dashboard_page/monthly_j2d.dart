import 'package:intl/intl.dart';
class MonthlyJ2D {
  final int id;
  final String dept;
  final String unit;
  final String output;
  final DateTime plannedStart;
  final String plannedDuration;
  final DateTime plannedEnd;
  final DateTime actualStart;
  final String actualDuration;
  final DateTime actualEnd;
  final String target;
  final String activitiesDescription;
  final String outcome;
  final int percentCompleted;
  final String milestone;
  final String actualTargetMetrics;
  final String actualAchievedMetrics;
  final String financials;
  final String release;
  final String utility;
  final String balance;
  final String moreFunds;
  final String challenges;
  final String remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyJ2D({
    required this.id,
    required this.dept,
    required this.unit,
    required this.output,
    required this.plannedStart,
    required this.plannedDuration,
    required this.plannedEnd,
    required this.actualStart,
    required this.actualDuration,
    required this.actualEnd,
    required this.target,
    required this.activitiesDescription,
    required this.outcome,
    required this.percentCompleted,
    required this.milestone,
    required this.actualTargetMetrics,
    required this.actualAchievedMetrics,
    required this.financials,
    required this.release,
    required this.utility,
    required this.balance,
    required this.moreFunds,
    required this.challenges,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MonthlyJ2D.fromJson(Map<String, dynamic> json) {
    final DateFormat customFormat = DateFormat('dd/MM/yyyy');

    return MonthlyJ2D(
      id: json['id'],
      dept: json['dept'],
      unit: json['unit'],
      output: json['output'],
      plannedStart: customFormat.parse(json['planned_start']),
      plannedDuration: json['planned_duration'],
      plannedEnd: customFormat.parse(json['planned_end']),
      actualStart: customFormat.parse(json['actual_start']),
      actualDuration: json['actual_duration'],
      actualEnd: customFormat.parse(json['actual_end']),
      target: json['target'],
      activitiesDescription: json['activities_decription'],
      outcome: json['outcome'],
      percentCompleted: int.tryParse(json['%completed'].toString()) ?? 0,
      milestone: json['milestone'],
      actualTargetMetrics: json['actual_target(metrics)'],
      actualAchievedMetrics: json['actual_achieved(metrics)'],
      financials: json['financials'],
      release: json['release'],
      utility: json['utility'],
      balance: json['balance'],
      moreFunds: json['more_funds'],
      challenges: json['challenges'],
      remarks: json['remarks'],
      createdAt: DateTime.parse(json['created_at']), // Already ISO format
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dept': dept,
      'unit': unit,
      'output': output,
      'planned_start': plannedStart.toIso8601String(),
      'planned_duration': plannedDuration,
      'planned_end': plannedEnd.toIso8601String(),
      'actual_start': actualStart.toIso8601String(),
      'actual_duration': actualDuration,
      'actual_end': actualEnd.toIso8601String(),
      'target': target,
      'activities_decription': activitiesDescription,
      'outcome': outcome,
      '%completed': percentCompleted,
      'milestone': milestone,
      'actual_target(metrics)': actualTargetMetrics,
      'actual_achieved(metrics)': actualAchievedMetrics,
      'financials': financials,
      'release': release,
      'utility': utility,
      'balance': balance,
      'more_funds': moreFunds,
      'challenges': challenges,
      'remarks': remarks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
