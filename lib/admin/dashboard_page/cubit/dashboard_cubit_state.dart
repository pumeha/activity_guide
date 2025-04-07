import 'package:equatable/equatable.dart';
abstract class DashboardCubitState extends Equatable{
 
  @override
  List<Object?> get props => [];
}
class DashboardInitial extends DashboardCubitState {
  
}
class DashboardLoading extends DashboardCubitState {
  
}
class DashboardSuccess extends DashboardCubitState {
  final String? message;
  DashboardSuccess({this.message});
}
class DashboardFailure extends DashboardCubitState {
  final String? errorMessage;
  DashboardFailure({this.errorMessage});
}