abstract class DataCollectionEvent {}

class DataCollectionInitial extends DataCollectionEvent {
  DataCollectionInitial();
}

class LoadDataCollectionMonthlyTemplateEvent extends DataCollectionEvent {
  
}

class LoadDataCollectionWorkplanTemplateEvent extends DataCollectionEvent{}

class LoadSelectedDataCollectionTemplateEvent extends DataCollectionEvent {}

class AddDataFromDataCollectionEvent extends DataCollectionEvent {
  Map<String,String> data;
  String? updateId;
  AddDataFromDataCollectionEvent({required this.data,this.updateId});
}

class EditDataCollectionEvent extends DataCollectionEvent {
  List<dynamic> data;
  EditDataCollectionEvent({required this.data});
}