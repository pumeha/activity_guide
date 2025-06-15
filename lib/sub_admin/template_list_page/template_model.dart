
import '../../shared/utils/rowdata_model.dart';

class TemplateModel {
  int id;
  String templateName;
  List<RowData> values;
  String? status;
  String purpose;
  String displayName;
  DateTime createdAt;
  DateTime updatedAt;

  TemplateModel({
    required this.id,
    required this.templateName,
    required this.values,
    this.status,
    required this.purpose,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'],
      templateName: json['template_name'],
      values: (json['values'] as List).map((e) => RowData.fromJson(e)).toList(),
      status: json['status'] == 0 ? 'inactive' : 'active',
      purpose: json['purpose'],
      displayName: json['display_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template_name': templateName,
      'values': values.map((e) => e.toJson()).toList(),
      'status': status,
      'purpose': purpose,
      'display_name': displayName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
