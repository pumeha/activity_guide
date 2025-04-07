class LoginJsonDart {
  String? token;
  String? role;
  String? dashboardurl;
  
  LoginJsonDart({this.role,this.token});

  LoginJsonDart.fromJson(Map<String,dynamic> json){
    token = json['token'];
    role =  json['role'];
    dashboardurl = json['dashboardLink'];
  }

}
