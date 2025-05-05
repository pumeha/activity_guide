abstract class DataCollectionState {
  List<dynamic>? data;
  DataCollectionState({this.data});
}

class DataCollectionStateInitial extends DataCollectionState {
  
}

class DataCollectionStateLoading extends DataCollectionState {
  
}

class DataCollectionStateSuccess extends DataCollectionState{

  List<dynamic>? dataList;
  DataCollectionStateSuccess({required this.dataList}) : super(data: dataList);
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
  List<dynamic> editData;
  List<dynamic>? templatData;
  DataCollectionEditState({required this.editData, required templatData}) :super(data: templatData);
}

