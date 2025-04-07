import 'dart:convert';

import 'package:activity_guide/admin/dashboard_page/repository/dashboard_repository_abstr.dart';
import 'package:activity_guide/shared/utils/api_routes.dart';
import 'package:activity_guide/shared/utils/http_helper/http_handler_impl.dart';

class DashboardRepositoryImpl extends DashboardRepositoryAbstr {
  @override
  Future<Map<String, dynamic>> updateDashboardUrl({String? url, String? token}) async {

   dynamic body = jsonEncode({"link":url});
   Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: TemplateRoutes.dashboard,
    body: body,token: token);
    return response;

  }
  
}