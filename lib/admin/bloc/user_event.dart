import '../json2dart/user_json_dart.dart';

abstract class UserEvent {}

class RefreshEvent extends UserEvent {
  
} 

class GetDeptUnitEvent extends UserEvent {
  String selectedDept;
  GetDeptUnitEvent({required this.selectedDept});
}

class AddUserEvent extends UserEvent {
  UserJSON2Dart? userDetails;
  AddUserEvent({required this.userDetails});
}

class UpdateUserEvent extends UserEvent {
  UserJSON2Dart? userDetails;
  UpdateUserEvent({required this.userDetails});
}

class SuspendUserEvent extends UserEvent {
  String  email;
  SuspendUserEvent({required this.email});
}

class DeleteUserEvent extends UserEvent {
  String email;
  DeleteUserEvent({required this.email});
}

class ActiveUserEvent extends UserEvent {
  String email;
  ActiveUserEvent({required this.email});
}