abstract class AuthRepositoryAbstract {
  Future<Map<String,dynamic>> login(String email,String password);
  Future<Map<String,dynamic>> forgotPassword(String email);
  Future<Map<String,dynamic>> resetPassword(String email,String token,String newPassword);
}