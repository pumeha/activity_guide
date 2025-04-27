import '../json2dart/user_json_dart.dart';

abstract class UsersRepoAbstract {
  Future<Map<String,dynamic>> refresh({required String token});
  Future<Map<String,dynamic>> addUser({required UserJSON2Dart userData,required String token});
    Future<Map<String,dynamic>> updateUser({required UserJSON2Dart userData,required String token});
  Future<Map<String,dynamic>> suspendUser({required String email,required String token});
 Future<Map<String,dynamic>> deleteUser({required String email,required String token});
  Future<Map<String,dynamic>> activeUser({required String email,required String token});
}