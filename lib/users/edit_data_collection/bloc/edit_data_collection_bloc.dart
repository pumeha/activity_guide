import 'dart:convert';
import 'dart:io';

import 'package:activity_guide/shared/utils/api_routes.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/users/edit_data_collection/repo/edit_repo_impl.dart';
import 'package:bloc/bloc.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/myshared_preference.dart';
import 'edit_data_collection_event.dart';
import 'edit_data_collection_state.dart';

class EditDataCollectionBloc
    extends Bloc<EditDataCollectionEvent, EditDataCollectionState> {
  EditRepoImpl impl;
  EditDataCollectionBloc(this.impl) : super(EditInitailState()) {
    on<DeleteDataRow>((event, emit) async {
      emit(EditSuccessState());
    });

    on<UploadDataEvent>((event, emit) async {
      emit(EditLoadingState());

      bool onlineOrOffline = isDeviceOffline();
      if (!onlineOrOffline) {
        emit(EditFailureState(message: 'No internet connection'));
        return;
      }
      String? templateName;
      String? _selectedTemplate =
          await MysharedPreference().getPreferences(selectedTemplate);

      if(_selectedTemplate != null && _selectedTemplate.isNotEmpty){
        if(_selectedTemplate == 'monthly'){
          templateName =await MysharedPreference().getPreferences(monthlyTemplateName);

        }else if(_selectedTemplate == 'workplan'){
          templateName =  await MysharedPreference().getPreferences(workplanTemplateName);
        }else if(_selectedTemplate == 'additional'){
          templateName =  await MysharedPreference().getPreferences(additionalTemplateName);

        }
      }else{
        emit(EditFailureState(message: 'Template not found'));
        return;
      }


      for (var element in event.data) {
        element.remove('ID');
      }

      if (event.data.isEmpty) {
        emit(EditFailureState(message: 'No data to upload'));
        return;
      }

      String? token =
          await MysharedPreference().getPreferences(LoginKeys.token);
      if (token == null || token.isEmpty) {
        emit(EditFailureState(message: 'Unauthorized User'));
        return;
      }

      if (_selectedTemplate != 'workplan' &&
          templateName != null &&
          templateName.isNotEmpty) {
        final response = await impl.upload(
            url: TemplateRoutes.uploadTemplateData,
            templateName: templateName,
            data: event.data,
            token: token);

        GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);

        if (jsonDart.status == HttpStatus.created ||
            jsonDart.status == HttpStatus.ok) {
          await MysharedPreference()
              .setPreferencesWithoutEncrpytion(dataCollectionKey, '');
          return emit(EditSuccessState());
        } else {
          return emit(EditFailureState(message: jsonDart.message!));
        }
      } else if (
          _selectedTemplate == 'workplan' &&
          templateName != null &&
          templateName.isNotEmpty) {
        final response = await impl.upload(
            url: TemplateRoutes.uploadTemplateData,
            templateName: templateName,
            data: event.data,
            token: token);

        GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);
        if (jsonDart.status == HttpStatus.created ||
            jsonDart.status == HttpStatus.ok) {

          String monthlyTempleJsonString;

          if (jsonDart.data != null ) {
            final monthlyTempleJson = jsonDart.data as List<dynamic>;

            if (monthlyTempleJson.isNotEmpty) {
              monthlyTempleJsonString = jsonEncode(monthlyTempleJson.toList());


            await  MysharedPreference().setPreferences(monthlyTemplateKey,monthlyTempleJsonString );

            }
          }
          return emit(EditSuccessState());
        } else {
          return emit(EditFailureState(message: jsonDart.message!));
        }
      }
    });
  }
}
