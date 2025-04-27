import 'dart:html';
import 'dart:convert';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_datagrid/src/datagrid_widget/sfdatagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'csv2json.dart';


class downloadExcelFile{
  int _previousRowCount = 0;
  Future<void> createExcel(GlobalKey<SfDataGridState> key) async {
// Create a new Excel Document.

    final Workbook workbook = key
                        .currentState!
                        .exportToExcelWorkbook();

// Save and dispose the document.
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

//Download the output file in web.
    AnchorElement(
        href:
        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(
            bytes)}")
      ..setAttribute("download", "output.xlsx")
      ..click();
  }

  Future<void> partialSave(GlobalKey<SfDataGridState> key) async {
    Workbook workbook = key.currentState!.exportToExcelWorkbook();
    List<int> bytes = workbook.saveAsCSV(',');
    workbook.dispose();

    String data = utf8.decode(bytes);

   List<Map<dynamic,String>> _data = csv2json(data);
   String v = jsonEncode(_data);
    await MysharedPreference().setPreferences('savedata', v);
    previousRowCount = _data.length;
        await MysharedPreference().setPreferencesI('rowCount', previousRowCount);

  }

  int get previousRowCount {
    return _previousRowCount;
  }

  set previousRowCount(int value){
    _previousRowCount = value;

  }



}