abstract class AuthRepositoryAbstract {
  Future<Map<String,dynamic>> login(String email,String password);
  Future<Map<String,dynamic>> forgotPassword(String email);
  Future<Map<String,dynamic>> resetPassword(String inputCode,String newPassword,String token);
  Future<Map<String,dynamic>> userVerification(String inputCode,String newPassword,String token);
  Future<Map<String,dynamic>> requestTokenAgain(String token);

}
