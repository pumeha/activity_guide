
abstract class HttpHandlerAbstract  {

  Future<Map<String,dynamic>> post({required String url, Map<String,String>? header,required dynamic body});
  Future<Map<String,dynamic>> get({required String url,required Map<String,String> header,required dynamic body});
 Future<Map<String,dynamic>> put({required String url,required Map<String,String> header,required dynamic body});
 Future<Map<String,dynamic>> delete({required String url,required Map<String,String> header,required dynamic body}); 
}