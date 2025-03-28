import 'dart:convert';

import 'package:activity_guide/shared/utils/http%20handler/http_handler_abstract.dart';
import 'package:http/http.dart' as http;
class HttpHandlerImpl extends HttpHandlerAbstract {
    HttpHandlerImpl._();
    static final _instance = HttpHandlerImpl._();
    static HttpHandlerImpl get instance => _instance;

  @override
  Future<Map<String, dynamic>> delete({required String url, required Map<String,String> header, required body}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> get({required String url, required Map<String,String> header, required body}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> post({required String url, Map<String,String>? header, required body}) async{
    print(body);
    print(header);
    print(url);
    var response = await http.post(Uri.parse(url),headers: header,body: body);
      print(response);
    try {
      var response = await http.post(Uri.parse(url),headers: header,body: body);
      print(response);
      return jsonDecode(response.body);
    } on Exception catch (e) {
      return {'status':'500','message':e.toString(),'data':{}};
    }
      
  }
  
  @override
  Future<Map<String, dynamic>> put({required String url, required Map<String, String> header, required body}) {
    // TODO: implement put
    throw UnimplementedError();
  }



 
  
}