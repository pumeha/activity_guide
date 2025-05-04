
abstract class UserState {}
class IntialState extends UserState {
  
}
class LoadingState extends UserState {
  
}

class SuccessState extends UserState {
  String? message;
  SuccessState({required this.message});

}

class FailureState extends UserState {
  String? message;
  FailureState({this.message});
}

class MapState extends UserState {
 List<String>? unit;
 MapState({required unit});
}