import 'dart:convert';

class GeneralJsonDart {
 String?  message;
  List<dynamic>? data; 
  int? status;

  GeneralJsonDart({ this.message, this.data, this.status});

  GeneralJsonDart.fromJson(Map<String, dynamic> response) {
    message = response['message'];
    if (response['data'] != null) {
      data = List<dynamic>.from(response['data']); // Adjusted to handle dynamic data
    }
    status = response['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data; // Directly assign the dynamic list
    }
    jsonData['status'] = status;
    return jsonData;
  }
}
