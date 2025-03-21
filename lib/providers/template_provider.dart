import 'dart:convert';
import 'package:activity_guide/main.dart';
import 'package:activity_guide/models/myshared_preference.dart';
import 'package:activity_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import '../models/rowdata_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../screens/admin/template/preview_template.dart';
import 'package:beamer/beamer.dart';


class TemplateProvider with ChangeNotifier {
  List<RowData> rows = [];
  List<String> jsonObject = [];
  bool _isAdmin = false;
  bool get isAdmin  => _isAdmin;

  // Method to print rows data
  Future<void> printRowsData() async {
    jsonObject.clear();
   // EasyLoading.show(status: 'Loading...');
    for (int i = 0; i<rows.length;i++) {
      if(rows[i].variableNameController.text.isEmpty || rows[i].dataTypeController.text.isEmpty ||
          rows[i].rangeController.text.isEmpty){
        EasyLoading.showError('Kindly complete the fields',duration: Duration(seconds: 5));
        return;
      }
      String name = rows[i].variableNameController.text;
      String type = rows[i].dataTypeController.text;
      String range = rows[i].rangeController.text.trim();

      if(type == 'Dropdown'){
        range = '${range}';
      }

     String data = '{"ID": ${rows[i].id},"name": "${name}",'
          '"Type": "${type}","Range": "${range}"'
          '}';

      jsonObject.add(data);

      EasyLoading.showSuccess('Success!');
    }

    MysharedPreference().setPreferences('template',jsonObject.toList().toString());
    print(jsonObject.toList().toString());
  }

  void updateRow(int index, RowData updatedRow) {
    rows[index] = updatedRow; // Replace the old row data with the updated data
    notifyListeners(); // Notify the listeners to rebuild the UI
  }

  void addRow() {
    int index = rows.length + 1;
    rows.add(RowData(id: index.toString(), variableName: '',range: '',rangeStatus: false, info: ''));
    notifyListeners();
  }

  void removeRow() {
    if (rows.isNotEmpty) {
      rows.removeLast();
      notifyListeners();
    }
  }

  void reorderRows(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final row = rows.removeAt(oldIndex);
    rows.insert(newIndex, row);
    notifyListeners();
  }

  Future<void> previewTemplate(BuildContext context) async {
    context.beamToNamed('/admin/preview_template');
  }

  Future<void> editTemplate() async{
    rows.clear();
    String? template = await MysharedPreference().getPreferences('template');
    //Decode the JSON
    List<dynamic> jsonList = jsonDecode(template!);
    //converting JSON array to map
    List<Map<String,dynamic>> decodedData = jsonList.cast<Map<String,dynamic>>();

    //adding the existing template to the template builder
    int  t = 1;
    for(var item in decodedData){
      rows.add(
          RowData(id: t.toString(), variableName: item['name'],
              dataType: item['Type'], rangeStatus: item['Type'] != 'Dynamic' ? true : false,
              range: item['Range'], info: ''));

      t+=1;
    }
    notifyListeners();
  }

  Future<void> currentUser() async{
    String? role = await MysharedPreference().getPreferences(admin);
    _isAdmin =  role == 'true' ? false : true;
    notifyListeners();
  }

}