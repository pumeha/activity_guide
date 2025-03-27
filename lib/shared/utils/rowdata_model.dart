import 'package:flutter/material.dart';

class RowData {
  String id;
  TextEditingController variableNameController ;
  TextEditingController rangeController;
  TextEditingController dataTypeController;
  bool rangeStatus;
  String info;

  RowData({
    required this.id,
    String? variableName,
    String? dataType,
    String? range,
    required this.rangeStatus,
    required this.info
  }) :
    variableNameController = TextEditingController(text: variableName ?? ''),
    rangeController = TextEditingController(text: range ?? ''),
    dataTypeController = TextEditingController(text: dataType ?? '');




}