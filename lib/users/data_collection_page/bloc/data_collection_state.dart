import 'package:activity_guide/shared/utils/output_metric_json.dart';

abstract class DataCollectionState {
  List<dynamic>? data;
  String? templateType;
  List<OutputMetricJson>? outputMetric;
  DataCollectionState({this.data,this.templateType,this.outputMetric});
}

class DataCollectionStateInitial extends DataCollectionState {
  
}

class DataCollectionStateLoading extends DataCollectionState {
  
}

class DataCollectionStateSuccess extends DataCollectionState{
 String? templateType;
  List<dynamic>? dataList;
 List<OutputMetricJson>? outputMetric;
  DataCollectionStateSuccess({required this.dataList,
  required this.templateType, this.outputMetric}) : super(data: dataList,templateType: templateType,outputMetric: outputMetric);
}

class DataCollectionStateFailure extends DataCollectionState {
  String errorMessage;
  DataCollectionStateFailure({required this.errorMessage}) : super();
}

class DataCollectionSuccess extends DataCollectionState {
  String message;
  DataCollectionSuccess({required this.message});
}

class DataCollectionEditState extends DataCollectionState {
  String? templateType;
  List<dynamic> editData;
  List<dynamic>? templatData;
  DataCollectionEditState({required this.editData, required templatData,required this.templateType}) :super(data: templatData);
}

