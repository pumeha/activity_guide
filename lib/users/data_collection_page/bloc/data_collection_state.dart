abstract class DataCollectionState {
  List<dynamic>? data;
  String? templateType;
  DataCollectionState({this.data,this.templateType});
}

class DataCollectionStateInitial extends DataCollectionState {
  
}

class DataCollectionStateLoading extends DataCollectionState {
  
}

class DataCollectionStateSuccess extends DataCollectionState{
 String? templateType;
  List<dynamic>? dataList;
  DataCollectionStateSuccess({required this.dataList,
  required this.templateType}) : super(data: dataList,templateType: templateType);
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

