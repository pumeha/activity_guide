import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc_state.dart';
import 'package:activity_guide/shared/utils/rowdata_model.dart';
import 'package:bloc/bloc.dart';
import '../../../shared/utils/http_helper/storage_keys.dart';
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

   on<ClearBuilderDataEvent>((event, emit) {
    emit(state.currentData(rows: [],jsonObject: [],selectDataType: ''));
   });
    /**
     * return List<RowData>, templateName(SelectDataType)
     */
   on<EditTemplateEvent>((event, emit) async{
    String purpose = event.templateName.split('_')[0];
    String? workingTemplate;
    if (purpose == 'atemplate') {
      workingTemplate = 'Editing Additional Template';
    }else if(purpose == 'wtemplate'){
      workingTemplate = 'Editing Workplan Template';
    }else if(purpose == 'mtemplate'){
        workingTemplate = 'Editing Monthly Template';
    }
  
   await Future.wait([
           MysharedPreference().setPreferences(BuilderKeys.purpose, purpose),
    MysharedPreference().setPreferences('templateName',event.templateName),
    MysharedPreference().setPreferencesWithoutEncrpytion(BuilderKeys.workingtemplate, workingTemplate!)
      ]);

    emit(state.currentData(rows: event.rows,selectDataType: 'update'));
   });

  }
 
}