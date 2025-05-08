import 'dart:convert';
import 'dart:io';
import 'package:activity_guide/authentication/cubit/auth_cubit_state.dart';
import 'package:activity_guide/authentication/json_dart/login_json_dart.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:bloc/bloc.dart';
import '../../shared/utils/myshared_preference.dart';


class AuthCubit extends Cubit<AuthCubitState>{

  final AuthRepositoryImpl authRepositoryImpl;

  AuthCubit(this.authRepositoryImpl) :super(AuthIntial());
 

  Future<void> login(String email,String password) async{
   
      emit(AuthLoading());

      final response = await authRepositoryImpl.login(email, password);

      GeneralJsonDart data = GeneralJsonDart.fromJson(response);
      int? status = data.status;
      String message = data.message!;
 
      
      if (status == HttpStatus.ok) {
          LoginJsonDart loginValues = LoginJsonDart.fromJson(data.data![0]);
      if(message == 'verification'){
        await  MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!);
        emit(AuthSuccess(message));

      }else if(loginValues.role! == admin){
          final usersList = data.data![0]['users'] as List<dynamic>;
          usersList.where((user)=>user['role']=='user');
        String userJson = jsonEncode( usersList.where((user)=>user['role']=='user').toList());
        String subadminJson = jsonEncode(usersList.where((user)=>user['role']=='sub-admin').toList());
        await Future.wait([
        MysharedPreference().setPreferences(LoginKeys.role,  loginValues.role!),
        MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!),
        MysharedPreference().setPreferences(usersLists, userJson),
        MysharedPreference().setPreferences(subAdminLists, subadminJson),
        MysharedPreference().setPreferences(fullnameKey, data.data![0]['fullname'])
      ]);
        
        
     emit(AuthSuccess(loginValues.role!));
     
      }else if(message == 'success' &&  loginValues.role! == subAdmin){
      
        await Future.wait([
        MysharedPreference().setPreferences(LoginKeys.role,  loginValues.role!),
        MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!),
         MysharedPreference().setPreferences(fullnameKey, data.data![0]['fullname'])
      ]);
      
      final templateJson = data.data![0]['template'] as List<dynamic>;
      String templatesJson = jsonEncode(templateJson.toList());
      await  MysharedPreference().setPreferences(templateListKeys, templatesJson);
     
    emit(AuthSuccess(loginValues.role!));
      }
      else{
         String monthlyTempleJsonString;
        if (data.data![0][monthlyTemplateKey] != null ) {
            final monthlyTempleJson = data.data![0][monthlyTemplateKey] as List<dynamic>;
            monthlyTempleJsonString = jsonEncode(monthlyTempleJson.toList());

            await Future.wait([
               MysharedPreference().setPreferences(monthlyTemplateName, data.data![0][monthlyTemplateName]),
               MysharedPreference().setPreferences(monthlyTemplateKey,monthlyTempleJsonString )
            ]);
        }
      

        String workplanTemplateJsonString;
        if (data.data![0][workplanTemplateKey] != null) {
        
          final workplanTemplateJson = data.data![0][workplanTemplateKey] as List<dynamic>;
        workplanTemplateJsonString = jsonEncode(workplanTemplateJson.toList());

        await Future.wait([
          MysharedPreference().setPreferences(workplanTemplateKey, workplanTemplateJsonString),
          MysharedPreference().setPreferences(workplanTemplateName, data.data![0][workplanTemplateName])
        ]);
        }

      await Future.wait([
      MysharedPreference().setPreferences(LoginKeys.role,  loginValues.role!),
      MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!),
      MysharedPreference().setPreferences( DashboardKey.link,loginValues.dashboardurl!),
      MysharedPreference().setPreferences(fullnameKey, data.data![0]['fullname']),
      MysharedPreference().setPreferences(deptKey, data.data![0]['dept'] ),
      ]);

       emit(AuthSuccess(loginValues.role!));
      }
      }else if(status == HttpStatus.forbidden){
          emit(AuthFailure('Account Suspended \n Kindly Contact Admin '));
      }else {
        emit(AuthFailure(message));
      }
  }

  Future<void> forgotPassword(String email) async{
      emit(AuthLoading());

      dynamic response = await authRepositoryImpl.forgotPassword(email);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      int status = data.status!;
      String message = data.message!;

      if (status == HttpStatus.ok) {
        String token = data.data![0]['token'];
       await MysharedPreference().setPreferences(LoginKeys.token, token);
          
        emit(AuthSuccess(message));
      } else {
        emit(AuthFailure(message));
      }

  }

  Future<void> resetPassword(String inputCode,String newPassword) async{
      emit(AuthLoading());

      String? token  = await MysharedPreference().getPreferences(LoginKeys.token);
      Map<String,dynamic> response = await authRepositoryImpl.resetPassword(inputCode, newPassword, token!);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      int status = data.status!;
      if (status == HttpStatus.ok) {
        emit(AuthSuccess('Password Change Successful!'));
      }else{
        emit(AuthFailure(data.message!));
      }

  }

  Future<void> userVerification({String? inputCode,String? newPassword}) async{
      
      emit(AuthLoading());
      
      String? token  = await MysharedPreference().getPreferences(LoginKeys.token);
      Map<String,dynamic> response = await authRepositoryImpl.userVerification(inputCode!, newPassword!, token!);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      int status = data.status!;
      if (status == HttpStatus.ok) {
        emit(AuthSuccess('Account Verified!'));
      }else{
        emit(AuthFailure(data.message!));
      }

  }

  Future<void> requestTokenAgain() async{
      emit(AuthLoading());
      
      String? token  = await MysharedPreference().getPreferences(LoginKeys.token);
      Map<String,dynamic> response = await authRepositoryImpl.requestTokenAgain(token!);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      int status = data.status!;
      if (status == HttpStatus.ok) {
        emit(AuthSuccess('Sent'));
      }else{
        emit(AuthFailure(data.message!));
      }
  }

}
