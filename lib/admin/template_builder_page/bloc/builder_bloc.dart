
import 'package:activity_guide/admin/template_builder_page/bloc/builder_bloc_state.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/rowdata_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'builder_bloc_event.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BuilderBloc extends Bloc<BuilderEvent, BuilderState> {
  BuilderBloc() : super(BuilderState.initial()) {

    on<AddRowEvent>((event, emit) {
      if (event.id != null) {
         int index =event.id!;
        RowData updatData =  state.rows[index];
        updatData.columnName = event.columnName!;
        updatData.dataType = event.dataType!;
        updatData.range = event.range!;
        state.rows[index] = updatData;
      emit(state.currentData(rows: List.from(state.rows)));
      } else {
         int index =state.rows.length + 1;
      final newRow = RowData(id: index, columnName: event.columnName!, 
      dataType: event.dataType!, range: event.range!);
      emit(state.currentData(rows: List.from(state.rows)..add(newRow)));
      }
    });

    on<RemoveRowEvent>((event, emit) {
      List<RowData> data = state.rows;
     data.isEmpty ?
      EasyLoading.showError('Empty List')
      : emit(state.currentData(rows: List.from(data)..removeAt(event.index!)));
    });

    on<PartialSaveEvent>((event, emit) {
      print(state.rows);
      List<String> jsonObject = [];
      if(state.rows.isEmpty){
        EasyLoading.showError('No records to save');
        return;
      }
     
      for (var row in state.rows) {
        String name = row.columnName;
        String type = row.dataType;
        String range = row.range;

        if (type == 'Dropdown') {
          range = '$range';
        }

        String data = '{"ID": ${row.id},"name": "$name","Type": "$type","Range": "$range"}';
        jsonObject.add(data);
      }

     const FlutterSecureStorage().write(key: BuilderKeys.template, value: jsonObject.toString());
      EasyLoading.showSuccess('Success!');
      
      emit(state.currentData(jsonObject: jsonObject));
      
    });

    on<ReorderEvent>((event, emit) {
      int newIndex = event.newIndex!;
      int oldIndex = event.oldIndex!;
      List<RowData> data = state.rows;
      if (newIndex > oldIndex) newIndex -= 1;
    final row = data.removeAt(oldIndex);
    data.insert(newIndex, row);
    emit(state.currentData(rows: data ));
    });

    on<UpdatedRowEvent>((event, emit) {
      // TODO: implement event handler
      List<RowData> data = state.rows;
      data[event.index!] = event.updatedRow!;
      emit(state.currentData(rows: data));
    });

    on<SelectDataTypeEvent>((event, emit) {
      emit(state.currentData(selectDataType: event.selectDataType));
    });

  }
 
}