import 'package:bloc/bloc.dart';

import '../../../shared/utils/constants.dart';
import 'user_dashboard_state.dart';
class UserDashboardCubit extends Cubit<UserDashboardState> {
  UserDashboardCubit() : super(UserDashboardInitial());

  Future<void> show(bool show) async{

      if(show){
      bool onlineOrOffline = await isDeviceOffline_Return_True();
        if (onlineOrOffline) {
          emit(offlineState());
        }
      }else{
        emit(UserDashboard(show: show));
      }

      
  }

  void refreshDashoard(){emit(refreshDashoardState());}
  void showRefreshButton(){emit(showRefreshState());}
  
}