import 'dart:convert';
import 'dart:io';
import 'package:activity_guide/admin/view/users_page.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:bloc/bloc.dart';
import '../../shared/utils/constants.dart';
import '../repository/users_repo_impl.dart';
import 'user_event.dart';
import 'user_state.dart';
class UserBloc extends Bloc<UserEvent, UserState> {
  final UsersRepoImpl usersRepoImpl;


  UserBloc(this.usersRepoImpl) : super(IntialState()) {

    on<AddUserEvent>((event, emit) async{
      emit(LoadingState());

      bool onlineOrOffline = await isDeviceOffline_Return_True();
      if (onlineOrOffline) {
        emit(FailureState(message: 'No internet connection')); return;
      }
      
      String? token = await MysharedPreference().getPreferences(LoginKeys.token);
      if (token == null || token.isEmpty) {
        emit(FailureState(message: 'Unauthorized User'));
        return;
      }

      final response = await usersRepoImpl.addUser(userData: event.userDetails!,token: token);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);

      if (data.status == HttpStatus.ok || data.status == HttpStatus.created) {
        
           final usersList = data.data!.where((user)=>user['role'] == 'user').toList();
          String usersString = jsonEncode(usersList);
         final subAdmins = data.data!.where((user)=>user['role'] == 'sub-admin').toList();              
          String subAdminsString = jsonEncode(subAdmins);

         await Future.wait([
                MysharedPreference().setPreferences(usersLists, usersString),
                MysharedPreference().setPreferences(subAdminLists, subAdminsString)
          ]);
        emit(SuccessState(message: data.message));
      }else{
        emit(FailureState(message: data.message));
      }


    });

    on<UpdateUserEvent>((event, emit) async{
      emit(LoadingState());
      
      bool onlineOrOffline = await isDeviceOffline_Return_True();
      if (onlineOrOffline) {
        emit(FailureState(message: 'No internet connection')); return;
      }

    String? token = await MysharedPreference().getPreferences(LoginKeys.token);
    if(token == null || token.isEmpty) {
      emit(FailureState(message: 'Unauthorized User'));
      return;
    }

    final response = await usersRepoImpl.updateUser(userData: event.userDetails!, token: token);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);

          
    if (data.status == HttpStatus.ok) {

      final usersList = data.data!.where((user)=>user['role'] == 'user').toList();
          String usersString = jsonEncode(usersList);
         final subAdmins = data.data!.where((user)=>user['role'] == 'sub-admin').toList();              
          String subAdminsString = jsonEncode(subAdmins);

         await Future.wait([
                MysharedPreference().setPreferences(usersLists, usersString),
                MysharedPreference().setPreferences(subAdminLists, subAdminsString)
          ]);

      emit(SuccessState(message: data.message));
    } else {
      emit(FailureState(message: data.message));
    }

    });

    on<SuspendUserEvent>((event, emit) async{
      emit(LoadingState());

      bool onlineOrOffline = await isDeviceOffline_Return_True();
      if (onlineOrOffline) {
        emit(FailureState(message: 'No internet connection')); return;
      }
    
    String? token = await MysharedPreference().getPreferences(LoginKeys.token);
    if(token == null || token.isEmpty) {
      emit(FailureState(message: 'Unauthorized User'));
      return;
    }

    final response = await usersRepoImpl.suspendUser(email: event.email, token: token);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);

    if (data.status == HttpStatus.ok) {
      
     final usersList = data.data!.where((user)=>user['role'] == 'user').toList();
          String usersString = jsonEncode(usersList);
         final subAdmins = data.data!.where((user)=>user['role'] == 'sub-admin').toList();              
          String subAdminsString = jsonEncode(subAdmins);

         await Future.wait([
                MysharedPreference().setPreferences(usersLists, usersString),
                MysharedPreference().setPreferences(subAdminLists, subAdminsString)
          ]);

      emit(SuccessState(message: data.message));
    } else {
      emit(FailureState(message: data.message));
    }

    });


    on<DeleteUserEvent>((event, emit) async{
     emit(LoadingState());

      bool onlineOrOffline = await isDeviceOffline_Return_True();
      if (onlineOrOffline) {
        emit(FailureState(message: 'No internet connection')); return;
      }

    String? token = await MysharedPreference().getPreferences(LoginKeys.token);
    if(token == null || token.isEmpty) {
      emit(FailureState(message: 'Unauthorized User'));
      return;
    }

    final response = await usersRepoImpl.deleteUser(email: event.email, token: token);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);
    
        
    if (data.status == HttpStatus.ok) {

    final usersList = data.data!.where((user)=>user['role'] == 'user').toList();
          String usersString = jsonEncode(usersList);
         final subAdmins = data.data!.where((user)=>user['role'] == 'sub-admin').toList();              
          String subAdminsString = jsonEncode(subAdmins);

         await Future.wait([
                MysharedPreference().setPreferences(usersLists, usersString),
                MysharedPreference().setPreferences(subAdminLists, subAdminsString)
          ]);            

      emit(SuccessState(message: data.message));
    } else {
      emit(FailureState(message: data.message));
    }

    });

    on<ActiveUserEvent>((event, emit) async{
      emit(LoadingState());

      bool onlineOrOffline = await isDeviceOffline_Return_True();
      if (onlineOrOffline) {
        emit(FailureState(message: 'No internet connection')); return;
      }

    String? token = await MysharedPreference().getPreferences(LoginKeys.token);
    if(token == null || token.isEmpty) {
      emit(FailureState(message: 'Unauthorized User'));
      return;
    }

    final response = await usersRepoImpl.activeUser(email: event.email, token: token);
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);
    

    if (data.status == HttpStatus.ok) {

      final usersList = data.data!.where((user)=>user['role'] == 'user').toList();
          String usersString = jsonEncode(usersList);
         final subAdmins = data.data!.where((user)=>user['role'] == 'sub-admin').toList();              
          String subAdminsString = jsonEncode(subAdmins);

         await Future.wait([
                MysharedPreference().setPreferences(usersLists, usersString),
                MysharedPreference().setPreferences(subAdminLists, subAdminsString)
          ]);          
      emit(SuccessState(message: data.message));
    } else {
      emit(FailureState(message: data.message));
    }

    });

    on<GetDeptUnitEvent>((event, emit) {
      emit(MapState(unit: departmentOptions[event.selectedDept]));
    });

  }
}
