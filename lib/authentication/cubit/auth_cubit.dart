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

      }else if(message == 'success' && loginValues.role! == admin){
        await Future.wait([
        MysharedPreference().setPreferences(LoginKeys.role,  loginValues.role!),
        MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!)
      ]);

       emit(AuthSuccess(loginValues.role!));
     
      }else if(message == 'success' &&  loginValues.role! == subAdmin){
         
          await Future.wait([
        MysharedPreference().setPreferences(LoginKeys.role,  loginValues.role!),
        MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!)
      ]);
      
      final templateJson = data.data![0]['template'] as List<dynamic>;
      String templatesJson = jsonEncode(templateJson.toList());
      await  MysharedPreference().setPreferences(templateListKeys, templatesJson);
     
    emit(AuthSuccess(loginValues.role!));
      }
      else{
        
      await Future.wait([
        MysharedPreference().setPreferences(LoginKeys.role,  loginValues.role!),
       MysharedPreference().setPreferences( LoginKeys.token, loginValues.token!),
       MysharedPreference().setPreferences( DashboardKey.link,loginValues.dashboardurl!)
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
