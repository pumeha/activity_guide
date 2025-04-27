class UserJSON2Dart {
  String? email;
  String? phonenumber;
  String ? role;
  String? dept;
  String? unit;
  String? firstname;
  String? lastname;
  String? status;

  UserJSON2Dart(
      {required this.email,
      required this.phonenumber,
      required this.role,
      required this.dept,
      required this.unit,
      required this.firstname,
      required this.lastname,this.status});

  UserJSON2Dart.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phonenumber = json['phonenumber'];
    role = json['role'];
    dept = json['dept'];
    unit = json['unit'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['phonenumber'] = phonenumber;
    data['role'] = role;
    data['dept'] = dept;
    data['unit'] = unit;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}