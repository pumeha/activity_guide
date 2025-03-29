import 'dart:convert';

import 'package:activity_guide/authentication/repository/auth_repository_abstract.dart';
import 'package:activity_guide/shared/utils/api_routes.dart';
import 'package:activity_guide/shared/utils/http%20handler/http_handler_impl.dart';

class AuthRepositoryImpl extends AuthRepositoryAbstract {
  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async{
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Map<String,dynamic>> login(String email, String password) async{
    // TODO: implement login

    dynamic body = jsonEncode({"email":email,"password":password});
    Map<String,String> header = {'Content-Type' : 'application/json'};

    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: ApiRoutes.loginRoute, body: body,header: header);
    
   return response;
  }

  @override
  Future<Map<String, dynamic>> resetPassword(String email, String token, String newPassword) async{
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
  
}