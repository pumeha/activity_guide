import 'dart:convert';
import 'dart:io';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_event.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_state.dart';
import 'package:activity_guide/sub_admin/template_list_page/repository/template_repo_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../shared/utils/http_helper/storage_keys.dart';
import '../../../shared/utils/myshared_preference.dart';

class TemplateBloc extends Bloc<TemplateEvent,TemplateState>{
  TemplateRepoImpl repoImpl;
  TemplateBloc(this.repoImpl) :super(TemplateInitialState()){

      on<UploadEvent>((event, emit) async{
       
      List<String> jsonObject = [];
      
      if(event.rows.isEmpty){
        EasyLoading.showError('No records to save');
        return;
      }

      bool onlineOrOffline = isDeviceOffline_Return_False();
      if (!onlineOrOffline) {
        emit(TemplateFailureState(message: 'No internet connection')); return;
      }
     
      for (var row in event.rows) {
        String name = row.columnName;
        String type = row.dataType;
        String range = row.range;

        if (type == 'Dropdown') {
          range = '$range';
        }

        String data = '{"ID": ${row.id},"name": "$name","Type": "$type","Range": "$range"}';
        jsonObject.add(data);
      }


      
      String? token = await MysharedPreference().getPreferences(LoginKeys.token);
      if (token == null || token.isEmpty) {
        emit(TemplateFailureState(message: unauthorizedUser));
        return;
      }
      
      String? purpose = await MysharedPreference().getPreferences(BuilderKeys.purpose);
      if (purpose == null || purpose.isEmpty) {
        emit(TemplateFailureState(message: 'purpose required'));
        return;
      }
      emit(TemplateLoadingState());
      dynamic response = await repoImpl.uploadTemplate(name: templateName(purpose), value: jsonObject.toString(),
                         purpose: purpose, token: token);
      GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);
      
      if (jsonDart.status == HttpStatus.created) {
        
          String data = jsonEncode(jsonDart.data!);
          await MysharedPreference().setPreferences(templateListKeys, data);
       
          emit(TemplateSuccessState(message: jsonDart.message!));
      }else{
        emit(TemplateFailureState(message: jsonDart.message!));
      }      
    
      });

    on<TemplatePurposeEvent>((event, emit) async{
    await  MysharedPreference().setPreferences(BuilderKeys.purpose, event.purpose);
    });
    
    on<TemplateSelectedEvent>((event, emit) {
     emit(TemplateSelectedState(model: event.model));
    });
  
    on<UpdateEvent>((event, emit) async{
         
      List<String> jsonObject = [];
      if(event.rows.isEmpty){
        EasyLoading.showError('No changes to made');
        return;
      }

      bool onlineOrOffline =  isDeviceOffline_Return_False();
      if (!onlineOrOffline) {
        emit(TemplateFailureState(message: 'No internet connection')); return;
      }
     
      for (var row in event.rows) {
        String name = row.columnName;
        String type = row.dataType;
        String range = row.range;

        if (type == 'Dropdown') {
          range = '$range';
        }

        String data = '{"ID": ${row.id},"name": "$name","Type": "$type","Range": "$range"}';
        jsonObject.add(data);
      }

      String? token = await MysharedPreference().getPreferences(LoginKeys.token);
      if (token == null || token.isEmpty) {
        emit(TemplateFailureState(message: unauthorizedUser));
        return;
      }

      String? templateName = await MysharedPreference().getPreferences('templateName');
      if (templateName == null || templateName.isEmpty) {
        emit(TemplateFailureState(message: 'Template Name is required'));
      }
      emit(TemplateLoadingState());
      dynamic response = await repoImpl.updateTemplate(name: templateName!, values: jsonObject.toString(),
                         token: token);
      GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);
      
      if (jsonDart.status == HttpStatus.ok) {
        
          String data = jsonEncode(jsonDart.data!);
          await MysharedPreference().setPreferences(templateListKeys, data);
       
          emit(TemplateSuccessState(message: jsonDart.message!));
      }else{
        emit(TemplateFailureState(message: jsonDart.message!));
      }      
    
    });

    on<TemplateDeleteEvent>((event, emit) async{
      
      emit(TemplateLoadingState());

      bool onlineOrOffline =  isDeviceOffline_Return_False();
      if (!onlineOrOffline) {
        emit(TemplateFailureState(message: 'No internet connection')); return;
      }

      String? token = await MysharedPreference().getPreferences(LoginKeys.token);
      if (token == null || token.isEmpty) {
        emit(TemplateFailureState(message: unauthorizedUser));
        return;
      }

      
      dynamic response = await repoImpl.deleteTemplate(name: event.templateName, token: token);
      GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);
     
      if (jsonDart.status == HttpStatus.ok) {
        
          String data = jsonEncode(jsonDart.data ?? []) ;
          await MysharedPreference().setPreferences(templateListKeys, data);
       
          emit(TemplateSuccessState(message: jsonDart.message!));
      }else{
        emit(TemplateFailureState(message: jsonDart.message!));
      }   

    });

    on<TemplateActiveOrInactiveEvent>((event, emit) async{
      emit(TemplateLoadingState());

      bool onlineOrOffline = isDeviceOffline_Return_False();
      if (!onlineOrOffline) {
        emit(TemplateFailureState(message: 'No internet connection')); return;
      }

       String? token = await MysharedPreference().getPreferences(LoginKeys.token);
          if (token == null || token.isEmpty) {
            emit(TemplateFailureState(message: unauthorizedUser));
            return;
          }

      dynamic response = await repoImpl.activeTemplate(name: event.templateName, status: event.status, token: token);
      GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);
      
      if (jsonDart.status == HttpStatus.ok || jsonDart.status == HttpStatus.created) {
        String data = jsonEncode(jsonDart.data ?? []);
        await MysharedPreference().setPreferences(templateListKeys, data);
        emit(TemplateSuccessState(message: jsonDart.message!));
      }else{
        emit(TemplateFailureState(message: jsonDart.message!));
      }

    });

    on<TemplateFetchDataEvent>((event, emit) async{
        emit(TemplateLoadingState());

      bool onlineOrOffline =  isDeviceOffline_Return_False();
      if (!onlineOrOffline) {
        emit(TemplateFailureState(message: 'No internet connection')); return;
      }

       String? token = await MysharedPreference().getPreferences(LoginKeys.token);
          if (token == null || token.isEmpty) {
            emit(TemplateFailureState(message: unauthorizedUser));
            return;
          }
   
       dynamic response = await repoImpl.fetchTemplateData(name: event.templateName, token: token);
       
       GeneralJsonDart jsonDart = GeneralJsonDart.fromJson(response);
       if (jsonDart.status == HttpStatus.ok) {

            if(jsonDart.data!.isEmpty) {
              emit(TemplateSuccessState(message: 'No records yet'));
            }else{
        String data = jsonEncode(jsonDart.data);
        await MysharedPreference().setPreferences(template_data, data);
        emit(TemplateSuccessState(message: 'data'));
        }
        
       }else{
        emit(TemplateFailureState(message: jsonDart.message!));
       }

    });
  }
  
}
