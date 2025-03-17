class TemplateJson {
  late int iD;
 late String name;
 late String type;
 late String range;

  TemplateJson({required  this.iD, required this.name, required this.type, required this.range});

  TemplateJson.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
    type = json['Type'];
    range = json['Range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['name'] = this.name;
    data['Type'] = this.type;
    data['Range'] = this.range;
    return data;
  }
}