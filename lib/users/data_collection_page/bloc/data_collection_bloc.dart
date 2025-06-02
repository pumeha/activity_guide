import 'dart:convert';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:bloc/bloc.dart';
import 'data_collection_event.dart';
import 'data_collection_state.dart';

class DataCollectionBloc
    extends Bloc<DataCollectionEvent, DataCollectionState> {
  DataCollectionBloc() : super(DataCollectionStateInitial()) {
    on<LoadDataCollectionMonthlyTemplateEvent>((event, emit) async {
      emit(DataCollectionStateLoading());
      await Future.wait([
        MysharedPreference().clearPreference(dataCollectionKey),
        MysharedPreference().setPreferences(selectedTemplate, 'monthly'),
        MysharedPreference().setPreferencesWithoutEncrpytion(
            BuilderKeys.workingtemplate, 'Monthly Template')
      ]);

      String? monthlyTemplate =
          await MysharedPreference().getPreferences(monthlyTemplateKey);
      if (monthlyTemplate != null && monthlyTemplate.isNotEmpty) {
        final monthlyTemplateList =
            jsonDecode(monthlyTemplate) as List<dynamic>;
        emit(DataCollectionStateSuccess(
            dataList: monthlyTemplateList, templateType: 'Monthly Template'));
      } else {
        emit(DataCollectionStateFailure(
            errorMessage: 'Monthly template not created'));
      }
    });

    on<LoadDataCollectionWorkplanTemplateEvent>((event, emit) async {
      emit(DataCollectionStateLoading());

      await Future.wait([
        MysharedPreference().clearPreference(dataCollectionKey),
        MysharedPreference().setPreferences(selectedTemplate, 'workplan'),
        MysharedPreference().setPreferencesWithoutEncrpytion(
            BuilderKeys.workingtemplate, 'Workplan Template')
      ]);

      String? workplanTemplate =
          await MysharedPreference().getPreferences(workplanTemplateKey);
      if (workplanTemplate != null && workplanTemplate.isNotEmpty) {
        final workplanTemplateList =
            jsonDecode(workplanTemplate) as List<dynamic>;
        emit(DataCollectionStateSuccess(
            dataList: workplanTemplateList, templateType: 'Workplan Template'));
      } else {
        emit(DataCollectionStateFailure(
            errorMessage: 'Workplan template not created'));
      }
    });

    on<LoadSelectedDataCollectionTemplateEvent>((event, emit) async {
      emit(DataCollectionStateLoading());

      String? template =
          await MysharedPreference().getPreferences(selectedTemplate);
      if (template != null && template.isNotEmpty) {
        if (template == 'monthly') {
          String? monthlyTemplate =
              await MysharedPreference().getPreferences(monthlyTemplateKey);
          if (monthlyTemplate != null && monthlyTemplate.isNotEmpty) {
            final monthlyTemplateList =
                jsonDecode(monthlyTemplate) as List<dynamic>;
            emit(DataCollectionStateSuccess(
                dataList: monthlyTemplateList,
                templateType: 'Monthly Template'));
          } else {
            emit(DataCollectionStateFailure(
                errorMessage: 'Monthly template not created'));
          }
        } else {
          String? workplanTemplate =
              await MysharedPreference().getPreferences(workplanTemplateKey);
          if (workplanTemplate != null && workplanTemplate.isNotEmpty) {
            final workplanTemplateList =
                jsonDecode(workplanTemplate) as List<dynamic>;
            emit(DataCollectionStateSuccess(
                dataList: workplanTemplateList,
                templateType: 'Workplan Template'));
          } else {
            emit(DataCollectionStateFailure(
                errorMessage: 'Workplan template not created'));
          }
        }
      }
    });

    on<AddDataFromDataCollectionEvent>((event, emit) async {
      List<dynamic> list = [];
      Map<String, String> newData = {};
      String? editId = event.updateId;

      String? previousData = await MysharedPreference()
          .getPreferencesWithoutEncrpytion(dataCollectionKey);

      if (previousData != null && previousData.isNotEmpty) {
        list = jsonDecode(previousData);
        if ((editId != null && editId.isNotEmpty)) {
          newData['ID'] = editId;
          newData.addAll(event.data);
          list[int.parse(editId) - 1] = newData;
        } else {
          newData['ID'] = (list.length + 1).toString();
          newData.addAll(event.data);
          list.add(newData);
        }
      } else {
        newData['ID'] = '1'; // adding
        newData.addAll(event.data);
        list.add(newData);
      }

      await MysharedPreference()
          .setPreferencesWithoutEncrpytion(dataCollectionKey, jsonEncode(list));
    });

    on<DataCollectionEditEvent>((event, emit) async {
      String? templateType = await MysharedPreference()
          .getPreferencesWithoutEncrpytion(BuilderKeys.workingtemplate);
      emit(DataCollectionEditState(
          editData: event.data,
          templatData: state.data,
          templateType: templateType));
    });
  }
}
