import '../json2dart/user_json_dart.dart';

abstract class UserState {}
class IntialState extends UserState {
  
}
class LoadingState extends UserState {
  
}

class SuccessState extends UserState {
  String? message;
  List<UserJSON2Dart>? listUsers;
  List<UserJSON2Dart>? listSubAdmin;
  SuccessState({required this.message,required this.listUsers,required this.listSubAdmin});

}

class FailureState extends UserState {
  String? message;
  FailureState({this.message});
}

class MapState extends UserState {
 List<String>? unit;
 MapState({required unit});
}