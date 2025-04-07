import 'dart:io';
import 'package:activity_guide/authentication/cubit/auth_cubit_state.dart';
import 'package:activity_guide/authentication/json_dart/login_json_dart.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


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
        
        final storage = FlutterSecureStorage();
        LoginJsonDart loginValues = LoginJsonDart.fromJson(data.data![0]);
        
      await Future.wait([
       storage.write(key: LoginKeys.role,value: loginValues.role),
       storage.write(key: LoginKeys.token,value: loginValues.token),
       storage.write(key: DashboardKey.link, value: loginValues.dashboardurl)
      ]);

        emit(AuthSuccess(loginValues.role!));
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
        final storage = FlutterSecureStorage();
        
          String token = data.data![0]['token'];
          await storage.write(key: LoginKeys.token, value: token); 
        emit(AuthSuccess(message));
      } else {
        emit(AuthFailure(message));
      }

  }

  Future<void> resetPassword(String inputCode,String newPassword) async{
      emit(AuthLoading());

      final storage = FlutterSecureStorage();
      String? token  = await storage.read(key: LoginKeys.token);
      Map<String,dynamic> response = await authRepositoryImpl.resetPassword(inputCode, newPassword, token!);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      int status = data.status!;
      if (status == HttpStatus.ok) {
        emit(AuthSuccess('Password Change Successful!'));
      }else{
        emit(AuthFailure(data.message!));
      }

  }

  Future<void> userVerification(String inputCode) async{
      emit(AuthLoading());
      final storage = FlutterSecureStorage();
      String? token  = await storage.read(key: LoginKeys.token);
      Map<String,dynamic> response = await authRepositoryImpl.userVerification(inputCode, token!);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      int status = data.status!;
      if (status == HttpStatus.ok) {
        emit(AuthSuccess('Account Verified!'));
      }else{
        emit(AuthFailure(data.message!));
      }
  }

  Future<void> requestTokenAgain(String inputCode) async{
      emit(AuthLoading());
      final storage = FlutterSecureStorage();
      String? token  = await storage.read(key: LoginKeys.token);
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
