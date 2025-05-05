abstract class EditDataCollectionEvent {}

class EditInitail extends EditDataCollectionEvent{}

class DeleteDataRow extends EditDataCollectionEvent {
  List<dynamic> data;
  DeleteDataRow({required this.data});
}

class EditDataEvent extends EditDataCollectionEvent {
  List<dynamic> data;
  EditDataEvent({required this.data});
}

class UploadDataEvent extends EditDataCollectionEvent {
  List<dynamic> data;
  UploadDataEvent({required this.data});
}