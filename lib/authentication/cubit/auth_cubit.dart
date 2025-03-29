import 'package:activity_guide/authentication/cubit/auth_cubit_state.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:activity_guide/shared/utils/http%20handler/general_json_dart.dart';
import 'package:activity_guide/shared/utils/http%20handler/response_handler.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<AuthCubitState>{

  final AuthRepositoryImpl authRepositoryImpl;

  AuthCubit(this.authRepositoryImpl) :super(AuthIntial());
 

  Future<void> login(String email,String password) async{
   
    emit(AuthLoading());

    
      final response = await authRepositoryImpl.login(email, password);
      GeneralJsonDart data = GeneralJsonDart.fromJson(response);
      int status = data.status;
      String message = data.message;
      if (status == HttpStatusCode.OK) {
        emit(AuthSuccess());
      }else if(status == HttpStatusCode.BAD_REQUEST){
        emit(AuthFailure(message));
      }else if(status == HttpStatusCode.SERVER_ERROR){
        emit(AuthFailure(message));
      }else if(status == HttpStatusCode.MANY_REQUEST){
        emit(AuthFailure(message));
      }
    
    
  }

  Future<void> forgotPassword(String password) async{
      emit(AuthLoading());

  }

  Future<void> resetPassword(String email,String token,String newPassword) async{
      emit(AuthLoading());

  }

}
