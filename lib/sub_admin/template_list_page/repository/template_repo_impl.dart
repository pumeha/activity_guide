import 'dart:convert';

import 'package:activity_guide/shared/utils/http_helper/http_handler_impl.dart';
import 'package:activity_guide/sub_admin/template_list_page/repository/template_repo_abstr.dart';

import '../../../shared/utils/api_routes.dart';

class TemplateRepoImpl extends TemplateRepoAbstr {
  @override
  Future<Map<String, dynamic>> uploadTemplate(
      {required String name,
      required String value,
      required String purpose,
      required String token,
      required String displayName}) async {
    dynamic data = {
      'template_name': name,
      'values': value,
      'purpose': purpose,
      'display_name': displayName
    };
    dynamic body = jsonEncode(data);

    Map<String, dynamic> response = await HttpHandlerImpl.instance
        .post(url: TemplateRoutes.createTemplate, body: body, token: token);
    return response;
  }

  @override
  Future<Map<String, dynamic>> updateTemplate(
      {required String name,
      required String values,
      required String token,
      String? displayName}) async {
    dynamic data = {
      'template_name': name,
      'values': values,
      'display_name': displayName
    };
    dynamic body = jsonEncode(data);

    Map<String, dynamic> response = await HttpHandlerImpl.instance
        .post(url: TemplateRoutes.updateTemplate, body: body, token: token);

    return response;
  }

  @override
  Future<Map<String, dynamic>> deleteTemplate(
      {required String name, required String token}) async {
    dynamic data = {'template_name': name};
    dynamic body = jsonEncode(data);

    Map<String, dynamic> response = await HttpHandlerImpl.instance
        .delete(url: TemplateRoutes.deleteTemplate, token: token, body: body);

    return response;
  }

  @override
  Future<Map<String, dynamic>> activeTemplate(
      {required String name,
      required String status,
      required String token}) async {
    dynamic data = {'template_name': name, 'status': status};
    dynamic body = jsonEncode(data);

    Map<String, dynamic> response = await HttpHandlerImpl.instance
        .post(url: TemplateRoutes.templateActive, body: body, token: token);

    return response;
  }

  @override
  Future<Map<String, dynamic>> fetchTemplateData(
      {required String name, required String token}) async {
    dynamic data = {'template_name': name};
    dynamic body = jsonEncode(data);

    Map<String, dynamic> response = await HttpHandlerImpl.instance
        .post(url: TemplateRoutes.getTemplateData, token: token, body: body);

    return response;
  }
}
