import 'package:activity_guide/users/dashboard_page/monthly_j2d.dart';

abstract class UserHomeState {}

class UserHomeInitial extends UserHomeState {
  
}

class UserHomeLoading extends UserHomeState {
  
}

class UserHomeSuccess extends UserHomeState {
  String? message;
  List data;
  UserHomeSuccess({required this.message,required this.data});
}

class UserHomeFailure extends UserHomeState {
  String? message;
  UserHomeFailure({required this.message});
}