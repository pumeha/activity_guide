import 'dart:io';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/sub_admin/dashboard_page/repository/dashboard_repository_impl.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'dashboard_cubit_state.dart';
import 'package:bloc/bloc.dart';

class DashboardCubit extends Cubit<DashboardCubitState> {

 final DashboardRepositoryImpl dashboardRepositoryImpl;

  DashboardCubit(this.dashboardRepositoryImpl) : super(DashboardInitial());

  Future<void> updateDashboardUrl({String? dashbordUrl}) async{
   
    emit(DashboardLoading());

      bool onlineOrOffline =  isDeviceOffline();

      if (!onlineOrOffline) {
        emit(DashboardFailure(errorMessage: 'No internet connection'));
      }

    String? token =  await MysharedPreference().getPreferences(LoginKeys.token);
     if (token == null || token.isEmpty) {
        emit(DashboardFailure(errorMessage: 'Unauthorized User'));
        return;
      }
      
    final response = await dashboardRepositoryImpl.updateDashboardUrl(url: dashbordUrl,token: token); 
  
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);
    int? status = data.status;
    if (status == HttpStatus.ok) {
       await  MysharedPreference().setPreferences( DashboardKey.link, dashbordUrl!);
        emit(DashboardSuccess(message: 'Success'));
    } else {
      emit(DashboardFailure(errorMessage: data.message));
    }
  }

  Future<void> showDashboard() async{
   emit(DashboardLoading());

      bool onlineOrOffline =  isDeviceOffline();
      if (!onlineOrOffline) {
        emit(DashboardFailure(errorMessage: 'No internet connection'));
      }else{
          emit(DashboardShow());
      }
    }

  void hideDashboard(){emit(DashboardHide());}
}