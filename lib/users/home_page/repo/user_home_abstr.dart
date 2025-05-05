abstract class UserHomeAbstr {
  Future<Map<String,dynamic>> fetchTemplateData({required String token, required String templateName}); 
}