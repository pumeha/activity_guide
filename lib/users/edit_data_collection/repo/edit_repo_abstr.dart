abstract class EditRepoAbstr {
  Future<Map<String,dynamic>> upload({required String url, required String templateName, required List<dynamic> data,required String token});
}