abstract class UserHomeAbstr {
  Future<Map<String,dynamic>> fetchTemplateData({required String token, required String templateName});
  Future<Map<String,dynamic>> fetchMonthlyTemplateData({required String token});
  Future<Map<String,dynamic>> fetchDashboardData({required String token, required String templateName});
}