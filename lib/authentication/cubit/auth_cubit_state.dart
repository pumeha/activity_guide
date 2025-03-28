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
  
}

class AuthFailure extends AuthCubitState {
  final String error;
  AuthFailure(this.error);
}

