import 'dart:io';
import 'package:activity_guide/admin/dashboard_page/repository/dashboard_repository_impl.dart';
import 'package:activity_guide/shared/utils/http_helper/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard_cubit_state.dart';
import 'package:bloc/bloc.dart';

class DashboardCubit extends Cubit<DashboardCubitState> {

 final DashboardRepositoryImpl dashboardRepositoryImpl;

  DashboardCubit(this.dashboardRepositoryImpl) : super(DashboardInitial());

  Future<void> updateDashboardUrl({String? dashbordUrl}) async{
   
    emit(DashboardLoading());
    String? token =  await FlutterSecureStorage().read(key: LoginKeys.token);
    
    final response = await dashboardRepositoryImpl.updateDashboardUrl(url: dashbordUrl,token: token); 
  
    GeneralJsonDart data = GeneralJsonDart.fromJson(response);
    int? status = data.status;
    if (status == HttpStatus.ok) {
       await FlutterSecureStorage().write(key: DashboardKey.link,value: dashbordUrl);
        emit(DashboardSuccess(message: 'Success'));
    } else {
      emit(DashboardFailure(errorMessage: data.message));
    }
  }
}
