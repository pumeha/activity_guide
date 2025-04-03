import 'dart:convert';

class GeneralJsonDart {
 String?  message;
  List<dynamic>? data; 
  int? status;

  GeneralJsonDart({ this.message, this.data, this.status});

  GeneralJsonDart.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = List<dynamic>.from(json['data']); // Adjusted to handle dynamic data
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data; // Directly assign the dynamic list
    }
    jsonData['status'] = status;
    return jsonData;
  }
}
