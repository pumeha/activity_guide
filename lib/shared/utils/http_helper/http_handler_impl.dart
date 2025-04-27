import 'dart:convert';
import 'package:activity_guide/shared/utils/http_helper/http_handler_abstract.dart';
import 'package:http/http.dart' as http;
class HttpHandlerImpl extends HttpHandlerAbstract {
    HttpHandlerImpl._();
    static final _instance = HttpHandlerImpl._();
    static HttpHandlerImpl get instance => _instance;

  @override
  Future<Map<String, dynamic>> delete({required String url, required String token, required body}) async{
       
      Map<String,String> header  = {
      'Authorization': 'Bearer $token',// Make sure to include Content-Type
      'Content-Type' : 'application/json'
      };

      try {
        dynamic response = await http.delete(Uri.parse(url),headers: header,body: body);
        
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        return jsonData;
      } on Exception catch (e) {
       return {'status':500,'message':e.toString(),'data':[]};
      }
  }

  @override
  Future<Map<String, dynamic>> get({required String url, required String token, required body}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> post({required String url, String? token, required body}) async{
      Map<String,String> header ={};
     
      if (token == null ||token.isEmpty) {
        header = {'Content-Type' : 'application/json'};
      }else if(token.isNotEmpty){

      header  = {
      'Authorization': 'Bearer $token',// Make sure to include Content-Type
      'Content-Type' : 'application/json'
      };

      }
      
    try {
      dynamic response = await http.post(Uri.parse(url),headers: header,body: body);
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } on Exception catch (e) {
      return {'status':500,'message':e.toString(),'data':[]};
    }

  }
  
  @override
  Future<Map<String, dynamic>> put({required String url, required String token, required body}) {
    // TODO: implement put
    throw UnimplementedError();
  }  
}