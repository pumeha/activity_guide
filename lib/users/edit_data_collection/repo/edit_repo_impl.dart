import 'dart:convert';
import 'package:activity_guide/shared/utils/http_helper/http_handler_impl.dart';
import 'package:activity_guide/users/edit_data_collection/repo/edit_repo_abstr.dart';

class EditRepoImpl extends EditRepoAbstr {
  @override
  Future<Map<String, dynamic>> upload({required String url, required String templateName,
    required List data,required String token}) async{

    dynamic body = jsonEncode({'data':data,'template_name':templateName});
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: url, body: body,token: token);

    return response;
  }

  
}