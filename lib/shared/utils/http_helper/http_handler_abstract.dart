abstract class HttpHandlerAbstract  {

 Future<Map<String,dynamic>> post({required String url, String? token,required dynamic body});
 Future<Map<String,dynamic>> get({required String url,required String token,required dynamic body});
 Future<Map<String,dynamic>> put({required String url,required String token,required dynamic body});
 Future<Map<String,dynamic>> delete({required String url,required String token,required dynamic body}); 
}