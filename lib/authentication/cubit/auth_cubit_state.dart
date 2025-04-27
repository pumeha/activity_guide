import 'package:equatable/equatable.dart';

abstract class AuthCubitState extends Equatable{

  @override
  List<Object?> get props => [];
  
}

class AuthIntial extends AuthCubitState {
  
}

class  AuthLoading extends AuthCubitState {
  
}

class AuthSuccess extends AuthCubitState {
  final String message;
  AuthSuccess(this.message);
}

class AuthFailure extends AuthCubitState {
  final String error;
  AuthFailure(this.error);
}


