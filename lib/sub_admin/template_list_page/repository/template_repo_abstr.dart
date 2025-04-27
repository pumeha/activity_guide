abstract class TemplateRepoAbstr {
  Future<Map<String,dynamic>> uploadTemplate({required String name,required String value,
                    required String purpose,required String token});

  Future<Map<String, dynamic>> updateTemplate({required String name,required String values,
                  required String token});        

  Future<Map<String,dynamic>> deleteTemplate({required String name,required String token});                          

}