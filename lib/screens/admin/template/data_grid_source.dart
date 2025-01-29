import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/myshared_preference.dart';

class MyDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  List<String> _columnNames = [];
  BuildContext context;
  late String multipleDateString = 'test';

  List<Map<String, dynamic>> _jsonColumns = [];

  MyDataSource(count,this.context,this._jsonColumns) {
    _initializeRows(count);
    for(var col in _jsonColumns){
      addColumn(col['name']);
    }
    //addRow();
  }



  void _initializeRows(int rowCount) {
    print('_initializeRows');
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
    print('buildRow');
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
                onSelected: (v){
                  setCellValue(sn, columnName, v.toString());
                },
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
                  : TextField(
                maxLines: 3,
                onChanged: (value){
                  setCellValue(sn, columnName, value);
                },
              ),
            );

          default:
          // Handle unexpected column types (fallback to TextField)
            return Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: TextField(
                maxLines: 3,
                onChanged: (value) =>{
                 // setCellValue(sn, columnName, value)
                  print(sn+ ' '+ columnName+ ' '+ value)
                },
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
    setCellValue(sn, columnName, _date);
  }
  doubleDateDialog(sn,String columnName){
    showDateRangePicker(context: context, firstDate: DateTime(2024,03,01),
        lastDate: DateTime(DateTime.now().year+5),initialEntryMode: DatePickerEntryMode.calendarOnly)
        .then((onValue){
      String startDate = '${onValue!.start.month}/${onValue.start.day}/${onValue.start.year}' ;
      String endDate = '${onValue.end.month}/${onValue.end.day}/${onValue.end.year}';
      multipleDateString =  startDate + '-' + endDate;
      setCellValue(sn, columnName, multipleDateString);
      // notifyListeners();
    });

  }

  void setCellValue(String sn, String columnName, String newValue) {
    int  rowIndex = int.parse(sn)-1;
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