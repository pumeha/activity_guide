import 'dart:convert';
import 'package:beamer/beamer.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:bloc/bloc.dart';
import 'data_collection_event.dart';
import 'data_collection_state.dart';

class DataCollectionBloc extends Bloc<DataCollectionEvent, DataCollectionState> {

  DataCollectionBloc() : super(DataCollectionStateInitial()) {

    on<LoadDataCollectionMonthlyTemplateEvent>((event, emit) async{
      emit(DataCollectionStateLoading());
      await MysharedPreference().setPreferences(selectedTemplate, 'monthly');
      String? monthlyTemplate = await MysharedPreference().getPreferences(monthlyTemplateKey);
      if (monthlyTemplate != null && monthlyTemplate.isNotEmpty) {
        final monthlyTemplateList = jsonDecode(monthlyTemplate) as List<dynamic>;
        emit(DataCollectionStateSuccess(dataList: monthlyTemplateList));
      }else{
        emit(DataCollectionStateFailure(errorMessage: 'Monthly template not created'));
      }
    });

    on<LoadDataCollectionWorkplanTemplateEvent>((event, emit) async{
      await MysharedPreference().setPreferences(selectedTemplate, 'workplan');
      String? workplanTemplate = await MysharedPreference().getPreferences(workplanTemplateKey);
      if (workplanTemplate != null && workplanTemplate.isNotEmpty) {
        final workplanTemplateList = jsonDecode(workplanTemplate) as List<dynamic>;
        emit(DataCollectionStateSuccess(dataList: workplanTemplateList));
      }else{
        emit(DataCollectionStateFailure(errorMessage: 'Workplan template not created'));
      }
    });

    on<LoadSelectedDataCollectionTemplateEvent>((event, emit) async{
      String? template = await MysharedPreference().getPreferences(selectedTemplate);
      if (template != null && template.isNotEmpty) {
        if (template == 'monthly') {
            emit(DataCollectionStateLoading());
            await MysharedPreference().setPreferences(selectedTemplate, 'monthly');
            String? monthlyTemplate = await MysharedPreference().getPreferences(monthlyTemplateKey);
            if (monthlyTemplate != null && monthlyTemplate.isNotEmpty) {
              final monthlyTemplateList = jsonDecode(monthlyTemplate) as List<dynamic>;
              emit(DataCollectionStateSuccess(dataList: monthlyTemplateList));
            }else{
              emit(DataCollectionStateFailure(errorMessage: 'Monthly template not created'));
            }
      } else {
            String? workplanTemplate = await MysharedPreference().getPreferences(workplanTemplateKey);
            if (workplanTemplate != null && workplanTemplate.isNotEmpty) {
              final workplanTemplateList = jsonDecode(workplanTemplate) as List<dynamic>;
              emit(DataCollectionStateSuccess(dataList: workplanTemplateList));
            }else{
              emit(DataCollectionStateFailure(errorMessage: 'Workplan template not created'));
            }
      }
      }
    });

    on<AddDataFromDataCollectionEvent>((event, emit) async{
      List<dynamic> list = [];
      Map<String,String> newData  = {};
      String?  editId = event.updateId;       
     
       newData['ID'] = '1';// adding 
       newData.addAll(event.data);

        String? previousData = await MysharedPreference().getPreferencesWithoutEncrpytion(dataCollectionKey);
        if (previousData != null && previousData.isNotEmpty) {
          list = jsonDecode(previousData);
          if ((editId != null && editId.isNotEmpty)) {
             newData['ID'] =  editId ;
             list[int.parse(editId)] = newData;
          } else {
             newData['ID'] =  (list.length +1).toString();
          list.add(newData);
          }
         
        } else {
          list.add(newData);
        }
      await MysharedPreference().setPreferencesWithoutEncrpytion(dataCollectionKey, jsonEncode(list));
    });

    on<EditDataCollectionEvent>((event, emit) {
      
      emit(DataCollectionEditState(editData: event.data,templatData: state.data));
    });
    
  }

}