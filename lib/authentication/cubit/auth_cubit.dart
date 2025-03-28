import 'package:activity_guide/authentication/cubit/auth_cubit_state.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<AuthCubitState>{

  final AuthRepositoryImpl authRepositoryImpl;

  AuthCubit(this.authRepositoryImpl) :super(AuthIntial());
 

  Future<void> login(String email,String password) async{
   
    emit(AuthLoading());

    
      final status = await authRepositoryImpl.login(email, password);

      print(status);
     // emit(AuthSuccess());
      // if (status) {
      //   emit(AuthSuccess());
      // } else {
      //   emit(AuthFailure('Incorrect credentials'));
      // }
    
    
  }

  Future<void> forgotPassword(String password) async{
      emit(AuthLoading());

  }

  Future<void> resetPassword(String email,String token,String newPassword) async{
      emit(AuthLoading());

  }

}
