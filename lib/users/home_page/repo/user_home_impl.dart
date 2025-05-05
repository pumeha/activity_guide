import 'dart:convert';
import 'package:activity_guide/shared/utils/http_helper/http_handler_impl.dart';
import '../../../shared/utils/api_routes.dart';
import 'user_home_abstr.dart';

class UserHomeImpl extends UserHomeAbstr {

  @override
  Future<Map<String, dynamic>> fetchTemplateData({required String token,required String templateName}) async{
    dynamic body = jsonEncode({'template_name':templateName});
    final response = await HttpHandlerImpl.instance.post(url: TemplateRoutes.fetchData, body: body,token: token);
    return response;
  }

  
}