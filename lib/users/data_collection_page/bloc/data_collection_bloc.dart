import 'dart:convert';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/shared/utils/output_metric_json.dart';
import 'package:bloc/bloc.dart';
import 'data_collection_event.dart';
import 'data_collection_state.dart';

class DataCollectionBloc extends Bloc<DataCollectionEvent, DataCollectionState> {

  DataCollectionBloc() : super(DataCollectionStateInitial()) {

    on<LoadDataCollectionMonthlyTemplateEvent>((event, emit) async {
      emit(DataCollectionStateLoading());

      String? _outputMetric =
      await MysharedPreference().getPreferencesWithoutEncrpytion(outputAndMetric);

      if (_outputMetric != null && _outputMetric.isNotEmpty) {
        final _data = jsonDecode(_outputMetric) as List<dynamic>;

        List<OutputMetricJson> filtered = _data.map((e)=>OutputMetricJson.fromJson(e)).toList();
        filtered = filtered.where((e){
          return (e.monthValue!.isNotEmpty && !(e.monthValue!.startsWith('0')));
        }).toList();

        if(filtered.isEmpty){
          emit(DataCollectionStateFailure(errorMessage: 'No Active Monthly Outputs'));
         return;
        }

        await Future.wait([
          MysharedPreference().clearPreference(dataCollectionKey),
          MysharedPreference().setPreferences(selectedTemplate, 'monthly'),
          MysharedPreference().setPreferencesWithoutEncrpytion(BuilderKeys.workingtemplate, 'Monthly Template')
        ]);

        String? monthlyTemplate =
        await MysharedPreference().getPreferences(monthlyTemplateKey);

        if (monthlyTemplate != null && monthlyTemplate.isNotEmpty) {
          final monthlyTemplateList =
          jsonDecode(monthlyTemplate) as List<dynamic>;
          emit(DataCollectionStateSuccess(
              dataList: monthlyTemplateList, templateType: 'Monthly Template',outputMetric: filtered));
          return;
        }else{
          emit(DataCollectionStateFailure(errorMessage: 'Monthly template not created'));
          return;
        }

      }else{
        emit(DataCollectionStateFailure(errorMessage: 'No Active Monthly Outputs'));
        return;
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
        print(workplanTemplateList);
        emit(DataCollectionStateSuccess(
            dataList: workplanTemplateList, templateType: 'Workplan Template'));
      } else {
        emit(DataCollectionStateFailure(
            errorMessage: 'Workplan template not created'));
      }
    });

    on<LoadDataCollectionAdditionalTemplateEvent>((event,emit) async{
        emit(DataCollectionStateLoading());

        await Future.wait([
          MysharedPreference().clearPreference(dataCollectionKey),
          MysharedPreference().setPreferences(selectedTemplate, 'additional'),
          MysharedPreference().setPreferencesWithoutEncrpytion(
              BuilderKeys.workingtemplate, event.displayName),
          MysharedPreference().setPreferences(additionalTemplateName, event.displayName),
          MysharedPreference().setPreferences(additionalTemplateKey, jsonEncode(event.data))
        ]);

        if(event.data.isNotEmpty){
          emit(DataCollectionStateSuccess(dataList: event.data, templateType: event.displayName));
        }else{
          emit(DataCollectionStateFailure(errorMessage: 'Additional Template found'));
        }


    });

    on<LoadSelectedDataCollectionTemplateEvent>((event, emit) async {
      emit(DataCollectionStateLoading());
      //TODO updating the code below for additional template
      String? template =
          await MysharedPreference().getPreferences(selectedTemplate);
      if (template != null && template.isNotEmpty) {
        String? activeTemplate;
        if (template == 'monthly') {
          activeTemplate =
          await MysharedPreference().getPreferences(monthlyTemplateKey);
        }else if(template == 'workplan'){
          activeTemplate = await MysharedPreference().getPreferences(workplanTemplateKey);
        }else if(template == 'additional'){
          activeTemplate = await MysharedPreference().getPreferences(additionalTemplateKey);
        }
          if (activeTemplate != null && activeTemplate.isNotEmpty) {
            final templateList =
                jsonDecode(activeTemplate) as List<dynamic>;
            String templateType = template + 'template';
            emit(DataCollectionStateSuccess(
                dataList: templateList,
                templateType: templateType));
          } else {
            emit(DataCollectionStateFailure(
                errorMessage: '$template template not created'));
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
