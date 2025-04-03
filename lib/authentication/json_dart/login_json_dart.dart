class LoginJsonDart {
  String? token;
  String? role;
  
  LoginJsonDart({this.role,this.token});

  LoginJsonDart.fromJson(Map<String,dynamic> json){
    token = json['token'];
    role =  json['role'];
  }

}
