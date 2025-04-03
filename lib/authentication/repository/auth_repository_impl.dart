import 'dart:convert';

import 'package:activity_guide/authentication/repository/auth_repository_abstract.dart';
import 'package:activity_guide/shared/utils/api_routes.dart';
import 'package:activity_guide/shared/utils/http_helper/http_handler_impl.dart';

class AuthRepositoryImpl extends AuthRepositoryAbstract {
  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async{
    // TODO: implement forgotPassword
   
    dynamic body = jsonEncode({"email":email});

    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: LoginRoutes.forgetPassword, body: body);
    return response;

  }

  @override
  Future<Map<String,dynamic>> login(String email, String password) async{
    // TODO: implement login

    dynamic body = jsonEncode({"email":email,"password":password});

   Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: LoginRoutes.loginRoute, body: body);
   return response;

  }

  @override
  Future<Map<String, dynamic>> resetPassword(String inputCode, String newPassword,String token) async{
    // TODO: implement resetPassword
    dynamic body = jsonEncode({"inputCode":inputCode,"password":newPassword});

    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: LoginRoutes.verify, body: body,token: token);
    return response;
    
  }
  
  @override
  Future<Map<String, dynamic>> userVerification(String inputCode, String token) async{
    // TODO: implement userVerification
    dynamic body = jsonEncode({"inputCode":inputCode});

    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: LoginRoutes.verify, body: body,token: token);
    return response;
  }
  
  @override
  Future<Map<String, dynamic>> requestTokenAgain(String token) async{
    // TODO: implement requestTokenAgain
      dynamic body = jsonEncode({});
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: LoginRoutes.verify, body: body,token: token);
    return response;
  }
  
}