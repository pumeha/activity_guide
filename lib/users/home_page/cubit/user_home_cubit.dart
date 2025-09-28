import 'dart:convert';
import 'dart:io';

import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/shared/utils/output_metric_json.dart';
import 'package:activity_guide/users/dashboard_page/dashboard_output_metric.dart';
import 'package:activity_guide/users/dashboard_page/monthly_j2d.dart';
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
      final List<MonthlyJ2D> _monthlyRawdata = data.data!.map((e)=> MonthlyJ2D.fromJson(e)).toList();

      return emit(UserHomeSuccess(message: 'Data downloaded', data: _monthlyRawdata));
    } else {
      return emit(UserHomeFailure(message: data.message));
    }
  }

  Future<void> downloadDashboardData({required String templateType}) async {
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
    final response = await userHomeImpl.fetchDashboardData(
        token: token, templateName: template);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);

    if (data.status == HttpStatus.ok) {
      if (data.data == null || data.data!.isEmpty) {
        return emit(UserHomeFailure(message: 'No record found'));
      }
      List? _data = data.data;
      List<dynamic> _monthly = _data![0];
      List<dynamic> _output = _data[1];


    final List<MonthlyJ2D> _monthlyRawdata = _monthly.map((e)=> MonthlyJ2D.fromJson(e)).toList();
      final rawList = _output.map((e){
        return Map<String, dynamic>.from(e);
      }).toList();
    final List<DashboardOutputMetric> _outputMetric = processRawData(rawList);
      return emit(UserHomeSuccess(message: 'Data downloaded', data: [_monthlyRawdata,_outputMetric]));
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

    final response = await userHomeImpl.fetchMonthlyTemplateData(token: token);

    GeneralJsonDart data = GeneralJsonDart.fromJson(response);

    if (data.status == HttpStatus.ok) {
      if (data.data == null || data.data!.isEmpty) {
        return emit(UserHomeFailure(message: 'No record found'));
      }

      await MysharedPreference().setPreferencesWithoutEncrpytion(
          outputAndMetric, jsonEncode(data.data!));

      return emit(UserHomeSuccess(message: 'MonthlyTemplateData',data: []));
    } else {
      return emit(UserHomeFailure(message: data.message));
    }

  }

}