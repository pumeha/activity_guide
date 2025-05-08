import 'package:bloc/bloc.dart';

import 'user_dashboard_state.dart';
class UserDashboardCubit extends Cubit<UserDashboardState> {
  UserDashboardCubit() : super(UserDashboardInitial());

  void show(bool show){
    emit(UserDashboard(show: show));
  }

  void refreshDashoard(){emit(refreshDashoardState());}
  void showRefreshButton(){emit(showRefreshState());}
  
}