import 'package:activity_guide/shared/utils/http_helper/http_handler_impl.dart';
import '../../shared/utils/api_routes.dart';
import 'dart:convert';
import '../json2dart/user_json_dart.dart';
import 'users_repo_abstract.dart';

class UsersRepoImpl extends UsersRepoAbstract {

  @override
  Future<Map<String,dynamic>> addUser({required UserJSON2Dart userData,required String token}) async{
    
    dynamic body = jsonEncode(userData);
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: LoginRoutes.register, body: body,token: token);
    return response;
  }

  @override
  Future<Map<String,dynamic>> refresh({required String token}) async{
  
      dynamic body = jsonEncode({});
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: UserRoutes.getUsers, body: body,token: token);
    return response;

  }
  
  @override
  Future<Map<String, dynamic>> deleteUser({required String email, required String token}) async{
     dynamic body = jsonEncode({"email":email});
      Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: UserRoutes.deleteUser, body: body,token: token);
      return response;
  }
  
  @override
  Future<Map<String, dynamic>> suspendUser({required String email, required String token}) async{
      dynamic body = jsonEncode({"email":email});
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: UserRoutes.suspendUser, body: body,token: token);
    return response;
  }
  
  @override
  Future<Map<String, dynamic>> updateUser({required UserJSON2Dart userData, required String token}) async{
      
      dynamic body = jsonEncode({"phonenumber":userData.phonenumber,"dept":userData.dept,
      "unit":userData.unit,"role":userData.role,"email":userData.email});
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: UserRoutes.updateUser, body: body,token: token);
    return response;
  }
  
  @override
  Future<Map<String, dynamic>> activeUser({required String email, required String token}) async{
      dynamic body = jsonEncode({"email":email});
    Map<String,dynamic> response = await HttpHandlerImpl.instance.post(url: UserRoutes.activeUser, body: body,token: token);
    return response;
  }
  
}
