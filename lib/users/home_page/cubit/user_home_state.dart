abstract class UserHomeState {}

class UserHomeInitial extends UserHomeState {
  
}

class UserHomeLoading extends UserHomeState {
  
}

class UserHomeSuccess extends UserHomeState {
  String? message;
  UserHomeSuccess({required this.message});
}

class UserHomeFailure extends UserHomeState {
  String? message;
  UserHomeFailure({required this.message});
}