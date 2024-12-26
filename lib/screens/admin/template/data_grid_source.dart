import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MyDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  List<String> _columnNames = [];
  BuildContext context;
 late String multipleDateString = 'test';

  List<Map<String, dynamic>> _jsonColumns = [];

  MyDataSource(count,this.context) {
   _initializeRows(count);
   loadJSONFromPrefs();
   //addRow();
  }

  Future<void> loadJSONFromPrefs()  async{
    String value = '[{"ID": 1,"name": "OUTPUT","Type": "Dropdown","Range": "Power Farm Solution for NBS Headquarters /SOLAR ENERGY, Establishing GIS Lab for  Geo-Spatial Modelling Unit, Building Big Data/Data Science Lab, Implementation of Data Privacy/Data Protection Policy in NBS, Re-construction of NBS HQ Data Warehousing and Network Infrastructure, Provision of Statistical Softwares and Packages for Analysis, Workshop on Further Analysis using various Statistical Packages HQ and Zonal Offices, Capacity Building ,Workshop on Field Data collection Tools  for Surveys Questionnaires design and data collection using various Computer Assisted Personal Interview (CAPI) solutions Survey Solutions CSPro  ODK Kobo SurveyCTO e.t.c, Provision of 2 additional Cloud Server and Exchange, Web Server Platform & Backups Maintenance of HQ network ports Acces Points for Sustainance and Expansion of Internet Connection in the Office. , Provision of Norton EndPoint Server Antivirus for the Year 2024.   ,Quarterly Maintenance of Systems at the Headquarters Zones and States."}, {"ID": 2,"name": "TYPE OF ACTIVITIES","Type": "Dropdown","Range": "SURVEY,SAS,WORKSHOP"}, {"ID": 3,"name": "FREQUENCY","Type": "Dropdown","Range": "DAILY,WEEKLY, MONTHLY"}, {"ID": 4,"name": "PLANNED  DATE","Type": "Date","Range": "Double Date"}, {"ID": 5,"name": "ACTUAL DATE","Type": "Date","Range": "Double Date"}, {"ID": 6,"name": "TARGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 7,"name": "ACTIVITIES DESCRIPTION","Type": "Dynamic","Range": "No default value required"}, {"ID": 8,"name": "OUTCOME","Type": "Dynamic","Range": "No default value required"}, {"ID": 9,"name": "PERCENTAGE  COMPLETED","Type": "Dynamic","Range": "No default value required"}, {"ID": 10,"name": "MILESTONE","Type": "Dropdown","Range": "N/A,PROPOSAL,PLANNING,EXCUTING,COMPLETION,SUBMISSION"}, {"ID": 11,"name": "BASELINE METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 12,"name": "KPI","Type": "Dynamic","Range": "No default value required"}, {"ID": 13,"name": "ACTUAL ACHIEVED METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 14,"name": "TOTAL BUDGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 15,"name": "APPROPRIATION","Type": "Dynamic","Range": "No default value required"}, {"ID": 16,"name": "DONOR","Type": "Dynamic","Range": "No default value required"}, {"ID": 17,"name": "RELEASED","Type": "Dynamic","Range": "No default value required"}, {"ID": 18,"name": "UTILIZED","Type": "Dynamic","Range": "No default value required"}, {"ID": 19,"name": "BALANCE","Type": "Dynamic","Range": "No default value required"}, {"ID": 20,"name": "MORE FUND","Type": "Dynamic","Range": "No default value required"}, {"ID": 21,"name": "CHALLENGES","Type": "Dropdown","Range": "NO CHALLENGES,FUNDS RELATED,RISKRELATED"}, {"ID": 22,"name": "REMARKS","Type": "Dynamic","Range": "No default value required"}]';
    _jsonColumns = List<Map<String,dynamic>>.from(jsonDecode('[{"ID": 0,"name": "S/N","Type": "Dynamic","Range": "No default value required"}]'));
    _jsonColumns.addAll(List<Map<String,dynamic>>.from(jsonDecode(value)));

  }

  void _initializeRows(int rowCount) {
    _rows = List.generate(
      rowCount,
          (index) => DataGridRow(cells: []),
    );
  }

  void addColumn(String columnName) {
    _columnNames.add(columnName);

    if(columnName == 'S/N'){
      for(int i = 0; i<_rows.length; i++){
          _rows[i].getCells().add(DataGridCell(columnName: columnName, value: (i+1).toString()));
      }
    }else{
      for (var row in _rows) {
        row.getCells().add(DataGridCell(columnName: columnName, value: ''));
      }
    }

    notifyListeners(); // Refresh the grid
  }

  void addRow() {
    var newRow = DataGridRow(
      cells: _columnNames.map((columnName) {
        if(columnName == 'S/N'){
          return DataGridCell<String>(columnName: columnName, value: (_rows.length+1).toString());
        }
        return DataGridCell<String>(columnName: columnName, value: ''); // Default empty value
      }).toList(),);
    _rows.add(newRow); // Add the new row to the list
    notifyListeners(); // Refresh the grid to show the new row
  }


  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    dynamic sn;
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        final columnName = cell.columnName;
        final columnIndex = _columnNames.indexOf(columnName);
        final columnType = columnIndex >= 0 ? _jsonColumns[columnIndex]['Type'] : 'Dynamic';
        final columnRange = columnIndex >= 0 ? _jsonColumns[columnIndex]['Range'] : '';
        if (columnName == 'S/N') {
          sn = cell.value;
        }
        switch (columnType) {
          case 'Dropdown':
          // Render Dropdown for Dropdown column
            return Center(
              child: DropdownMenu<String>(
                initialSelection: '',
                dropdownMenuEntries: columnRange
                    .toString()
                    .split(',')
                    .map<DropdownMenuEntry<String>>((e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'.'))],
              ),
            );

          case 'Date':
          return  columnRange == 'Single Date' ?
          // Render Date Picker
             Align( alignment: Alignment.centerRight,
              child: Row( mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text(cell.value)),
                  TextButton(child: Icon(Icons.arrow_drop_down_circle),onPressed: (){
                      singleDateDialog(sn,columnName);
                  },),
                ],
              ),
            ) : Align( alignment: Alignment.centerRight,
            child: Row( mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Text(cell.value ?? 'Pick Date')),
                TextButton(child: Icon(Icons.arrow_drop_down_circle),onPressed: (){
                  print(sn);
                 doubleDateDialog(sn,columnName);
                },),
              ],
            ),
          );

          case 'Dynamic':
          // Render TextField for Dynamic columns
            return Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: columnName == 'S/N'
                  ? Text(cell.value.toString())
                  : const TextField(
                maxLines: 3,
              ),
            );

          default:
          // Handle unexpected column types (fallback to TextField)
            return Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const TextField(
                maxLines: 3,
              ),
            );
        }
      }).toList(),
    );
  }
 void singleDateDialog(String sn,String columnName) async{
   DateTime? selectedDate = await showDatePicker(
     context: context,
     initialDate: DateTime.now(),
     firstDate: DateTime(DateTime.now().year),
     lastDate: DateTime(DateTime.now().year+2),
   );
   String _date = '${selectedDate!.month}/${selectedDate.day}/${selectedDate.year}';
   setCellValue(int.parse(sn)-1, columnName, _date);
 }
   doubleDateDialog(sn,String columnName){
      showDateRangePicker(context: context, firstDate: DateTime(2024,03,01),
          lastDate: DateTime(DateTime.now().year+5),initialEntryMode: DatePickerEntryMode.calendarOnly)
      .then((onValue){
        String startDate = '${onValue!.start.month}/${onValue.start.day}/${onValue.start.year}' ;
     String endDate = '${onValue.end.month}/${onValue.end.day}/${onValue.end.year}';
     multipleDateString =  startDate + '-' + endDate;
     setCellValue(int.parse(sn)-1, columnName, multipleDateString);
    // notifyListeners();
      });

  }

  void setCellValue(int rowIndex, String columnName, String newValue) {
    //  print('row index ${rowIndex}');
    //  print('row lenght ${_rows.length}');
    if (rowIndex >= 0 && rowIndex < _rows.length) {
      final row = _rows[rowIndex];
     // print('Row cells: ${row.getCells()}');
      final cellIndex = row.getCells().indexWhere((cell) => cell.columnName == columnName);
     // print('cellIndex ${cellIndex}');
      if (cellIndex != -1) {
        row.getCells()[cellIndex] = DataGridCell<String>(columnName: columnName, value: newValue);
        notifyListeners(); // Refresh the grid
      }
    }
  }

}
