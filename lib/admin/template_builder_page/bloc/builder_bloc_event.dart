import 'package:activity_guide/shared/utils/rowdata_model.dart';

abstract class  BuilderEvent {
  
}
class AddRowEvent extends BuilderEvent {
 final int? id;
 final String? columnName,range,dataType;

 AddRowEvent({this.id,this.columnName,this.range,this.dataType});
}
class RemoveRowEvent extends BuilderEvent {
  final int? index;
  RemoveRowEvent({this.index});
  
}
class PartialSaveEvent extends BuilderEvent {
  
}
class ReorderEvent extends BuilderEvent {
 final int? oldIndex,newIndex;
  ReorderEvent({this.oldIndex,this.newIndex});
}
class UpdatedRowEvent extends BuilderEvent {
 final int? index;
 final RowData? updatedRow;
  UpdatedRowEvent({this.index,this.updatedRow});
}

class  SelectDataTypeEvent extends BuilderEvent {
  final String? selectDataType;
  SelectDataTypeEvent({this.selectDataType});
 
}