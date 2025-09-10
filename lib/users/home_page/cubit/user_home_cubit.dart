import 'dart:convert';
import 'dart:io';

import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/users/home_page/repo/user_home_impl.dart';
import 'package:bloc/bloc.dart';
import 'user_home_state.dart';

class UserHomeCubit extends Cubit<UserHomeState> {
  UserHomeImpl userHomeImpl;

  UserHomeCubit(this.userHomeImpl) : super(UserHomeInitial());

  Future<void> downloadData({required String templateType}) async {
    emit(UserHomeLoading());

    bool onlineOrOffline = isDeviceOffline();
    if (!onlineOrOffline) {
      emit(UserHomeFailure(message: 'No internet connection'));
      return;
    }

    String? token = await MysharedPreference().getPreferences(LoginKeys.token);
    if (token == null || token.isEmpty) {
      return emit(UserHomeFailure(message: 'Unauthorized user'));
    }
    String? template;
    if (templateType == 'Monthly') {
      template = await MysharedPreference().getPreferences(monthlyTemplateName);
    } else if (templateType == 'Workplan') {
      template =
          await MysharedPreference().getPreferences(workplanTemplateName);
    } else {
      template = templateType;
    }

    if (template == null || template.isEmpty) {
      return emit(
          UserHomeFailure(message: '$templateType template not created'));
    }
    final response = await userHomeImpl.fetchTemplateData(
        token: token, templateName: template);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);

    if (data.status == HttpStatus.ok) {
      if (data.data == null || data.data!.isEmpty) {
        return emit(UserHomeFailure(message: 'No record found'));
      }
      await MysharedPreference().setPreferencesWithoutEncrpytion(
          template_data, jsonEncode(data.data!));
      return emit(UserHomeSuccess(message: 'Data downloaded'));
    } else {
      return emit(UserHomeFailure(message: data.message));
    }
  }

  Future<void> fetchMonthlyTemplateData() async {
    emit(UserHomeLoading());

    bool onlineOrOffline = isDeviceOffline();
    if (!onlineOrOffline) {
      emit(UserHomeFailure(message: 'No internet connection'));
      return;
    }

    String? token = await MysharedPreference().getPreferences(LoginKeys.token);
    if (token == null || token.isEmpty) {
      return emit(UserHomeFailure(message: 'Unauthorized user'));
    }
    final response = await userHomeImpl.fetchMonthlyTemplateData(
        token: token);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);

    if (data.status == HttpStatus.ok) {
      if (data.data == null || data.data!.isEmpty) {
        return emit(UserHomeFailure(message: 'No record found'));
      }
      print( jsonEncode(data.data!));
      // await MysharedPreference().setPreferencesWithoutEncrpytion(
      //     template_data, jsonEncode(data.data!));
      return emit(UserHomeSuccess(message: 'Data downloaded'));
    } else {
      return emit(UserHomeFailure(message: data.message));
    }

  }

}